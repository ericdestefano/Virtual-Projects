#Fun with X11 in Ubuntu Desktop 25.04

### 1. Personal History

I have always been a contrarian on the cutting edge - wanting to work with the latest and greatest, but on the most uncommon platform it would run on. Linux is big on x86? I’m going with PowerPC. The list goes on and on.

In this situation, it is the reverse - the world has moved on from X11/xorg, at least in concept, to Wayland among the bigger distributions out there. Even if I prefer the built-in X11/xorg option when logging in (which I most certainly don’t from a real hardware perspective), my display manager will still be Wayland-based.

Sadly, one area that has not caught up to this modern display protocol is remote management. Most of the tools I use, like DWAgent (from DWService) and NoMachine, claim to support Wayland, but in practice, they don’t work well - rendering my remote orchestration abilities dead on arrival. Of course, there are always remote SSH X11 sessions, but sometimes I just need or want full access to a Linux distro’s graphical console.


### 2. A Simple Change

Ubuntu 25.04 makes it fairly simple to switch from a Wayland-based session to an X11-based one.

Install the `gnome-session-xsession` package, which provides the components that allow GDM to offer and start X11 (Xorg) sessions instead of Wayland:  
`sudo apt-get install gnome-session-xsession`

Edit `/etc/gdm3/custom.conf` and uncomment the following line to disable Wayland and default to X11:  
`WaylandEnable=false`

Then either reboot the system:  
`sudo reboot`  

Or restart GDM3 directly:  
`sudo systemctl restart gdm3`