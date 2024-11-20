# OS X 10.11 Setup in VMWare Workstation Pro

![OS X 10.11 VMware](images/OSX1011.PNG)

### 1. Personal History
With its release on September 30, 2015, OS X 10.11 El Capitan arrived just as a new school year was in full swing, continuing Apple’s pattern of fall launches since Mac OS X 10.5 (Leopard). Given my work in an educational setting, I was likely intrigued by its features but focused on the demands of the season rather than the latest OS release.

However, El Capitan quickly distinguished itself with stability and polish, making it a standout choice—especially for virtual environments. Its performance remains smoother than many later releases in VMware, striking a useful balance: it’s fast and responsive, yet modern enough for experimenting with various software and configurations.

### 2. Prerequisites

#### **Summary** 
Before starting your installation of macOS 10.11 El Capitan in VMware, ensure you have:
- VMware Unlocker installed and configured from [this GitHub repository](https://github.com/paolo-projects/unlocker).
- Performance considerations understood for optimal setup.
- The macOS installer in DMG or ISO format, ready for VMware compatibility.

#### **VMware Unlocker**
VMware Unlocker is an essential tool for enabling macOS installations on VMware Workstation or VMware Fusion. By default, VMware does not officially support macOS as a guest operating system unless you are using VMware Fusion on a Mac. Unlocker modifies VMware's configuration files to bypass this restriction, allowing the installation of macOS on non-Mac hardware.

You can find [VMware Unlocker on GitHub](https://github.com/paolo-projects/unlocker), where the tool is maintained and updated by the Paolo Projects community. To use it:  
1. Download the latest release of VMware Unlocker from the GitHub repository.  
2. Follow the installation instructions specific to your platform (Windows or Linux).  
3. Restart VMware Workstation to enable macOS support.

**Note**: It's crucial to verify the authenticity of the repository and ensure that you're using the correct version compatible with your VMware setup.

#### Performance Considerations for Optimal Setup
macOS 10.11 El Capitan is widely regarded as the last best release for running macOS in VMware due to its balance of modern features and low system resource demands. Here's why:
- **Performance Efficiency**: El Capitan is less resource-intensive compared to later versions like macOS Sierra or High Sierra, which introduced features requiring more advanced hardware.
- **Compatibility**: El Capitan remains fully functional with VMware tools for optimized integration, including support for shared folders, clipboard sharing, and better graphics performance.
- **Stability**: The maturity of El Capitan's codebase and its compatibility with both older and newer hardware make it a robust choice for virtualization, especially on systems with constrained resources.T

1. **CPU and Core Allocation**:  
   Assign at least **1 CPU with 4 cores** or more, depending on your host system's capacity. Increasing the number of cores can improve responsiveness and multitasking within the VM.

2. **Memory Allocation**:  
   Set the RAM to **8192MB (8GB)** or higher for smooth operation. macOS 10.11 benefits significantly from additional memory, particularly when running resource-intensive applications.

3. **Disk Configuration**:  
   Use a **40GB virtual hard disk** and ensure it is dynamically allocated. This approach conserves host system space while providing flexibility as the VM's needs grow.

4. **Graphics Settings**:  
   macOS VMs have limited support for VMware's 3D acceleration due to driver constraints. While enabling 3D acceleration may provide minor visual improvements, such as smoother mouse movement and display scaling, it does not deliver the full benefits seen with Windows or Linux VMs. Installing VMware Tools enhances integration but does not significantly improve graphics performance.

By optimizing these settings, you can achieve better performance and usability with macOS El Capitan in your VMware environment.

#### **Installer Format**
Depending on your source, you may have the macOS installer in different formats. Here's how to prepare it for VMware:

1. **.APP File (macOS installer)**: If you have a macOS installer application (typically downloaded from the Mac App Store), you'll need to convert it to an ISO or DMG format to make it compatible with VMware.
    - **Convert to DMG**:  
      Open Terminal on macOS and run:  
      ```bash
      hdiutil create -volname Install_macOS_El_Capitan -srcfolder /path/to/installer.app -ov -format UDZO /path/to/output.dmg
      ```
    - **Convert DMG to ISO** (if needed for VMware):  
      ```bash
      hdiutil convert /path/to/dmg.dmg -format UDTO -o /path/to/output.iso
      mv /path/to/output.iso.cdr /path/to/output.iso
      ```

2. **DMG File**: If you already have the installer in DMG format, you can use it directly in VMware Workstation by mounting it as a virtual drive during installation.

3. **ISO File**: VMware directly supports ISO files, so this format is ideal. If you start with a DMG, the steps above will ensure proper conversion.

### 3. Key Changes in OS X 10.11 El Capitan

1. **Metal Graphics API**: El Capitan introduced Apple’s Metal API to the Mac, providing developers with lower-level access to the GPU. This resulted in faster graphics rendering, reducing overhead for applications with high graphical demands. Native apps, like Photos and some games, benefited from these optimizations, making macOS feel faster and more responsive overall.

2. **Improved System Performance**: Apple enhanced system performance across the board, promising up to 40% faster app launches, better app-switching speeds, and reduced time for file opening and PDF rendering. These optimizations weren’t tied to any significant new features but instead came from a focus on refining core system operations, aligning with El Capitan’s reputation for speed and reliability.

3. **Enhanced Mission Control and Window Management**:
   - **Mission Control**: Apple re-engineered Mission Control to streamline the way users view and interact with open applications and desktops. Unlike Yosemite, which had overlapping windows, El Capitan introduced a more organized, layered approach to arranging windows—perfect for users managing multiple windows in a virtual machine setup.
   - **Split View**: For the first time, macOS users could run two apps side-by-side in full-screen mode. This feature allowed better multitasking without switching between windows constantly, which can be beneficial in a virtual machine, where screen space can be at a premium.

4. **Application-Level Improvements**:
   - **Spotlight Search Enhancements**: Spotlight search became more intuitive, with natural language support for queries, which allowed users to search for things like "photos from last June." Spotlight also gained better integration with online results, making it a more powerful tool for file searching within virtual sessions.
   - **Notes App**: The Notes app received a substantial update, transforming it from a basic text app to a more versatile note-taking tool. Users could now add checklists, photos, and even web links, making it a handy tool for organizing information, especially in testing or research-based virtual environments.

5. **System Integrity Protection (SIP)**: SIP, or "rootless" mode, was one of the most impactful security changes in El Capitan. It restricted root-level access to critical system directories, which enhanced security by preventing malware from modifying essential system files. SIP may present challenges to virtual machine users accustomed to root-level access, but it vastly improved system security and stability.

6. **Disk Utility Redesign**: El Capitan’s Disk Utility received a streamlined, consumer-focused interface, simplifying disk management for average users but removing advanced features such as GUI-based RAID configuration, which now required command-line operations. This redesign was part of Apple’s gradual shift away from supporting server-level tools and reflected a broader move toward general consumer usability.

7. **Better Performance in Virtualization**: Thanks to its system optimizations, El Capitan became a stable, efficient choice for VMware, delivering strong performance without the resource demands of later macOS versions. This makes it an ideal option for users exploring macOS in a virtual environment.

8. **Networking Improvements**: Minor updates in Wi-Fi and network stability improved overall connectivity, crucial for virtualized environments where network reliability impacts usability.

9. **Memory Compression**: Initially introduced in Mavericks, memory compression was further refined in El Capitan. It enables the OS to compress inactive data in RAM, reducing memory pressure and maintaining system responsiveness without relying heavily on disk swapping. In virtual machines, where RAM is often limited, this feature helps optimize resource use for a smoother multitasking experience.

10. **Text and Font Rendering Improvements**:
    - **Improved Text Rendering**: El Capitan introduced font rendering optimizations, especially noticeable on Retina displays. Apple switched to the new San Francisco system font, improving readability and consistency across UI elements. These rendering improvements mean that text in virtualized sessions is sharper and more accessible for users working in different display configurations.

11. **Swift 2 for Developers**:
    - **New Features in Swift**: Apple released Swift 2 alongside El Capitan, bringing language improvements and better error handling. While not directly impacting most users, this change is beneficial for developers running El Capitan virtually to build or test software on a system compatible with Swift 2.

12. ***Auto-Hide Menu Bar Option***: 
    For users who prefer a minimalist workspace, El Capitan included the option to automatically hide the menu bar when not in use, similar to the Dock auto-hide feature.

### 4. Installation in VMware Workstation

This section provides a step-by-step guide for installing macOS 10.11 El Capitan in VMware Workstation.

#### **Creating the Virtual Machine**

1. **Create New Virtual Machine**:
   - Select **Custom** installation.
   - Proceed with the default compatibility settings by clicking **Next**.
   - Choose **I will install the operating system later**.

2. **Select Guest Operating System**:
   - Select **Apple Mac OS X** as the operating system and **OS X 10.11** as the version.

3. **Configure Virtual Machine**:
   - **Path and Name**: Choose a name and location for your virtual machine.
   - **Processors**: Assign **1 CPU** with **4 cores** (or more if resources allow).
   - **Memory**: Allocate **8192MB** (8GB) or more for optimal performance.
   - **Network Type**: Use **Network Address Translation (NAT)**. This allows the VM to work with a Microsoft Bridge Adapter, enabling compatibility with TAP interfaces and other VMs in an isolated environment.

4. **Disk Settings**:
   - **I/O Controller Types**: Select the default **LSI Logic**.
   - **Disk Type**: Choose **SATA**.
   - Create a new virtual hard disk:
     - Select **Allocate disk space later**.
     - Set the disk size to **40GB**.
     - Accept the default disk file name.

5. **Finalize and Adjust Settings**:
   - Click **Finish** to create the VM.
   - Open **Virtual Machine Settings**:
     - Under **CD/DVD**, select your macOS 10.11 ISO image.
     - Change **USB Controller** from **USB 3.1** to **USB 2.0**.

6. **Edit the .VMX File**:
   - Add the following lines to ensure mouse functionality:
     ```plaintext
     usb.generic.allowHID = "TRUE"
     mouse.vusb.enable = "TRUE"
     ```

#### **Installing macOS 10.11**

1. **Start the VM**:
   - Boot the macOS 10.11 VM from the ISO.
   - Follow on-screen prompts to select your language and accept license agreements.

2. **Prepare the Disk**:
   - At the **Install macOS** screen, only the DVD image will be visible. Move the mouse to the top menu bar and select **Disk Utility**.
   - In Disk Utility:
     - Select the **VMware Virtual SATA Hard Drive Media**.
     - Click **Erase**:
       - Name: **VMware HD** (or a name of your choice).
       - Format: **OS X Extended (Journaled)**.
       - Scheme: **GUID Partition Map**.
     - Click **Erase** and then **Done**.
   - Quit Disk Utility from the top menu.

3. **Install macOS**:
   - Return to the **Install macOS** screen.
   - Select the newly created virtual hard drive and click **Continue**.
   - macOS will install and reboot automatically.

4. **Complete Setup**:
   - Follow the post-installation setup screens to configure language, region, and user account.
   - Once macOS is installed, check for and install available system updates.

#### **Installing VMware Tools**

1. Install VMware Tools (Darwin):
   - VMware Tools is automatically downloaded if you are using VMware Unlocker.
   - Mount the **Darwin.iso** from VMware Tools and install it within the VM.
---

### **Summary**

Your macOS 10.11 El Capitan virtual machine is now installed and ready for use.