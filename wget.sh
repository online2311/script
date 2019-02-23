#!/bin/bash
# Usage:
#   wget --no-check-certificate https://raw.githubusercontent.com/mixool/script/master/wget.sh && chmod +x wget.sh && ./wget.sh
###Total download depends on MBlimit,speed depends on Url,precision depends on url，change them if necessary.
MBlimit=1024
Url=http://download.alicdn.com/wireless/taobao4android/latest/702757.apk
url=http://cesu.cqwin.com/ddb_update/clientdownload/DTestClientSetupCQ.zip
#############################################################################################################

MBlimit=$(awk 'BEGIN{printf "%.f\n",('$MBlimit'*1024*1024)}')
Length=$(wget --spider $Url -SO- /dev/null 2>&1 | grep -oE "Content-Length: [0-9]+" | grep -oE "[0-9]+")
length=$(wget --spider $url -SO- /dev/null 2>&1 | grep -oE "Content-Length: [0-9]+" | grep -oE "[0-9]+")
T=$(awk 'BEGIN{printf int('$MBlimit'/'$Length')}')
t=$(awk 'BEGIN{printf int('$MBlimit'%'$Length'/'$length')}')
FMB=$(awk 'BEGIN{printf "%.4f\n",(('$MBlimit'-('$MBlimit'%'$Length'%'$length'))/1024/1024)}')
FGB=$(awk 'BEGIN{printf "%.4f\n",(('$MBlimit'-('$MBlimit'%'$Length'%'$length'))/1024/1024/1024)}')

for((i = 1; i <= T; i++))
do
	echo 
	wget -O /dev/null $Url
	Total=$(awk 'BEGIN{printf ('$i'*'$Length')}')
	MBtotal=$(awk 'BEGIN{printf "%.4f\n",('$i'*'$Length'/1024/1024)}')
	GBtotal=$(awk 'BEGIN{printf "%.4f\n",('$i'*'$Length'/1024/1024/1024)}')
	echo $MBtotal MB \($GBtotal GB\) had been downloaded. Accomplished $i.
	echo
done

if [ "$t" -gt 0 ]; then
echo -e "Still downloading\c"
fi

for((j = 1; j <= t; j++))
do
	echo -e ".\c"
	wget -q -O /dev/null $url
done

echo
echo $FMB MB \($FGB GB\) had been downloaded. All thanks!