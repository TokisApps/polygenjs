#!/bin/bash

shopt -s extglob

sign() {
	echo -e "\000\000#//Dynamic Signature : `nodejs ./polygen.js ./english.grm`" >> $1
}

genLens() {
	xs=()
	k=0
	for x in $*;do
		for y in 1 2 4;do
			xs[$k]="$x/$y"
			k=$(( $k + 1 ))
		done
	done
	echo "${xs[@]}" | sed -re "s/\s+/\\\"|\\\"/g;s/^/(\\\"\\\"|\\\"/;s/$/\\\")/;"
}


doit() {
	cp ./music.grm.tmpl /tmp
	echo "Init1 ::= \"X:$RANDOM\nM:4/4\nL:1/8\nK:$key1\n\";" >> /tmp/music.grm.tmpl
	echo "Init2 ::= \"K:$key2\n\";" >> /tmp/music.grm.tmpl
	echo "Init3 ::= \"K:$key3\n\";" >> /tmp/music.grm.tmpl
	echo "Init4 ::= \"K:$key4\n\";" >> /tmp/music.grm.tmpl
	echo "Note ::= " $1 ";" >> /tmp/music.grm.tmpl
	lens=""; for x in 1 2 4;do if [ $(( $RANDOM % 2 )) -eq 0 ]; then lens="$lens $x";fi;done
	echo "Laenge ::= `genLens $lens`;" >> /tmp/music.grm.tmpl
	nodejs ./polygen.js /tmp/music.grm.tmpl > /tmp/xy.abc
	sign xy.abc
       	abc2midi /tmp/xy.abc -o /tmp/xy.mid -Q $5
	sign xy.mid
	echo $4 > /tmp/wildmidi.cfg 
	find -L $3 -maxdepth 1 -iname "*pat*" -exec readlink -f "{}" \; | grep $6 "$7" | shuf | head -n 1 | nl -v 0 >> /tmp/wildmidi.cfg 
	sign wildmidi.cfg
	t=`mktemp -u`.xy.wav
	wildmidi -c /tmp/wildmidi.cfg -o $t /tmp/xy.mid

	sign $t
	cat /tmp/wildmidi.cfg >> /tmp/song.txt
	sign /tmp/song.txt
}

drums="(High|Bell|Cymbal|Splash|Crash|Vibra|Timb|Whistle|Cuica|Guir)"


while [ true ]; do
	rm /tmp/*xy*.mid
	rm /tmp/*xy*.wav
	rm /tmp/*xy*.mp3
	rm /tmp/song.mp3
	rm /tmp/song.txt

export keys=(C D E F G A B)
export vers=("" "#" "b")
export gens=("" "Mix" "Dor")
export key1="${keys[$(( $RANDOM % ${#keys[*]} ))]}${vers[$(( $RANDOM % ${#vers[*]} ))]}${gens[$(( $RANDOM % ${#gens[*]} ))]}"
export key2="${keys[$(( $RANDOM % ${#keys[*]} ))]}${vers[$(( $RANDOM % ${#vers[*]} ))]}${gens[$(( $RANDOM % ${#gens[*]} ))]}"
export key3="${keys[$(( $RANDOM % ${#keys[*]} ))]}${vers[$(( $RANDOM % ${#vers[*]} ))]}${gens[$(( $RANDOM % ${#gens[*]} ))]}"
export key4="${keys[$(( $RANDOM % ${#keys[*]} ))]}${vers[$(( $RANDOM % ${#vers[*]} ))]}${gens[$(( $RANDOM % ${#gens[*]} ))]}"
export tempo=$(( 80 + ( $RANDOM % 30 ) ))


	echo "$key$ver$gen $tempo" > /tmp/song.txt

	doit "(\"C\"|\"D\"|\"E\"|\"F\"|\"G\"|\"A\"|\"B\"|\"c\"|\"d\"|\"e\"|\"f\"|\"g\"|\"a\"|\"b\")" "`genLens 1 2 4`" "./freepats/tone" "bank 0" $tempo -ivE "Bass"
	doit "(\"C\"|\"D\"|\"E\"|\"F\"|\"G\"|\"A\"|\"B\")" "`genLens 2 4`" "./freepats/tone" "bank 0" $tempo -iE ".*"
	doit "(\"C\"|\"D\"|\"E\"|\"F\"|\"G\"|\"A\"|\"B\")" "`genLens 4`" "./freepats/tone" "bank 0" $tempo -iE "Bass"
	doit "(\"c\"|\"d\"|\"e\"|\"f\"|\"g\"|\"a\"|\"b\")" "`genLens 1 2 4`" "./freepats/drum" "drumbank 0" $tempo -iE ".*"
	doit "(\"c\"|\"d\"|\"e\"|\"f\"|\"g\"|\"a\"|\"b\")" "`genLens 2 4`" "./freepats/drum" "drumbank 0" $tempo -iE ".*"
	doit "(\"c\"|\"d\"|\"e\"|\"f\"|\"g\"|\"a\"|\"b\")" "`genLens 2`" "./freepats/drum" "drumbank 0" $tempo -iE ".*"

	scale=1.0$(( $RANDOM ))
	for x in /tmp/*xy.wav;do
		ffmpeg -itsscale $scale -itsoffset $(( $RANDOM % 1000 ))ms -t 180s -i $x -filter_complex:a "loudnorm,ladspa=f=/usr/lib/ladspa/tap_pinknoise.so:p=tap_pinknoise:c=c0=0.5|c1=10|c2=-30" $x.mp3
		sign $x.mp3
	done

	inp="`find /tmp -maxdepth 1 -iname "*xy*.mp3" -printf " -t 180s -i \"%h/%f\" " `"

	ffmpeg $inp -filter_complex:a "amix=inputs=`ls /tmp/*xy*.mp3 | wc -l`,ladspa=f=/usr/lib/ladspa/tap_pinknoise.so:p=tap_pinknoise:c=c0=0.5|c1=10|c2=-30" /tmp/song.mp3
	sign /tmp/song.mp3

	fn=$RANDOM
	mv /tmp/song.mp3 ~/$fn.mp3
	mv /tmp/song.txt ~/$fn.txt
done

