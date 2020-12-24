# ---------------------------------------------------------------------- #
#    Skrypt automatyzujacy instalacje extroot w openwrt
#    (c)2020 cy3ul
#    author:  przemyslaw@cybulski.waw.pl
#         
#    version:    1.0
#
#    changeLog:
#                1.0   2020-03-08 Initial release
#
# ---------------------------------------------------------------------- #

#Instalowane narzedzi
echo "Instalowane narzedzi"
opkg update
opkg install -d ram e2fsprogs

#linkowanie bibliotek
echo "Linkowanie bibliotek"
ln -s /tmp/usr/lib/lib* /usr/lib/
ln -s /tmp/lib/lib* /lib/

#formatowanie nosnika
echo "Formatowanie nosnika"
mke2fs -m 0 /dev/sda1

#pobranie i wlaczenie extroota
echo "Wlaczenie extroota"
opkg install blkid
blkid
echo "Montowanie nosnika"
uci set fstab.@mount[0].enabled=1
read -p "podaj uuid: " identyfikator_uuid
uci set fstab.@mount[0].uuid=$identyfikator_uuid
uci set fstab.@mount[0].target=/overlay                          
uci set fstab.@mount[0].fstype=ext4                            
uci set fstab.@mount[0].options=rw,noatime
uci commit fstab
mount -t ext4 /dev/sda1 /mnt

#kopiowanie konfiguracji
echo "Kopiowanie konfiguracji"
cp -R /overlay/* /mnt

echo "Odmontowanie nosnika"
umount /dev/sda1
sync

echo "Restart Systemu"
reboot
