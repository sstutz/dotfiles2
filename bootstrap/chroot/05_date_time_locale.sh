#!/usr/bin/env bash

sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^# *\(de_DE.UTF-8\)/\1/' /etc/locale.gen
locale-gen


cat <<EOF > /etc/locale.conf
LANG=C.UTF-8
LANGUAGE=C.UTF-8:en:C:de_DE.UTF-8
LC_TIME=C.UTF-8
LC_COLLATE=C
LC_MEASUREMENT=metric
LC_MESSAGES=C.UTF-8
LC_MONETARY=de_DE.UTF-8
LC_PAPER=de_DE.UTF-8
EOF


ln -sf "/usr/share/zoneinfo/$DF_TIMEZONE" /etc/localtime
hwclock --systohc --utc
