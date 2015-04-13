# LTSP Fat Client Server

## Prerequisites
1. Set up the server. I installed using Ubuntu 14.04.2.

1. Set up the networking with static ip address like the following:
```
auto eth0
iface eth0 inet static
    address 10.1.10.11
    netmask 255.255.255.0
    network 10.1.10.0
    gateway 10.1.10.1
    dns-nameservers 75.75.75.75 75.75.76.76
```

1. Update and upgrade server: `apt-get update` and `apt-get upgrade`

## Provision

1. Install `openssh-server` so we can remotely manage the server: `apt-get install openssh-server`

1. ? Point to correct ppa repository: `add-apt-repository ppa:alkisg/ppa`

1. ? Update with new repository: `apt-get update`

1. Install `ltsp-server` so we can build/serve fat clients: `apt-get install ltsp-server`

1. Uninstall `tftpd-hpa` because it will conflict with `dnsmasq` which has it's own tftp server. `apt-get purge tftpd-hpa`. Alternatively stop `tfptd-hpa` daemon.

1. Install `dnsmasq`: `apt-get install dnsmasq`

## Build base client

1. Configure `/etc/ltsp/ltsp-build-client.conf` using `./configs/ltsp/ltsp-build-client.conf` provided here

1. Build your basic client image with root pass: `ltsp-build-client --skipimage --prompt-rootpass`

1. Backup the base client: `tar -cvzf ltsp_chroot.tgz --one-file-system --exclude=/lost+found /opt/ltsp/i386`

1. Restore the base client: `tar -xvzf ltsp_chroot.tgz -C /`

1. Initialize dnsmasq config `/etc/dnsmasq.d/ltsp-server-dnsmasq.conf`: `ltsp-config dnsmasq`

1. Update `/etc/dnsmasq.d/ltsp-server-dnsmasq.conf`. Comment this out otherwise DNS doesn't work `port=0`

## Configure client

1. Chroot into fat client: `ltsp-chroot -c -p`

1. Install whatever other packages are needed:
```

```
1. Exit chroot: `exit`

1. Update `/opt/ltsp/i386/boot/pxelinux.cfg/ltsp`:
```
#default ltsp-NBD
#ontimeout ltsp-NBD
default ltsp-NFS
ontimeout ltsp-NFS

label ltsp-NFS
menu label LTSP, using NFS
kernel vmlinuz-3.13.0-49-generic
#append ro initrd=initrd.img-3.13.0-48-generic init=/sbin/init-ltsp quiet splash root=/dev/nfs ip=dhcp boot=nfs
append rw initrd=initrd.img-3.13.0-48-generic init=/sbin/init-ltsp quiet splash root=/dev/nfs nfsroot=/opt/ltsp/i386 ip=dhcp boot=nfs
ipappend 3

## Set up NFS

1. On LTSP server, install `nfs-kernel-server`: `apt-get install nfs-kernel-server`

1. Configure `/etc/exports`

```
# Use following to allow NFS share of read-only client filesystem
#/opt/ltsp 		*(ro,no_root_squash,async,no_subtree_check)

# Use following to allow NFS writeable share of client filesystem
# N.B. Must also modify /opt/ltsp/i386/boot/pxelinux.cfg/ltsp to use read/write mount
#/opt/ltsp 		*(ro,no_root_squash,async,no_subtree_check)

# Share the home folder
/home 			*(rw,sync,no_subtree_check)

```

1. Restart `nfs`: `service nfs-kernel-server restart`

1. Create the `lts.conf` file: `ltsp-config lts.conf`

1. Update `/var/lib/tftpd/i386/lts.conf`:
```
FSTAB_0="server:/home           /home           nfs             defaults,nolock         0       0"
```

## Install Google Chrome
Reference: http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line
1. sudo apt-get install libxss1 libappindicator1 libindicator7
1. wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
1. apt-get install libcurl3 xdg-utils
1. sudo dpkg -i google-chrome*.deb

# Troubleshooting

* remove `quiet splash` from kernel configs `/var/lib/tftpboot/i386/pxelinux.cfg/default`

* `Error: Socket failed: Connection refused`: Ensure kernel configs `/var/lib/tftpboot/i386/pxelinux.cfg/default` has `ipappend 3`

* `/sbin/init-ltsp: 15 /usr/share/ltsp/init-ltsp.d ... cannot create` Authenticates and then restarts gdm. Verify `/etc/exports` of client image has `no_root_squash`



hi, when my fat client desktop is locked, how do i log back in? it's looking for a user local to the fat client instead of the user from the server.
[15:02] <vagrantc> !hashpass
[15:03] <ltsp> Error: "hashpass" is not a valid command.
[15:03] <vagrantc> awei: you need a very recent version of ltsp and ldm that supports LDM_HASHPASS
[15:03] <vagrantc> or, you need to configure your environment to run the screen locker as a remoteapp
[15:04] == gbaman_ [~gbaman@members.unit1.farsetlabs.org.uk] has joined #ltsp
[15:04] == gbaman [~gbaman@members.unit1.farsetlabs.org.uk] has quit [Read error: Connection reset by peer]
[15:04] <awei> vagrantc: i'm running 5.5.1-1ubuntu2
[15:05] <vagrantc> that's too old
[15:05] <awei> vagrantc: ok, is which repo should i point to?
[15:05] <vagrantc> !ppa
[15:05] <ltsp> I do not know about 'ppa', but I do know about these similar topics: 'sbalneav-ppa', 'greek-schools-ppa'
