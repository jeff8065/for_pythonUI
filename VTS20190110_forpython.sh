#!/bin/bash 
#Author : Jeff Su
#Use : VTS
#brand=$( adb -s $serial1 | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed 's/\/.*//')
#name=$( adb -s $serial1 | getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed s'/\.*\//+/' | sed s'/.*+//' | sed s'/\/.*//')
#if (find /3pl_report/ -name '3pl_report')  ; then
password='1'

####################################
VTS8_0='8'
VTS8_1='6'
VTS9_0='5'

###################

AOSP8_0='13'
AOSP8_1='6'
AOSP9_0='5'
###################


password='1'
SerialID=''
#######################

serialArray=()
serial_options=()
version=()

i=0
b=0
function scriptGSIVersionTable(){

	echo "      ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿"
	echo "      |  this script GSI version     |"
	echo "      |     VTS     |     8.0r"$VTS8_0"      |"
  	echo "      |     VTS     |     8.1r"$VTS8_1"      |"
  	echo "      |     VTS     |     9.0r"$VTS9_0"      |"
	echo "      | ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣"
	echo "      |     AOSP    |     8.0r"$AOSP8_0"      |"
	echo "      |     AOSP    |     8.1r"$AOSP8_1"      |"
	echo "      |     AOSP    |     9.0r"$AOSP9_0"      |"
	echo "      ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣"
	echo " "

}

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
	#		echo ${version[$b]}
			b=$((b+1))
		  done		
		;; 

	        s)
		  for var in ${OPTARG}
		  do
		  echo "device: "
			eval serial$i="$var"
			eval serialArray+=("$"serial$i)
			
			eval echo ${serialArray[$i]}
			
			i=$((i+1))
			countDevice=$i
	#		echo $countDevice
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
	#		echo ${serial_options[@]}
			
		done
	brand=$(adb -s ${serialArray[$1]} shell getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed 's/\/.*//' )
	name=$(adb -s ${serialArray[$1]} shell getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed s'/\.*\//+/' | sed s'/.*+//' | sed s'/\/.*//' )
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

}





function MultiSerial(){

	adb devices | grep daemon
	echo ""
	read -p "how many devices : " countDevice
	echo ""
	declare -i devicesNum=$(adb devices | sed -n '$=')
	devicesNum=$devicesNum-2
	printf "%3s %23s %8s  %14s   %35s \n" No SerialID Status ProductName Fingerprint
	for((i=0;i<devicesNum;i=i+1))
		do
			k=$(($i+2))
			eval SerialID$i=$(adb devices | sed -n "$k"p | awk '{print $1}')
			eval Status$i=$(adb devices | sed -n "$k"p | awk '{print $2}')
			eval deviceFingerPrint$i=$(eval adb -s  \$SerialID$i shell getprop | grep "ro.vendor.build.fingerprint" | sed 's/\[ro.vendor.build.fingerprint\]: \[//' | sed 's/\].*//')
			eval ProductName$i=$(eval adb -s \$SerialID$i shell getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed s'/\.*\//+/' | sed s'/.*+//' | sed s'/\/.*//' )
			eval printf "'%3s %23s %8s %14s %-14s \n'" $(($i+1)) \$SerialID$i  \$Status$i \$ProductName$i \$deviceFingerPrint$i
		done
	echo ""
	if [ "$countDevice" -eq "$devicesNum" ];then
		for((i=1;i<=countDevice;i=i+1))
			do
				eval serial$i=$(adb devices | sed -n "$(($i+1))"p | awk '{print $1}')
			done
	else
		for((i=1;i<=countDevice;i=i+1))
			do
				read -p "please enter device serial$i No :" whichNum
				eval serial$i=$(adb devices | sed -n "$(($whichNum+1))"p | awk '{print $1}')
			done
	fi

	echo ""

	serialArray=()
	serial_options=()
	for((i=1;i<=countDevice;i=i+1))
		do
			eval serialArray+=("$"serial$i)
			eval echo "serial$i"="$"serial$i

			serial_options+=("-s")
			eval serial_options+=("$"serial$i)
		done

	brand=$( adb -s $serial1 shell getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed 's/\/.*//' )
	name=$( adb -s $serial1 shell getprop | grep ro.vendor.build.fingerprint | sed 's/\[ro.vendor.build.fingerprint]:\ \[//' | sed s'/\.*\//+/' | sed s'/.*+//' | sed s'/\/.*//' )	
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

}


