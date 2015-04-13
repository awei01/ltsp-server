#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source global-functions.shinc

cat <<END
|------------------------------------
| Provision LTSP Fat Client Server
|------------------------------------
END

# Install SSH Server
PKG_REQUIRE "openssh-server"

# Install LTSP Server
PKG_REQUIRE "ltsp-server"

# Uninstall tfptd-hpa
PKG_PURGE "tftpd-hpa"

# Install dnsmasq
PKG_REQUIRE "dnsmasq"

cat <<END
|------------------------------------
| Provisioning done
|------------------------------------
END
