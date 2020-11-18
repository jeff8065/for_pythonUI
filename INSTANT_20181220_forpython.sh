#!/bin/bash 
#Author : Leon Liao 


toolVersion="5"

serialArray=()
serial_options=()
i=0
b=0
password=1
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



function MultiSerial(){

	adb devices | grep daemon
	echo ""
	declare -i devicesNum=$(adb devices | sed -n '$=')
	devicesNum=$devicesNum-2
	printf "%3s %23s %8s %14s %-14s \n" No SerialID Status ProductName Fingerprint
	for((i=0;i<devicesNum;i=i+1))
		do
			k=$(($i+2))
			eval SerialID$i=$(adb devices | sed -n "$k"p | awk '{print $1}')
			eval Status$i=$(adb devices | sed -n "$k"p | awk '{print $2}')
			eval ProductName$i=$(eval adb -s \$SerialID$i shell getprop ro.product.name)
			eval deviceFingerPrint$i=$(eval adb -s  \$SerialID$i shell getprop ro.build.fingerprint)
			eval printf "'%3s %23s %8s %14s %-14s  \n'" $(($i+1)) \$SerialID$i  \$Status$i \$ProductName$i \$deviceFingerPrint$i
				done
	echo ""
	
	if [ "$devicesNum" -eq "1" ];then
		serialID=$(adb devices | sed -n 2p | awk '{print $1}')
	else 
		read -p "please enter device serial No :" input_No
		serialID=$(adb devices | sed -n $(($input_No+1))p | awk '{print $1}')
	fi

	brand=$(adb -s $serialID shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s $serialID shell getprop ro.product.name | sed 's/\r//' )
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

	echo  "Your brand is $brand"
	echo  "Your Productname $name"
}
function compareFingerPrint(){
	
	#input finger print
	#read -p "please input your fingerprint:" fingerPrint
	fingerPrint=$(adb -s  ${serialArray[$1]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
	echo 	$fingerPrint
	for((i=0;i<countDevice;i=i+1))
	do
		#capture device finger print 
		deviceFingerPrint=$(adb -s  ${serialArray[$i]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
		echo 	$deviceFingerPrintp[$i]	
		if echo $deviceFingerPrint[$i] | grep -ni 'user/release-keys'; then
			    echo ""
			else
				echo "fringer print is not correct"
				echo "device finger print: ""$deviceFingerPrint"
				echo "please recheck"
				endScript "$1"
			fi
	done

		for((i=0;i<countDevice;i=i+1))
	do
		if [  "$deviceFingerPrint" == "$fingerPrint" ];then	
		echo 	
		#input not match current finger print
		else
			echo "fringer print is not correct"
			echo "please recheck"
			endScript "1"
			fi
	done 
}

function createdirectory(){

	cpuType=$(adb -s ${serialArray[$1]} shell getprop ro.product.cpu.abi | sed 's/arm.*/arm/'  | sed 's/x86.*/x86/' )
	androidVersion=$(adb -s ${serialArray[$1]} shell getprop ro.build.version.release | sed 's/4.4.*/4.4/' | sed 's/5.0.*/5.0/' | sed 's/5.1.*/5.1/' |sed 's/6.0.*/6.0/'| sed 's/7.0.*/7.0/' | sed 's/7.1.*/7.1/' | sed 's/8.0.*/8.0/' | sed 's/8.1.*/8.1/' | sed 's/9.0.*/9.0/')
	if [ ${androidVersion:0:1} == "9" ];then
		androidVersion="9.0"
		toolVersion=$androidVersion"_r"$toolVersion
	fi

	mkdir -p /3pl_report/cts_instant/"${version[1]}"/$brand/$name 
	unzip -o -q /CTS_tool/9.0/android-cts_instant-"${version[1]}"-linux_x86-$cpuType.zip -d /3pl_report/cts_instant/"${version[1]}"/$brand/$name 
	echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64

}


function run_cts_instant(){
	nautilus /3pl_report/cts_instant/"${version[1]}"/$brand/$name/android-cts_instant/tools
	cd /3pl_report/cts_instant/"${version[1]}"/$brand/$name/android-cts_instant/tools

	x-terminal-emulator -T $name"_INSTANT_""${version[1]}"  -e ./cts-instant-tradefed  run cts-instant ${serial_options[@]}  --shard-count   $countDevice 

}



serialAndToolToArray "$@"
#MultiSerial
createdirectory
compareFingerPrint
run_cts_instant