function compareFingerPrint(){
	
	#input finger print
	#read -p "please input your fingerprint:" fingerPrint
	fingerPrint=$(adb -s  ${serialArray[$1]} shell getprop | grep "ro.vendor.build.fingerprint" | sed 's/\[ro.vendor.build.fingerprint\]: \[//' | sed 's/\].*//')
	#echo 	$fingerPrint
	for((i=0;i<countDevice;i=i+1))
	do
		#capture device finger print 
		deviceFingerPrint=$(adb -s  ${serialArray[$i]} shell getprop | grep "ro.vendor.build.fingerprint" | sed 's/\[ro.vendor.build.fingerprint\]: \[//' | sed 's/\].*//')
		#echo 	$deviceFingerPrintp[$i]	
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
		echo 	""
		#input not match current finger print
		else
			echo "fringer print is not correct"
			echo "please recheck"
			endScript "1"
			fi
	done 
}

function endScript(){
	if [ $1 == 1 ]; then
		message="fingerprint not valid"
		
	elif [ $1 == 2 ]; then
		message="Device abi issue"
		
		
	else	
		message="Something wrong"
	fi
	echo "script stop "
	zenity --info --text="$message" && exit
}

function CopyMedia(){

devicespace=$(adb -s ${serialArray[0]} shell df -H | grep ' /data' | sed 's/[^ ]*//' | sed 's/[^0-9]*//' | sed 's/ .*//' | sed 's/G//')
if [ "$androidVersion" == "8.0" ] || [ "$androidVersion" == "8.1" ];then
media1920=$"5"
media1280=$"3"

if  [ $devicespace -gt $media1920 ] ;then
	echo $devicespace

		
	cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		xterm  -geometry 1024x600+0+0 -e bash copy_media.sh 1920x1080 -s ${serialArray[$i]} &
		done
	bash copy_media.sh  -s ${serialArray[0]}


elif [ $devicespace -gt  $media1280 ] ;then
	echo $devicespace
	
cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		xterm  -geometry 1024x600+0+0 -e bash copy_media.sh 1280x720 -s ${serialArray[$i]} &
		done
	bash copy_media.sh 1280x720 -s ${serialArray[0]}
else
	cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		xterm  -geometry 1024x600+0+0 -e bash copy_media.sh 720x480 -s ${serialArray[$i]} &
		done
	bash copy_media.sh 720x480 -s ${serialArray[0]}
fi
fi
}

function CTSDIRECTORY_python(){
	



#	echo " "
	#echo '*********************Device information and tool unzip*********************'

	deviceCpuType=$(adb -s ${serialArray[$1]}  shell getprop | grep "\[ro.product.cpu.abi]:" | sed 's/\[ro.product.cpu.abi]: \[//' | sed 's/arm.*/arm/' | sed 's/\].*//' | sed 's/x86.*/x86/' )

	if	 [ $deviceCpuType == "x86" ];then
		cpuType="x86"
		echo "This device is x86 cpu"
	elif 	 [ $deviceCpuType == "arm" ];then
		cpuType="arm"
	else	
		echo '******** Auto chose cputype wrong ********'
		endScript
	fi

	androidVersion=$(adb -s ${serialArray[$1]} shell getprop | grep "\[ro.build.version.release\]" | sed 's/\[ro.build.version.release\]: \[//' | sed 's/8.0.*/8.0/' | sed 's/8.1.*/8.1/' | sed 's/9.0.*/9.0/' | sed 's/10.0.*/10/' | sed 's/11.0.*/11/'  )
	if [ ${androidVersion:0:1} == "9" ];then
		androidVersion="9.0"
	elif [ ${androidVersion:0:1} == "11]" ];then
		androidVersion="11"
	fi
#	echo "This device android verision is" $androidVersion


#	echo Folder name is $name
#	echo TooolVersion is $androidVersion

#	echo "please check your tool version !!!"


	if [ "${version[0]}" == "VTS" ];then
		ChooseVTSVersion

	elif [ "${version[0]}" == "GSI" ];then
		ChooseGsiaospVersion
	
	fi

}

