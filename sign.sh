#!/bin/bash

shopt -s extglob

sign() {
	echo -e "\000\000#//Dynamic Signature : `nodejs ./polygen.js ./english.grm`" >> $1
}

sign $1


