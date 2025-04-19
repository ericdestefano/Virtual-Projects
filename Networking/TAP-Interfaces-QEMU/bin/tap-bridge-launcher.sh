#!/bin/sh

QEMU_NAME=template
QEMU_PHYSICAL_INTERFACE=vmnet8
QEMU_BRIDGE_NAME=$QEMU_NAME-br

echo "Building TAP interface for virtual machine use"

#Confirm commands we need to use exist
confirm_command () {
  if command -v "$1" &>/dev/null; then
    echo "$1 command confirmed, moving on"
  else
    echo "$1 command not found, please install"
    exit 1
  fi
}

confirm_command sudo
confirm_command ip
confirm_command brctl

#Confirm non-tap interface we want to bridge with exists
confirm_physical_interface () {
  if ip link show "$1" &>/dev/null; then
    echo "Physical Interface $1 to bridge with exists, moving on..."
  else
    echo "Bridge Interface not available, please make sure $1 exists"
  fi
}

confirm_physical_interface $QEMU_PHYSICAL_INTERFACE

#Confirm if $QEMU_NAME interface has already been created
confirm_tap_interfaces () {
  if ip link show "$1" &>/dev/null; then
    echo "$1 exists, moving on"
  else
    echo "$1 does not exist, creating..."
    sudo ip tuntap add mode tap user $USER group $USER name $QEMU_NAME
    echo "Activating $1"
    sudo ip link set $1 up
  fi
}

confirm_tap_interfaces $QEMU_NAME

#Bridge time
echo "Let's build a bridge"
if ! brctl show | grep -q "^$QEMU_BRIDGE_NAME"; then
  echo "Creating Bridge $QEMU_BRIDGE_NAME"
  sudo brctl addbr $QEMU_BRIDGE_NAME
  sudo brctl addif $QEMU_BRIDGE_NAME $QEMU_NAME $QEMU_PHYSICAL_INTERFACE
  sudo ip link set $QEMU_BRIDGE_NAME up
else
  echo "Bridge already exists, moving on..."
  exit 0
fi

#Start QEMU goes here
#qemu-system-ppc ...

exit 0