function CTSDIRECTORY(){
	



	## follow android version unzip correct tool , mkdir result folder 

	echo " "
	echo '*********************Device information and tool unzip*********************'

	deviceCpuType=$(adb -s $serial1 shell getprop | grep "\[ro.product.cpu.abi]:" | sed 's/\[ro.product.cpu.abi]: \[//' | sed 's/arm.*/arm/' | sed 's/\].*//' | sed 's/x86.*/x86/' )

	if	 [ $deviceCpuType == "x86" ];then
		cpuType="x86"
		echo "This device is x86 cpu"
	elif 	 [ $deviceCpuType == "arm" ];then
		cpuType="arm"
	else	
		echo '******** Auto chose cputype wrong ********'
		endScript
	fi

	androidVersion=$(adb -s $serial1 shell getprop | grep "\[ro.build.version.release\]" | sed 's/\[ro.build.version.release\]: \[//' | sed 's/8.0.*/8.0/' | sed 's/8.1.*/8.1/' | sed 's/9.0.*/9.0/' )

	echo "This device android verision is" $androidVersion


	echo Folder name is $name
	echo TooolVersion is $androidVersion

	echo "please check your tool version !!!"

	if [ "$version" -eq "1" ];then
		ChooseVTSVersion

	elif [ "$version" -eq "2" ];then
		ChooseGsiaospVersion
	
	fi

}



function ChooseVTSVersion(){
		
#	echo $androidVersion 
#	echo $cpuType	
	echo "--------------------------"
	echo "unzipping..."

#	echo $toolzip
#	echo "VTS version:" "${version[1]}"

	toolzip=$(ls /CTS_tool/VTS/"${version[1]}"/ | grep  $cpuType )
		
		mkdir -p "/3pl_report/vts"/"${version[1]}"/"$brand"/"$name"
	echo Folder  :   /3pl_report/vts/"${version[1]}"/$brand/$name

	#	unzip -o -q /CTS_tool/VTS/"${version[1]}"/$toolzip -d /3pl_report/vts/"${version[1]}"/$brand/$name 
	if ! unzip -o -q /CTS_tool/VTS/"${version[1]}"/$toolzip -d /3pl_report/vts/"${version[1]}"/$brand/$name ;then
		echo "***unzip fail, please check file***"
		endScript "3"
	else 
	 #	mkdir /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/repository/results
		echo "***VTS unzip success***"
	fi
		
		nautilus "/3pl_report/vts"/"${version[1]}"/$brand/$name
		cd "/3pl_report/vts"/"${version[1]}"/$brand/$name/android-vts/tools
		if  [ "$androidVersion" = "11"  ];then
		echo 1 | sudo -S update-java-alternatives -s "java-1.9.0-openjdk-amd64"
		else
		echo 1 | sudo -S update-java-alternatives -s "java-1.8.0-openjdk-amd64"
		fi
		x-terminal-emulator -T $name"_VTS_""${version[1]}"  -e  ./vts-tradefed run vts ${serial_options[@]}  --shard-count   $countDevice 


}


