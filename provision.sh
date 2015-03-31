#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source global-functions.shinc

cat <<END
|------------------------------------
| Install LTSP Fat Client Server
|------------------------------------
END

# Install SSH Server
REQUIRE_PKG "openssh-server"

# Install LTSP Server
REQUIRE_PKG "ltsp-server"

# Install dnsmasq
REQUIRE_PKG "dnsmasq"

# Add dnsmasq configuration for LTSP
CONFIG="/etc/dnsmasq.d/ltsp-server-dnsmasq.conf"
if ! FILE_EXISTS $CONFIG; then
	echo "Initializing dnsmasq configuration..."
	sudo ltsp-config dnsmasq
fi

# Modify dnsmasq configuration if needed and restart
if grep -q -e "^\(enable-tftp\|port=0\)\{1\}" $CONFIG; then
	echo "Configuring dnsmasq..."
	sed -i -r "s/^(enable-tftp|port=0)$/# \1/" $CONFIG
	echo "Restarting dnsmasq..."
	sudo service dnsmasq restart
fi

cat <<END
|------------------------------------
| Done
|------------------------------------
END
