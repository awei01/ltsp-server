# LTSP Fat Client Server

Repository to setup/configure a workstation server using Ubuntu 14.04.2 and thin clients.

## Prerequisites
1. Configure network reserving a range of DHCP addresses for your client machines.
1. Download Ubuntu 14.04.2 and install it on the server.

## Setting up LTSP

Set up LTSP to provide a thin client image server.

1. Run `scripts/provision.sh`. This will take a while.
1. Boot up the thin client.

## Virtual box

1. Download `ubuntu` iso
1. Create new VirtualBox with virtual hard drive of 40GB
1. Start vm and point to ubuntu iso
1. Follow prompts to install.

### Setting up shared folder

1. Create a shared `Machine Folder` in the settings dialog box.
1. `sudo apt-get install virtualbox-guest-dkms`
1. Restart the vm.

### Networking

Set up the vm with networking capabilities to browse the internet and to allow for local network access.

1. Configure the vm to use `NAT` on its first adapter. Use the defaults.
1. Under `VirtualBox > Preferences`. Click `Network` tab and create a virtual network.
1. Set up the DHCP server.
1. Under vm settings, add a second adapter to use the virtual network.

## Troubleshooting

If your thin client cannot access the PXE server.

* From the LTSP server, tail the logs `tail /var/log/syslog -f`

* Open `/var/lib/tftpboot/ltsp/{architecture}/pxelinux.cfg/default`. Comment out `append ro initrd=initrd.img-3.13.0-46-generic...` and use the following: `append ro initrd=initrd.img-3.13.0-46-generic init=/sbin/init-ltsp root=/dev/nbd0 break=mount`. Reboot the client and you will have access to `initramfs` shell to debug.

* Check the connection: `cat /run/net-eth0.cnf`

## References

* http://ubuntuforums.org/showthread.php?t=2173749
* https://help.ubuntu.com/community/UbuntuLTSP/ltsp-pnp
