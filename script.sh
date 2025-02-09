#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo)."
  exit 1
fi

echo "Updating the system..."
xbps-install -Syu

echo "Installing required packages..."
xbps-install -y base-devel linux-headers open-vm-tools open-vm-tools-desktop

echo "Enabling VMware services..."
ln -s /etc/sv/vmtoolsd /var/service/
ln -s /etc/sv/vmware-vmblock-fuse /var/service/

echo "Mounting VMware Tools disk (if present)..."
VMWARE_TOOLS_PATH=$(find /media/$USER -name "VMware Tools*" 2>/dev/null)

if [ -z "$VMWARE_TOOLS_PATH" ]; then
  echo "VMware Tools disk not found. Please attach the disk manually from VMware settings."
  exit 1
fi

echo "Navigating to the VMware Tools path: $VMWARE_TOOLS_PATH"
cd "$VMWARE_TOOLS_PATH" || exit 1

echo "Extracting VMware Tools package..."
tar -xf VMwareTools*.tar.gz -C /tmp

echo "Running the VMware Tools installer..."
cd /tmp/vmware-tools-distrib || exit 1

sudo ./vmware-install.pl -d

echo "VMware Tools installation complete!"
echo "Please restart the virtual machine for fullscreen and copy-paste to work."
