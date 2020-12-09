#!/bin/bash 
#Author :  Leon Liao 
#Use :   run sts

i=0
b=0
function serialAndToolToArray(){
	
	while getopts "v:s:" option
	do
	
    	case "${option}" in
        
        	v)
		  for var in ${OPTARG}
		  do
			eval versiontool$b="$var"
			eval version+=("$"versiontool$b)
			
			eval echo ${version[$b]}
			b=$((b+1))
		  done		
		;; 

	        s)
		  for var in ${OPTARG}
		  do
			eval serial$i="$var"
			eval serialArray+=("$"serial$i)
			
			eval echo ${serialArray[$i]}
			
			i=$((i+1))
			countDevice=$i
			echo $countDevice
		  done	 
		;;
	
	        ?)
	        echo "未知参数"
	        exit 1;;	
	    esac
	done
	
	for((i=1;i<=countDevice;i=i+1))
		do
			serial_options+=("-s")
			eval serial_options+=("$"serial$((i-1)))
			echo ${serial_options[@]}
			
		done
	brand=$(adb -s ${serialArray[$1]} shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s ${serialArray[$1]} shell getprop ro.product.name | sed 's/\r//' )	
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

}



function STSDIRECTORY(){
	
	## follow android version unzip correct tool , mkdir result folder 

	echo " "
	echo '*********************Device information and STS tool unzip*********************'
########################
	cpuType=$(adb -s ${serialArray[$1]} shell getprop ro.product.cpu.abi | sed 's/arm.*/arm/' | sed 's/x86.*/x86/' )
	abiType=$(adb -s ${serialArray[$1]} shell getprop ro.product.cpu.abi | sed 's/.*v8a/64/' | sed 's/.*v7a//' )
	buildType=$(adb -s ${serialArray[$1]} shell getprop ro.build.type)


	echo "This device android verision is" $androidVersion
	androidVersion=$(adb -s ${serialArray[$1]} shell getprop ro.build.version.release)
	brand=$( adb -s ${serialArray[$1]} shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s ${serialArray[$1]} shell getprop ro.product.name | sed 's/\r//' )	
	echo "Your Brand name is $brand"
	echo "Your Device name is $name"	

	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

	if [ $androidVersion == "7.0"  ] || [ $androidVersion == "7.0.0" ] ;then
		toolVersion='7.0'
	elif [ $androidVersion == "7.1.1" ];then
		toolVersion='7.1.1'
	elif [ $androidVersion == "7.1.2" ];then
		toolVersion='7.1.2'
	elif [ $androidVersion == "8.0" ] || [ $androidVersion == "8.0.0" ];then
		toolVersion='8.0'
	elif [ $androidVersion == "8.1.0" ];then
		toolVersion='8.1'
	elif [ ${androidVersion:0:1} == "9"  ];then
		androidVersion="9.0"
		toolVersion='9.0'
	elif [ $androidVersion == "10" ];then
		toolVersion='10.0'
	elif [ $androidVersion == "11" ];then
		toolVersion='11.0'
	fi
	
	mainVersion=$(echo $toolVersion | cut -d "." -f 1)
	echo "mainVersion: "$mainVersion 

	security=$(adb -s ${serialArray[$1]} shell getprop ro.build.version.security_patch)
	security_y=$(echo $security | cut -d "-" -f 1)
	security_m=$(echo $security | cut -d "-" -f 2)
	echo "security_year: "$security_y
	echo "security_month: "$security_m

	testToolVersion=$security_y$security_m


###############
	echo Folder name is $name
	echo TooolVersion is $toolVersion

	echo "please check your tool version !!!"

	mkdir -p /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name

	echo "unzipping..."	
	

	cd /CTS_tool/STS/$security_y'-'$security_m
	forder_name=$(ls -FX | grep "/")
	if [ !  $forder_name ] ;then
		zip_name=$(ls -FX | grep "zip")
		unzip $zip_name 
	fi

	if [ $mainVersion == '8' ] || [ $mainVersion == "9" ] || [ $mainVersion == "10" ] || [ $mainVersion == "11" ];then
		unzip  -P sts -o -q '/CTS_tool/STS/'$security_y'-'$security_m'/'$forder_name'android-sts-'$toolVersion'_'$testToolVersion-linux-$cpuType$abiType.zip -d /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name
#	elif [ $mainVersion == "8" ];then
#	cd /CTS_tool/STS/2020-02
#	echo "	/CTS_tool/STS/2020-02"
#	unzip  -P sts -o -q "/CTS_tool/STS/2020-02/"$forder_name'android-sts-'$toolVersion'_202002-linux'-$cpuType'64'.zip -d /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name		
	
	elif [ $toolVersion == "7.0" ];then
	cd /CTS_tool/STS/2019-08
	echo "	cd /CTS_tool/STS/2019-08"
		unzip  -P sts -o -q "/CTS_tool/STS/2019-08/"'android-sts-'$toolVersion'_201908-linux'-$cpuType'_64'.zip -d /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name		
	elif [ $toolVersion == "7.1.1" ];then
		unzip  -P sts -o -q '/CTS_tool/STS/2019-10/''android-sts-7.1.1_201910-linux-'$cpuType'_64'.zip -d /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name		
	elif [ $toolVersion == "7.1.2" ];then
		unzip  -P sts -o -q '/CTS_tool/STS/2019-10/''android-sts-7.1.2_201910-linux-'$cpuType'_64'.zip -d /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name		

	fi 

}






