## 1. The Problem

> *Captain's log, stardate 54274.7. Lieutenant Torres has finally convinced me that I can't put off a major maintenance overhaul any longer.*

Inherited systems are a pillar of enterprise life—echoes of decisions made decades ago, back when the future of networking was supposedly Ethernet running TCP/IP in a Token Ring/IPX-SPX world.

Fast-forward to today, and one such relic is a fleet of database servers that have run uninterrupted for far too long. Then something happened. My file server cluster experienced a failure.

That’s expected. In enterprise computing, redundancy is table stakes. Most of my Linux systems recovered cleanly during the failover—brief CIFS interruptions, some log noise, and that’s it. But not my four Oracle database servers.

They froze.

More specifically, the CIFS mount froze in a very predictable way:
- An interruption occurs  
- The port 445 socket stays jammed open  
- No amount of `kill -9` will get you back

The culprit?  
A nasty CIFS client issue in **kernel 4.12.14-197.21-default**, which shipped with **SUSE Linux Enterprise 15.1 SP1**. SUSE did eventually provide a patch (`4.12.14-197.78-default`), but that meant downtime—something these aging, high-risk databases couldn’t afford until the moment was right.

Even then, there was no guarantee the patch would *truly* resolve it. So I needed a **Plan B**—a workaround that could serve both as:
- A **fallback**, in case the patch didn’t hold  
- A **permanent new path**, if this problem reared its head again

That workaround is what I call:

> **The NFS-to-CIFS Bridge**

## 2. The Fix

The solution wasn’t obvious at first—and in typical fashion, everything that *should have worked* didn’t.

### The Core Objective

I needed to:

- Provide an **NFS export** to Oracle servers  
- Use a **Linux server as an intermediary**  
- Mount a **Windows CIFS share** on that server  
- Preserve **UID/GID mappings**  
- Ensure **POSIX-like permissions**  
- Maintain correct file timestamps: `atime`, `mtime`, `ctime`

Straightforward on paper—until you try to do it. NFS refuses to export a CIFS-mounted directory. The kernel flat-out blocks it, and that’s because CIFS doesn’t behave like a real POSIX filesystem. It breaks too many expectations: inodes, permissions, ownership, timestamps—it’s not designed for this.

So I went looking for something that could sit between the two worlds and make the lie look real.

---

### Attempts & Failures

1. **Standard NFS export of CIFS mount**  
   Didn’t work. Not even close. The kernel shuts it down immediately.

2. **`convmvfs` (FUSE-based encoding layer)**  
   I could mount it, I could write files, but anything that needed to set a timestamp (like `touch -d`) failed.  
   Turns out `convmvfs` doesn’t properly support `utimensat()`—which matters.

3. **Tuning mount options and forcing UID/GID**  
   I tried hardcoding ownership, adjusting permission masks—you name it.  
   It still wasn’t right. Permissions didn’t behave correctly, and timestamps were hit or miss.

---

### The Breakthrough: `bindfs`

That’s when I pivoted to `bindfs`.

`bindfs` is a FUSE filesystem that mirrors another directory but lets you override ownership, permissions, and other behavior. People usually use it for shared mounts or multi-user setups—but here, I used it to **fake a clean, POSIX-compliant view** of a CIFS share.

The idea:
- Mount the CIFS share at `/mnt/cifs`
- Overlay it with `bindfs` at `/mnt/nfs`
- Export `/mnt/nfs` via NFS

With that in place:
- UID/GID mappings looked correct
- `chmod`, `chown`, and even `touch -d` worked the way they should
- Timestamps behaved normally, even with the underlying CIFS share

bindfs did exactly what I needed: it made CIFS look like POSIX to NFS, and the Oracle servers were none the wiser.

---

### The Boot-Time Catch

There was still one last problem: **timing**.

If `bindfs` mounted before the CIFS share was ready, it failed.  
If NFS started before `bindfs` was mounted, it served an empty export.

systemd could’ve handled this, maybe—but not in the time I had. Too many moving parts. Too many assumptions. I needed something that would **just work**.

