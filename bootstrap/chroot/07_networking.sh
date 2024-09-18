#!/usr/bin/env bash

echo "$DF_HOSTNAME" > /etc/hostname

cat <<EOF > /etc/hosts
# The following lines are desirable for IPv4 capable hosts
127.0.0.1   localhost
127.0.1.1   $DF_HOSTNAME.localdomain  $DF_HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
EOF


cat <<EOF > /etc/systemd/network/20-wired.network
[Match]
Type=ether

[Network]
DHCP=yes
IPv6PrivacyExtensions=true

[DHCP]
RouteMetric=10
Anonymize=true
EOF

cat <<EOF > /etc/systemd/network/25-wireless.network
[Match]
Type=wlan

[Network]
DHCP=yes
IPv6PrivacyExtensions=true
# LinkLocalAddressing=no

[DHCP]
RouteMetric=20
Anonymize=true
EOF

if mountpoint -q "/etc/resolv.conf"; then
    umount /etc/resolv.conf
fi

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd


# by default systemd-networkd-wait-online waits for all interfaces to be online
# most end users really only care about one interface being connected though
mkdir -p /etc/systemd/system/systemd-networkd-wait-online.service.d
cat <<EOF > /etc/systemd/system/systemd-networkd-wait-online.service.d/wait-for-only-one-interface.conf
[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
EOF
