#!/usr/bin/env bash
__pwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$__pwd/includes/global-functions.shinc"

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