function ChooseGsiaospVersion(){
		
#	echo $androidVersion 
#	echo $cpuType	

	echo "unzipping..."

#	pwd
	 toolzip=$( ls /CTS_tool/VTS/"${version[1]}" | grep  "$cpuType" )
#	echo $toolzip
#	echo "GSI version:" "${version[1]}"
#	echo 'CPU:'$cpuType
#        echo toolzip $toolzip

	if [ "$androidVersion" = "8.0" ]|| [ "$androidVersion" = "11"  ];then
		mkdir -p /3pl_report/aosp/"${version[1]}"/$brand/$name
		echo Folder  :   /3pl_report/aosp/"${version[1]}"/$brand/$name
		
		if ! unzip -o -q /CTS_tool/$androidVersion/android-cts-"${version[1]}"-linux_x86-$cpuType.zip -d /3pl_report/aosp/"${version[1]}"/$brand/$name ;then
		echo "***unzip fail, please check file***"
		endScript "3"
		
		else 
		echo "***CTS-ON-GSI unzip success***"
		fi
	
		
	else
		mkdir -p /3pl_report/aosp/"${version[1]}"/"$brand"/"$name"
		echo Folder  :   /3pl_report/aosp/"${version[1]}"/$brand/$name
		echo 1 | sudo -S update-java-alternatives -s "java-1.8.0-openjdk-amd64"
		#unzip -o -q /CTS_tool/VTS/"${version[1]}"/$toolzip -d /3pl_report/aosp/"${version[1]}"/$brand/$name 
		if ! unzip -o -q /CTS_tool/VTS/"${version[1]}"/$toolzip -d /3pl_report/aosp/"${version[1]}"/$brand/$name ;then
		echo "***unzip fail, please check file***"
		endScript "3"
		else 

		echo "***CTS-ON-GSI unzip success***"		
		fi

	fi
		CopyMedia 
		rungsiaosp

}


function rungsiaosp(){

	if [ "$androidVersion" = "8.0" ];then
		nautilus /3pl_report/aosp/"${version[1]}"/$brand/$name/android-cts/tools
		cd /3pl_report/aosp/"${version[1]}"/$brand/$name/android-cts/tools
		 x-terminal-emulator -T $name -e  ./cts-tradefed run cts-reference-aosp  ${serial_options[@]} --shard-count $countDevice --disable-reboot --skip-preconditions 
	elif [ $androidVersion == "8.1" ] ;then
		nautilus /3pl_report/aosp/"${version[1]}"/$brand/$name
		cd /3pl_report/aosp/"${version[1]}"/$brand/$name/android-vts/tools

		x-terminal-emulator -T $name"_CTS-ON-GSI_""${version[1]}" -e ./vts-tradefed run cts-on-gsi   ${serial_options[@]} --shard-count $countDevice --disable-reboot --skip-preconditions
	
	elif [ $androidVersion == "9.0" ] ;then
		nautilus /3pl_report/aosp/"${version[1]}"/$brand/$name
		cd /3pl_report/aosp/"${version[1]}"/$brand/$name/android-vts/tools

		x-terminal-emulator -T $name"_CTS-ON-GSI_""${version[1]}" -e ./vts-tradefed run cts-on-gsi   ${serial_options[@]} --shard-count $countDevice  --skip-preconditions --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5
	else
		nautilus /3pl_report/aosp/"${version[1]}"/$brand/$name
		cd /3pl_report/aosp/"${version[1]}"/$brand/$name/android-vts/tools

		x-terminal-emulator -T $name"_CTS-ON-GSI_""${version[1]}" -e ./vts-tradefed run cts-on-gsi   ${serial_options[@]} --shard-count $countDevice  --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5


#	elif [ "$androidVersion" = "9.0" ];then
	#	nautilus /3pl_report/aosp/$toolVersion/$brand/$name
	#	cd /3pl_report/aosp/$toolVersion/$brand/$name/android-vts/tools

	#       	./vts-tradefed run cts-on-gsi   ${serial_options[@]} --shard-count $countDevice --disable-reboot --skip-preconditions

	fi

}

serialAndToolToArray "$@"
#scriptGSIVersionTable
#MultiSerial
compareFingerPrint
#CTSDIRECTORY
CTSDIRECTORY_python