function STS(){

	echo " "
	cd /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name/android-sts/tools

	if [ $mainVersion == '11' ];then
	echo $password | sudo -S update-java-alternatives --set java-1.9.0-openjdk-amd64
	else 
	echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	if

	if [ $mainVersion == '8' ] || [ $mainVersion == '9' ] || [ $mainVersion == "10" ]|| [ $mainVersion == "11" ];then
		if [ $buildType == "user" ];then
		x-terminal-emulator -T $name"_STS_"$testToolVersion -e	./sts-tradefed run sts-userbuild -s ${serialArray[$1]} 
		else
		x-terminal-emulator -T $name"_STS_"$testToolVersion -e	./sts-tradefed run sts-engbuild -s ${serialArray[$1]} 
		fi

	elif [ $mainVersion == "7" ] ||[ $mainVersion == "7.0" ] ;then #|| [ $mainVersion == '8' ] ;then
		if [ $buildType == "user" ];then
		x-terminal-emulator -T $name"_STS_"$testToolVersion -e  ./sts-tradefed  run sts-userbuild-no-spl-lock -s ${serialArray[$1]} 
		else
		x-terminal-emulator -T $name"_STS_"$testToolVersion -e	./sts-tradefed run sts-engbuild-no-spl-lock -s ${serialArray[$1]} 
		fi
	fi 

}




function MultiSerial(){

	adb devices | grep daemon
	echo ""
	declare -i devicesNum=$(adb devices | sed -n '$=')
	devicesNum=$devicesNum-2
	printf "%3s %23s %8s %14s \n" No SerialID Status ProductName
	for((i=0;i<devicesNum;i=i+1))
		do
			k=$(($i+2))
			eval SerialID$i=$(adb devices | sed -n "$k"p | awk '{print $1}')
			eval Status$i=$(adb devices | sed -n "$k"p | awk '{print $2}')
			eval ProductName$i=$(eval adb -s \${serialArray[$1]}$i shell getprop ro.product.name)
			eval deviceFingerPrint$i=$(eval adb -s  \${serialArray[$1]}$i shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
			eval printf "'%3s %23s %8s %14s %-14s \n'" $(($i+1)) \${serialArray[$1]}$i  \$Status$i \$ProductName$i \$deviceFingerPrint$i
		done
	echo ""
	
	if [ "$devicesNum" -eq "1" ];then
		serialID=$(adb devices | sed -n 2p | awk '{print $1}')
	else 
		read -p "please enter device serial No :" input_No
		serialID=$(adb devices | sed -n $(($input_No+1))p | awk '{print $1}')
	fi

	brand=$(adb -s ${serialArray[$1]} shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s ${serialArray[$1]} shell getprop ro.product.name | sed 's/\r//' )
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

	echo  "Your brand is $brand"
	echo  "Your Productname $name"

}




serialAndToolToArray "$@"
#MultiSerial
STSDIRECTORY
nautilus  /3pl_report/sts/$testToolVersion/$toolVersion/$brand/$name/android-sts/tools
STS
