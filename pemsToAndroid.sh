#!/bin/bash
#
#This script creates an Android compatibility (BouncyCastle / BKS) or standard java (JKS) certificate store from the provided PEM certificates
#

PROGNAME="${0##*/}"

if [ -z "$1" ]; then
    echo "Usage: $PROGNAME <keystore_name> </path/to/pems/*.pem>"
    echo "EXAMPLE: ./pemsToAndroid.sh debiancacertstore.bks \"/etc/ssl/certs/*.pem\""
    exit 1
fi

certStore=$1
pemPath="$2"

rm $certStore
rm $certStore.txt

certAliasNum=0

for file in `ls $pemPath` ; do
	certAliasNum=$((certAliasNum+1))
	
	if [[ "$certStore" == *.bks ]]; then
	    # BouncyCastle format for KeyStore is used. 
	    # (Otherwise JKS by default)
	    additionalOpts="-provider org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath "libs/bcprov-jdk16-145.jar" -storetype BKS"
	fi
	
	keytool -importcert -v -trustcacerts -file "$file" -alias $certAliasNum -keystore "$certStore" -storepass changeit -noprompt $additionalOpts
done
