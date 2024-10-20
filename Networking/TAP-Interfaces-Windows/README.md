# TAP Interfaces for Windows
![Network Interfaces](images/Network_Interfaces.png)

## Overview
TAP (Terminal Access Point) interfaces are virtual network devices that provide a way to tunnel Ethernet frames. They are integral for using virtualization software like QEMU, Basilisk II, and SheepShaver for networking support.

TAP interfaces operate at the data link layer (Layer 2) of the OSI model, allowing for the emulation of a physical network interface. This capability enables access to various networking protocols beyond just IP, making it versatile for setups that require a broader range of network functionalities. In contrast, TUN interfaces operate at the network layer (Layer 3) and are limited to IP traffic, which means they can only handle packet forwarding based on IP addresses.

The purpose of this setup is to use TAP interfaces in a bridge with another network adapter to provide network connectivity to various virtual machines. In this guide, we will create a bridge between multiple TAP interfaces and the **VMware Workstation NAT adapter**. This approach ensures that all VMs—whether through TAP interfaces, VirtualBox, or VMware Workstation—can use a common networking setup for seamless interaction while maintaining isolation from the host machine.  This setup assumes VMware Workstation Pro is installed, as the VMware NAT adapter will be utilized for network routing.

## Steps to Setup TAP Interfaces on Windows
1. **Install OpenVPN**:
   - Download and install OpenVPN from [OpenVPN's official site](https://openvpn.net/community-downloads/).
   - During the installation, ensure that the **TAP-Windows** option is selected. This will install the TAP driver and the `tapctl.exe` utility.

2. **Create TAP Interfaces**:
   - **Using the GUI**:
     - Open the Start Menu and search for **Add a new TAP-Windows6 virtual network adapter**. This will allow you to create new TAP interfaces directly from the GUI.
   - **Using Command Line**:
     - Alternatively, you can use Command Prompt with administrative privileges. Use the following command to create multiple TAP interfaces (adjust the names as needed):
       ```shell
       devcon install "C:\Windows\System32\DRIVERS\tap0901.sys" tap0902
       devcon install "C:\Windows\System32\DRIVERS\tap0901.sys" tap0903
       devcon install "C:\Windows\System32\DRIVERS\tap0901.sys" tap0904
       devcon install "C:\Windows\System32\DRIVERS\tap0901.sys" tap0905
       ```
   - **Renaming TAP Interfaces**:
     - It is recommended to rename the TAP interfaces for better organization. You can rename them from **OpenVPN TAP-Windows6** and **OpenVPN TAP-Windows6 #1** to **TAP0**, **TAP1**, etc...

3. **Configure Networking**:
   - Make sure the TAP interfaces are properly configured in Windows.
   - You can use Wireshark to examine the interface traffic, while the VMware NAT interface will manage routing.

4. **Bridge TAP Interfaces with VMware NAT Adapter**:
   - Open the **Network Connections** control panel by searching for **Network Connections** in the Start Menu.
   - Select all the TAP interfaces you created (hold down the `Ctrl` key to select multiple interfaces), along with the **VMware Network Adapter VMnet8** (which is the default NAT adapter in VMware Workstation).
   - Right-click on one of the selected interfaces and choose **Bridge Connections**. This will create a network bridge that includes both the TAP interfaces and the VMware NAT adapter.

5. **Ensure Isolation**:
   - The bridged interface should not run IPv4 or IPv6 services. This configuration helps isolate the host machine and prevent cross-networking issues between the host and the VMs.

## Conclusion
Using TAP interfaces provides greater flexibility and access to a range of networking protocols, making them a better choice than TUN interfaces for setups that require interaction beyond IP traffic.