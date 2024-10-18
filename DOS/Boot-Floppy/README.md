# Boot Floppy

The **Boot Floppy** is designed to help bootstrap systems like OS/2, Windows, Windows NT, and others. Built on **MS-DOS 5.0**, this disk includes essential utilities such as **FDISK**, **EDIT**, and **FORMAT**.

## Purpose

This Boot Floppy serves as a foundational tool for initializing various operating systems. It assumes the user has a working DOS installation.

## Reference

For full details on creating the base MS-DOS 5.0 system, see the [MS-DOS 5.0 README.md](README.md).

## Key Utilities

- **FDISK**: Used for partitioning hard drives.
- **EDIT**: A full-screen text editor for creating and modifying text files.
- **FORMAT**: Prepares storage media for use by the operating system.

## Building the Boot Floppy

Instructions on how to build the Boot Floppy will reference the information in the MS-DOS 5.0 README.md, ensuring you have all the necessary steps and components without redundancy.

Follow these steps to create a bootable floppy disk image that includes essential DOS utilities and CD-ROM drivers.

1. **Boot the MS-DOS 5.0 VirtualBox VM**.

2. **Mount a 3.5-inch 720K floppy disk image** to the VirtualBox VM's Floppy Drive.
   - A blank image is preferred, but if not, run the following command after mounting it:
     ```shell
     format a: /q
     ```

3. **Make the floppy disk image bootable** by running:
   ```shell
   sys a:
   ```

4. **Create the necessary directories**:
   - ```shell
     mkdir a:\DOS
     ```
   - ```shell
     mkdir a:\cdrom
     ```

5. **Copy essential DOS programs** for later Operating System setups:
   ```shell
   copy c:\DOS\edit.exe a:\DOS
   copy C:\DOS\format.exe a:\DOS
   copy C:\DOS\fdisk.exe a:\DOS
   copy c:\DOS\himem.sys a:\DOS
   copy c:\DOS\setver.exe a:\DOS
   copy c:\DOS\sys.exe a:\DOS
   ```

6. **Copy the CD-ROM drivers, CONFIG.SYS, and AUTOEXEC.BAT files**:
   ```shell
   copy c:\cdrom\*.* a:\cdrom
   copy c:\config.sys a:\
   copy c:\autoexec.bat a:\
   ```

Your bootable floppy disk is now ready for use with essential utilities for setting up other operating systems.