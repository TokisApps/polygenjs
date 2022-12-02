#!/bin/sh

str="`nodejs ./polygen.js ./english.grm 2>/dev/null`"
str2="`echo $str | trans de:en -b | trans en:de -b`"

if [ -z "$str2" ]; then
	echo $str
else
	echo $str2
fi


#//Dynamic Signature : Der diebische Anschluss deiner topografischen Note singe die künstlichen Dienstagen meines jugendlichen Aufenthalts .
