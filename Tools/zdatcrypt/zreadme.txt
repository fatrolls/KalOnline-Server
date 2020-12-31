Use this program at your own risk!!!!!!!!!!!!
Changing content of right protected files is illegal!
This program haven't any packing or archiving features, it is only encrypt-decrypt .dat files.

DAT File Decoder/Encoder Sep 2007 ver:0.0.0.0.0.0.0.0.1
Author: zoroto
Thank's to Luca for showing the way..... (I am too lazy for this)
Usage: zdatcrypt <options>
where options are the following (specify at least one):
-e           - perform AES encryption
-d           - perform AES decryption
-k<key>      - key number...in decimal please
-f<filename> - filename
-o           - only mapping feature is performed (AES is skipped but one of -e or -d is mandatory)
========================================================================================================================
[1.1] Perform AES decrypting and mapping with key 47 of file mac.dat
	zdatcrypt -d -k47 -fmac.dat

[1.2] If you want to separate the steps mentioned in [1.1] then use following:
[1.2.1] Perform AES decrypting of file mac.dat, mapping can be done with swordcrypt or using second commnad
	zdatcrypt -d -fmac.dat
[1.2.2] Perform only decrypt mapping with key 47 of mac.dat
	zdatcrypt -d -fmac.dat -k47 -o



[2.1] Perform AES encrypting and mapping with key 47 of file mac.dat
	zdatcrypt -e -fmac.dat -k47

[2.2] If you want to separate the steps mentioned above then use following:
[2.2.1] Perform AES decrypting of file mac.dat, mapping can be done with swordcrypt or using second commnad
	zdatcrypt -d -fmac.dat
[2.2.2] Perform only decrypt mapping with key 47 of mac.dat
	zdatcrypt -d -fmac.dat -k47 -o

