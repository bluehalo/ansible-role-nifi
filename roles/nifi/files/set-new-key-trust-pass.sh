#!/usr/bin/env bash
# $1 key-alias
# $2 keystore-path
# $3 old_keypass
# $4 new_keypass
# $5 old_keystorepass
# $6 new_keystorepass
# $7 old_truststorepass
# $8 new_truststorepass
# $9 truststore-path

keytool -keypasswd -alias $1 -keystore $2 -storepass $3 -new $4
keytool -storepasswd -new $6 -keystore $2 -storepass $5
keytool -storepasswd -new $8 -keystore $9 -storepass $7
