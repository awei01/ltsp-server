#!/usr/bin/env bash

cat <<END
|------------------------------------
| Update LTSP client kernels
|------------------------------------
END

# Loop through all the folders in
CONFS="/opt/ltsp/i386/boot/pxelinux.cfg"
if [ ! -d $CONFS ]; then
	echo "Cannot locate client boot files in [$CONFS]"
	return 1
fi

SEARCH="^\(ipappend\)\{1\} 2$"
if grep -q "$SEARCH" "$CONFS/ltsp"; then
	echo "Fixing ipappend configuration..."
	sudo sed -i -- "s/$SEARCH/\1 3/" $CONFS/*
fi

echo "Updating kernels..."
sudo ltsp-update-kernels

cat <<END
|------------------------------------
| Done
|------------------------------------
END