So I went with what I know works:

- Wrote a script in `/usr/local/sbin/mount-bindfs.sh`
- Threw in a `sleep 60` to let things settle
- Called it from `/etc/rc.local`
- Mounted `bindfs`, then started the NFS server by hand

It’s old-school, but it’s predictable. The Oracle servers stay happy. The fallback works. The bridge holds.


## 3. Architecture & Implementation

This section outlines how the bridge is assembled—what packages are needed, how mount points are structured, and how everything ties together at boot. This isn't a throwaway hack. It's stable, repeatable, and designed to tolerate the quirks of CIFS while presenting clean NFS exports to Oracle.

---

### Getting Started

This was built and tested on a **Debian 12** host (`nfs-cifs-01.local`).

#### Required Packages

```bash
apt-get update
apt-get install bindfs nfs-kernel-server cifs-utils
```

---

### Directory Layout

- All **CIFS mounts** live under: `/mnt`
- All **bindfs overlays** (exported via NFS) live under: `/exports`

This gives clean separation between raw and polished layers.

---

### CIFS Mounts (`/etc/fstab`)

```fstab
//cifs-01.local/archive01$     /mnt/archive01_cifs     cifs credentials=/root/.cred/oracle,uid=oracle,gid=shared,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
//cifs-01.local/archive02$     /mnt/archive02_cifs     cifs credentials=/root/.cred/oracle,uid=oracle,gid=shared,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
//cifs-01.local/archive03$     /mnt/archive03_cifs     cifs credentials=/root/.cred/oracle,uid=oracle,gid=shared,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
//cifs-01.local/maildata$      /mnt/maildata_cifs      cifs credentials=/root/.cred/oracle,uid=oracle,gid=shared,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
//cifs-01.local/acctrecv$      /mnt/acctrecv_cifs      cifs credentials=/root/.cred/oracle,uid=oracle,gid=shared,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
//cifs-01.local/oradata$       /mnt/oradata_cifs       cifs credentials=/root/.cred/oracle,uid=oracle,gid=oradata,vers=3.0,file_mode=0775,dir_mode=0775,allow_other,perms=0775,nonempty,x-systemd.automount 0 0
```

---

### NFS Exports (`/etc/exports`)

```exports
/exports/archive01_nfs   192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=101)
/exports/archive02_nfs   192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=102)
/exports/archive03_nfs   192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=100)
/exports/acctrecv_nfs    192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=103)
/exports/maildata_nfs    192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=104)
/exports/oradata_nfs     192.168.1.10(rw,sync,no_subtree_check,no_root_squash,fsid=105)
```

---

### Boot-Time Mounting

To avoid race conditions, `bindfs` mounts only after CIFS has stabilized. `systemd` was avoided in favor of a simpler, more predictable approach.

#### `/usr/local/sbin/mount_bindfs.sh`

```bash
#!/bin/bash

echo "Sleeping 60 seconds while CIFS gets itself in order"
sleep 60

bindfs --perms=a+rX -o allow_other /mnt/archive01_cifs /exports/archive01_nfs
bindfs --perms=a+rX -o allow_other /mnt/archive02_cifs /exports/archive02_nfs
bindfs --perms=a+rX -o allow_other /mnt/archive03_cifs /exports/archive03_nfs
bindfs --perms=a+rX -o allow_other /mnt/maildata_cifs  /exports/maildata_nfs
bindfs --perms=a+rX -o allow_other /mnt/acctrecv_cifs  /exports/acctrecv_nfs
bindfs --perms=a+rX -o allow_other /mnt/oradata_cifs   /exports/oradata_nfs

echo "All bindfs mounts completed."
echo "Starting NFS Server"
systemctl start nfs-server
```

#### `/etc/rc.local`

```bash
#!/bin/sh -e
/usr/local/sbin/mount_bindfs.sh
exit 0
```

Enable the service:

```bash
systemctl enable rc-local
```

This setup results in a working bridge that maps CIFS shares to clean, stable NFS exports using bindfs and a delayed mount strategy.
