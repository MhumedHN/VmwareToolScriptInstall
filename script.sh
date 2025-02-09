#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo)."
  exit 1
fi

echo "Updating the system..."
xbps-install -Syu

echo "Installing required packages for VMware Tools..."
xbps-install -y base-devel linux-headers open-vm-tools open-vm-tools-desktop

echo "Enabling VMware services for shared clipboard and fullscreen support..."
ln -s /etc/sv/vmtoolsd /var/service/
ln -s /etc/sv/vmware-vmblock-fuse /var/service/

echo "Starting VMware services..."
sv up vmtoolsd
sv up vmware-vmblock-fuse

echo "VMware Tools installation and setup complete!"
echo "Please restart the virtual machine to enable fullscreen and clipboard features."
