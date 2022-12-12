lspci -k | grep -i kernel | cut -f 2 -d ":" | sed -re "s/ *(.*)/find -iname \"*\1*\"/" | bash | sed -re "s/.*/grep include \0/" | bash | sed -re "s/.*<(.*)>.*/grep CONFIG_ include\/\1/" | grep -v "#" | bash | grep -E "\<CONFIG" | sed -re "s/.*(CONFIG_[a-zA-Z_0-9]*).*/\1=y/"| sort -u > .config

(for x in NAMESPACES _NS MEMORY_ATTACH USELIB INOTIFY DNOTIFY DHCP FAT CGROUP NET USB EXT4 DEV AHCI PROC UNIX SMP CRYPT BINFMT HDA KEYBOARD MOUSE MSDOS NTFS PARTITION TMPFS CONFIGFS ATA MD AMD MHI AGP INIT RD GZIP ACPI IP_ COMPRE ATM BT TCP XFRM TTY VT PTY V6 AUTO CODEPAGE SQUASH PACKET TLS XDP DISP POWER LCD BACKLIGHT MITI ENERGY MICRO; do
	echo $x > /dev/tty
	grep -r "CONFIG_.*$x" . | sed -e "s/.*\(CONFIG[A-Z_0-9]*\).*/\\1=y/"
done)|sort -u >> .config

(for x in AMDGPU FILESYSTEM DEV_NBD; do
	echo $x > /dev/tty
	grep -r "CONFIG_.*$x" . | sed -e "s/.*\(CONFIG[A-Z_0-9]*\).*/\\1=n/"
done)|sort -u >> .config

echo CONFIG_DEFAULT_INIT=\"/sbin/init\" >> .config
echo CONFIG_64BIT=n >> .config
echo CONFIG_NET=y >> .config
echo CONFIG_BLOCK_LEGACY_AUTOLOAD=y >> .config
#echo CONFIG_MCORE2=y >> .config
echo CONFIG_BLK_DEV_SD=y >> .config
echo CONFIG_BLK_DEV_SR=y >> .config
echo CONFIG_SCSI=y >> .config
echo CONFIG_SYSVIPC=y >> .config
echo CONFIG_POSIX_MQUEUE=y >> .config
echo CONFIG_DRM=y >> .config
echo CONFIG_WLAN=y >> .config
#echo CONFIG_WWAN=y >> .config
echo CONFIG_MODULES=n >> .config

make menuconfig
make clean -j 3 bzImage

