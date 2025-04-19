# QEMU TAP/Bridge Launch Script

### Personal History

TAP interfaces have played a big part in my computing adventures, starting from a fascinating IPv6 networking project back in 2017. Since then, TAP has become my go-to for all things QEMU, especially when deep diving vintage operating systems.

To me, networking adds a whole new dimension to computing, from the simple local LANs I built as a young person, to accessing the Internet—the very thing that put a PC on everyone’s desk in the late '90s and early 2000s.

Why TAP instead of TUN? Simply put, TAP interfaces operate at Layer 2 (Ethernet frames), allowing virtual machines to behave exactly like physical computers plugged into a real LAN. TUN, which operates at Layer 3 (IP packets), works well for routing and VPNs but negates the possibilities for working with network protocols outside of TCP/IP.

TAP allows my virtual setups to explore everything from IPX/SPX and NetBIOS to AppleTalk—unrestrained regarding the kind of networking adventures I wish to pursue, no matter how old.

Admittedly, my shell scripting skills have always lagged behind my enthusiasm. While serviceable, scripting was never my first computing language, and mastering it has been a slow, rewarding evolution. This project has become a perfect chance to strengthen those skills, refining my scripts to automate what I used to handle manually.

The result is a structured approach: my QEMU launch scripts—one for booting from CDs, another for hard drives—now handle network setup seamlessly, ensuring TAP interfaces and bridges are ready ahead of time. Integrating these QEMU setups with VMware and VirtualBox environments on my network provides the consistent, immersive experience I’ve always aimed for.

---

### `tap-bridge-launcher.sh`

The script is structured clearly and breaks down into the following sections:

- **Global Variables**
- **Function to confirm CLI applications/utilities are installed**
- **Function to confirm the “physical” interface intended for bridging exists**
- **Function to check if the TAP interface already exists, and create it if not**
- **Function to check if the BRIDGE interface already exists, and create it if not**
- **Launch QEMU**
