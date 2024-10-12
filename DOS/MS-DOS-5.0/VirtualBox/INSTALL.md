# VirtualBox Setup for MS-DOS 5.0

This document provides essential information for configuring MS-DOS 5.0 in a VirtualBox environment.

## VirtualBox Configuration

The **VirtualBox configuration file** (`MS-DOS 5.0.vbox`) will be included in this folder. It contains settings optimized for running MS-DOS 5.0.

### Recommended Virtual Machine Settings:
- **RAM**: 4 MB (sufficient for MS-DOS 5.0)
- **Storage**: 50 MB virtual IDE Hard Drive
- **Video Memory**: 16 MB

## Initial Installation Guide 

1. **Download MS-DOS 5.0**: Ensure you have the disk image files for MS-DOS 5.0. You can find these online.
   
2. **Create the Virtual Machine (VM)**: Set up a new VM in VirtualBox using the recommended settings:
   - **RAM**: 4 MB
   - **Storage**: 50 MB virtual IDE Hard Drive
   - **IDE CD-ROM Drive**: Ensure an IDE CD-ROM is attached for later use.

3. **Boot the VM**: Attach the MS-DOS 5.0 Disk 1 to the VM and boot from it.

4. **Exit the Setup**: 
   - When the "Welcome to Setup" screen appears, press `F3` to exit the installer.
   - Confirm by pressing `Y` to leave the setup.

5. **Run FDISK**: 
   - At the command prompt, type `fdisk` and press Enter.

6. **Create a Partition**:
   - Choose option `1` for "Create a DOS partition or Logical DOS Drive."
   - Press `1` again to create a Primary DOS Partition.

7. **Set Maximum Partition Size**: 
   - When prompted to use the maximum available size for the Primary DOS Partition and make it active, press Enter.

8. **Reboot the VM**: 
   - You'll be notified that the system will restart. Press any key to reboot.

9. **Exit the Setup Again**: 
   - After rebooting, you'll return to the setup screen. Press `F3` and confirm again to exit.

10. **Format the Hard Drive**:
    - At the command prompt, type `format c:` and press Enter.
    - Confirm by pressing `Y` to proceed with formatting.

11. **Disk Label**: 
    - You may enter a disk label or press Enter to continue without naming the drive.

12. **Start MS-DOS Setup**: 
    - To begin the installation, type `setup` and press Enter.
    - Follow the prompts, confirming the installation directory and date/time as needed.
    - Insert the appropriate disk images when prompted and remove them as directed.

13. **Optional: Disable DOS Shell at Startup**:
    - After the installation, the system will boot into **DOS Shell** by default. If you prefer not to use DOS Shell at startup, follow these steps:
      - Press `ALT+F` and select **Exit**.
      - Type `edit c:\autoexec.bat` and press Enter.
      - Use the arrow keys to navigate and backspace to delete the last line: `C:\DOS\DOSSHELL`.
      - Save the file by pressing `ALT+F`, selecting **Save**, and then **Exit**.

14. **Final Step**: 
    - Reboot your system. Your MS-DOS 5.0 installation is now complete and ready for use.

## Configuration Files
With your MS-DOS 5.0 system ready for use, you can make these changes for a better experience.

### CONFIG.SYS

The **C:\CONFIG.SYS** file is critical for managing system settings and memory allocation. Below are recommended settings for MS-DOS 5.0:
DEVICE=C:\DOS\HIMEM.SYS 
DEVICE=C:\DOS\EMM386.EXE NOEMS DOS=HIGH, UMB
- **HIMEM.SYS**: Enables the use of extended memory.
- **EMM386.EXE**: Provides expanded memory management.
- **DOS=HIGH, UMB**: Loads DOS into high memory, allowing more conventional memory for applications.

### AUTOEXEC.BAT

The **C:\AUTOEXEC.BAT** file is used for setting up the environment variables and loading necessary drivers at boot time. Suggested contents include:
SET TEMP=C:\TEMP SET PATH=C:\DOS;C:\UTILS DOSKEY
- **SET TEMP**: Defines the temporary file directory.
- **SET PATH**: Specifies directories for command execution.
- **DOSKEY**: Loads the command-line editor.

## Optional: CD-ROM Support

While not required, enabling CD-ROM support can make working with CD-based media much easier. Follow these steps to set up the CD-ROM driver in your MS-DOS 5.0 environment.

1. **Download the CD-ROM Driver and Microsoft CD Extensions Application**:
    - [oakcdrom.sys CD-ROM driver](https://archive.org/details/cd-driver-1.25)
    - [MSCDEX 2.23](https://archive.org/details/mscdx223)

2. **Prepare a Disk Image for CD-ROM Drivers**:
    - Make a copy of one of your existing MS-DOS disk images.
    - Rename the copied disk image to `CDROM Driver.img`.
    - Mount this disk image in VirtualBox with MS-DOS 5.0 running.
    - Quick format the disk with the command: 
      ```bash
      FORMAT a: /q
      ```
    - Unmount the disk from VirtualBox.
    - If you're using Windows, double-click the disk image to mount it in Windows.
    - Copy both `OAKCDROM.SYS` and `MSCDEX.EXE` to the mounted disk image.
    - Unmount the disk image after copying the files.

3. **Install ImDisk (Windows only)**:
    - Download and install ImDisk from [this link](https://sourceforge.net/projects/imdisk-toolkit/files/latest/download).

4. **Mount the Disk Image Using ImDisk**:
    - Right-click on the blank disk image file and select **Mount as ImDisk Virtual Disk**.
    - In the ImDisk interface, leave all options at their default and click OK.

5. **Copy the CD-ROM Driver Files**:
    - Copy the `oakcdrom.sys` and `mscdex.exe` files to the mounted ImDisk virtual drive.

6. **Unmount the Virtual Disk**:
    - Right-click the drive that was mounted as a virtual disk and select **Unmount ImDisk Virtual Disk**.

7. **Remount the Disk in VirtualBox**:
    - Attach the disk image again in the MS-DOS 5.0 session running in VirtualBox.

8. **Set Up the CD-ROM Driver**:
    - In MS-DOS, create a directory for the CD-ROM driver:
      ```bash
      mkdir c:\cdrom
      ```
    - Copy the driver files into the new directory:
      ```bash
      copy a:\oakcdrom.sys c:\cdrom
      copy a:\mscdex.exe c:\cdrom
      ```
    - Unmount the floppy disk image from VirtualBox.

9. **Configure the System Files**:
    - Open and edit `c:\config.sys`:
      ```bash
      edit c:\config.sys
      ```
    - Append the following line at the bottom:
      ```bash
      DEVICE=C:\CDROM\OAKCDROM.SYS /D:VMCD01
      ```

    - Open and edit `c:\autoexec.bat`:
      ```bash
      edit c:\autoexec.bat
      ```
    - Append this line at the bottom:
      ```bash
      C:\cdrom\mscdex.exe /D:VMCD01
      ```

10. **Reboot the System**:
    - After rebooting, your MS-DOS 5.0 virtual environment will have CD-ROM support enabled.

## Additional Resources

For more detailed information about VirtualBox and DOS commands, please refer to:
- [MS-DOS Commands Reference](https://www.computerhope.com/msdos.htm)
For more detailed information about Microsoft's MSCDEX.EXE for MS-DOS 5.0, please refer to:
- https://hwiegman.home.xs4all.nl/msdos/79247.htm