make mrproper

#ks=(`lspci -vvv | grep -i subsystem | cut -f 2 -d ":"`)
#ks=(`echo ${ks[*]} | sed -re "s/\s+/\n/g" | sort -u | sed -re "s/[^a-zA-Z0-9]//g" | grep -Ei "[a-z]+"| grep -Ei "[0-9]+"`)


#echo ks : ${ks[*]}
#echo fs : ${#fs[*]}

#for f in ${fs[*]}; do
	#for k in ${ks[*]}; do
		#echo $k
		#grep -irc $k . | grep -v :0
	#done
#done

#exit

#### Keywords
ks=(sis backlight ath hda agp)

#### Directories
ps=(arch/x86 net crypto fs mm ipc security certs)
for x in ${ks[*]};do
	ps=(${ps[*]} `find -iname "*$x*" -type d`)
done

echo ps : ${ps[*]}

fs=(`find ${ps[*]} -iname "*.c"`)

xs=()
for x in ${ps[*]}; do
	xs=(${xs[*]} `cat $x/Kconfig | grep "^config " | sed -re "s/config ([A-Z_0-9]*)/CONFIG_\1/" | sort -u`)
	for y in `grep "^source" $x/Kconfig | sed -re "s/.*\"(.*)\".*/\1/"`; do
		xs=(${xs[*]} `cat $y | grep "^config " | sed -re "s/config ([A-Z_0-9]*)/CONFIG_\1/" | sort -u`)
		echo actually : ${#xs[*]} 
	done
	echo actually "($x)" : ${#xs[*]} 
done

echo found : ${#xs[*]} CONFIG_ Flags

rm xy.txt
for x in ${xs[*]}; do echo $x >> xy.txt;done

xs=(`sort -u xy.txt | grep CONFIG | grep -v "_[0-9]*$"`)
echo found : ${#xs[*]} CONFIG_ Flags

rm ._config


i=0
(for x in ${xs[*]}; do
	echo $i : $x > /dev/tty
	grep -c $x ${fs[*]} | grep -v :0 | sed -re "s/(.*):.*/grep CONFIG_ \1/" | sort -u | bash | sed -e "s/.*\(CONFIG_[A-Z_0-9]*\).*/\\1=y/"
	i=$(($i + 1))
done)|sort -u >> ._config

sort -u ._config | grep CONFIG | grep -v "CONFIG_=" > .config

echo CONFIG_DEFAULT_INIT=\"/sbin/init\" >> .config
echo CONFIG_64BIT=n >> .config
#echo CONFIG_MCORE2=y >> .config
echo CONFIG_M686=y >> .config
echo CONFIG_MODULES=n >> .config

exit
#here now select "block fs drivers"
make menuconfig
make clean -j 3 bzImage

