#!/bin/bash 
#Author : Javier de la Vega & "Wayne Hsu" <<<fish king & Leon Liao & Jeff Su
#Use :   Prepare device and run cts

#tool FTP
SFTP_SERVER="3PL-test.pegatroncorp.com"
SFTP_USER="jinny"
SFTP_PWD="pega#1234"


#change user password
password='1'
#cts verision
#if you want change tool's version (r?)
#please change here
cts4_4='4'
cts5_0='9'
cts5_1='28'
cts6_0='32'
cts7_0='28'
cts7_1='24'
cts8_0='12'
cts8_1='12'
cts9_0='5'

pc=$(whoami)

#autoContinue
sleepTime="1800s"
#adb   shell df | grep ' /data' | sed 's/[^ ]*//' | sed 's/[^0-9]*//' | sed 's/ .*//'

serialArray=()
serial_options=()
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
		
		echo "device: "
		
		  for var in ${OPTARG}
		  do
			eval serial$i="$var"
			eval serialArray+=("$"serial$i)
			
			eval echo  ${serialArray[$i]}
			
			i=$((i+1))
			countDevice=$i
#			echo $countDevice
			
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
#			echo ${serial_options[@]}
			
		done
	brand=$(adb -s ${serialArray[$1]} shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s ${serialArray[$1]} shell getprop ro.product.name | sed 's/\r//' )	
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

}



function scriptCTSVersionTable(){

	echo ""
	echo ""
	echo "      ＿＿＿＿＿＿＿＿＿＿＿＿＿＿"
	echo "      |  this script CTS version |"
	echo "      |     4.4     |     r"$cts4_4"     |"
  	echo "      |     5.0     |     r"$cts5_0"     |"
	echo "      |     5.1     |     r"$cts5_1"    |"
	echo "      |     6.0     |     r"$cts6_0"     |"
	echo "      |     7.0     |     r"$cts7_0"     |"
	echo "      |     7.1     |     r"$cts7_1"     |"
	echo "      |     8.0     |     r"$cts8_0"     |"
	echo "      |     8.1     |     r"$cts8_1"     |"
	echo "      |     9.0     |     r"$cts9_0"     |"	
	echo "      ￣￣￣￣￣￣￣￣￣￣￣￣￣￣"
	echo " "

}


function CTSDIRECTORY_python(){
	
	## follow android version unzip correct tool , mkdir result folder 

	echo " "
	#echo '*********************Device information and CTS tool unzip*********************'

	deviceCpuType=$(adb -s  ${serialArray[$1]} shell getprop ro.product.cpu.abi | sed 's/arm.*/arm/'  | sed 's/x86.*/x86/' )

	if	 [ $deviceCpuType == "x86" ];then
		cpuType="x86"
	#	echo "This device is x86 cpu"
	elif 	 [ $deviceCpuType == "arm" ];then
		cpuType="arm"
	else	
		echo '******** Auto chose cputype wrong ********'
		endScript "2"
	fi

	androidVersion=$(adb -s ${serialArray[$1]} shell getprop ro.build.version.release | sed 's/4.4.*/4.4/' | sed 's/5.0.*/5.0/' | sed 's/5.1.*/5.1/' |sed 's/6.0.*/6.0/'| sed 's/7.0.*/7.0/' | sed 's/7.1.*/7.1/' | sed 's/8.0.*/8.0/' | sed 's/8.1.*/8.1/' | sed 's/9.0.*/9.0/'| sed 's/10.0*/10.0/' | sed 's/11.0*/11.0/')

#	echo "This device android verision is" $androidVersion


#	echo "Your Brand name is $brand"
#	echo "Your Device name is $name"	

	if [ ${androidVersion:0:1} == "9" ];then
		androidVersion="9.0"
	fi
#	echo Folder name is $name
	echo Folder  :   /3pl_report/cts/"${version[1]}"/$brand/$name
#	echo "please check your tool version !!!"

	mkdir -p /3pl_report/cts/"${version[1]}"/$brand/$name

	echo --------------------------
#	echo CTS tool version is "${version[1]}"
	echo "unzipping..."	
	if ! unzip -o -q /CTS_tool/$androidVersion/android-cts-"${version[1]}"-linux_x86-$cpuType.zip -d /3pl_report/cts/"${version[1]}"/$brand/$name ;then
		echo "***unzip fail, please check file***"
		endScript "3"
	else 
		mkdir /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/repository/results
		echo "***CTS unzip success***"
	fi

	echo ''
}





function CTSDIRECTORY(){
	
	## follow android version unzip correct tool , mkdir result folder 

	echo " "
	echo '*********************Device information and CTS tool unzip*********************'

	deviceCpuType=$(adb -s $serial1 shell getprop ro.product.cpu.abi | sed 's/arm.*/arm/'  | sed 's/x86.*/x86/' )

	if	 [ $deviceCpuType == "x86" ];then
		cpuType="x86"
		echo "This device is x86 cpu"
	elif 	 [ $deviceCpuType == "arm" ];then
		cpuType="arm"
	else	
		echo '******** Auto chose cputype wrong ********'
		endScript "2"
	fi

	androidVersion=$(adb -s $serial1 shell getprop ro.build.version.release | sed 's/4.4.*/4.4/' | sed 's/5.0.*/5.0/' | sed 's/5.1.*/5.1/' |sed 's/6.0.*/6.0/'| sed 's/7.0.*/7.0/' | sed 's/7.1.*/7.1/' | sed 's/8.0.*/8.0/' | sed 's/8.1.*/8.1/' | sed 's/9.0.*/9.0/' | sed 's/10.0.*/10.0/' | sed 's/11.0.*/11.0/')

	echo "This device android verision is" $androidVersion

	brand=$( adb -s $serial1 shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s $serial1 shell getprop ro.product.name | sed 's/\r//' )	
	echo "Your Brand name is $brand"
	echo "Your Device name is $name"	
#	read name

	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

	if [ $androidVersion == "4.4" ];then
		toolVersion=$androidVersion"_r"$cts4_4
	elif [ $androidVersion == "5.0" ];then
		toolVersion=$androidVersion"_r"$cts5_0
	elif [ $androidVersion == "5.1" ];then
		toolVersion=$androidVersion"_r"$cts5_1
	elif [ $androidVersion == "6.0" ];then
		toolVersion=$androidVersion"_r"$cts6_0
	elif [ $androidVersion == "7.0" ];then
		toolVersion=$androidVersion"_r"$cts7_0
	elif [ $androidVersion == "7.1" ];then
		toolVersion=$androidVersion"_r"$cts7_1
	elif [ $androidVersion == "8.0" ];then
		toolVersion=$androidVersion"_r"$cts8_0
	elif [ $androidVersion == "8.1" ];then
		toolVersion=$androidVersion"_r"$cts8_1
	elif [ $androidVersion == "10.0" ];then
		toolVersion=$androidVersion"_r"$cts10_0
	elif [ $androidVersion == "11.0" ];then
		toolVersion=$androidVersion"_r"$cts11_0
	elif [ ${androidVersion:0:1} == "9" ];then
		androidVersion="9.0"
		toolVersion=$androidVersion"_r"$cts9_0
	fi

## androidVersion = 4.4
## toolVersion = 4.4_r5
	echo Folder name is $name
	echo TooolVersion is $toolVersion

	echo "please check your tool version !!!"

	mkdir -p /3pl_report/cts/$toolVersion/$brand/$name

	echo --------------------------
	echo CTS tool version is $toolVersion
	echo "unzipping..."	
	if ! unzip -o -q /CTS_tool/$androidVersion/android-cts-$toolVersion-linux_x86-$cpuType.zip -d /3pl_report/cts/$toolVersion/$brand/$name ;then
		echo "***unzip fail, please check file***"
		endScript "3"
	else 
		mkdir /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/results
		echo "***CTS unzip success***"
	fi

	echo ''
}


function CtsSettings(){

	echo " "
	echo "***************************************CTS Settings*********************************************************"
	echo "1) Make sure you have SDcard inserted"
	echo "2) Make sure you have set device timezone to GMT+00 as well as computer time to GMT+ 00"
	echo "3) Set up your device with English (United States) as the language (Settings > Language & input > Language)."
	echo "4) Turn on the Location setting if there is a GPS or Wi-Fi / Cellular network available."
	echo "5) Make sure you have set device display Sleep (Settings > Display > Sleep = '30 min')."
	echo "6) Make sure no lock pattern is set on the device (Settings > Security > Screen Lock = 'None')."
	echo "7) Check Settings > Developer options > Stay Awake."
	echo "8) Check Settings > Developer options > Allow mock locations "
	echo "8) Go to chrome and make a search to make sure CTS can execute octane test "
	echo "9) On the device, enable the two android.deviceadmin.cts.CtsDeviceAdminReceiver*device
	administrators under Settings > Security > Select device administrators. Make sure the
	android.deviceadmin.cts.CtsDeviceAdminDeactivatedReceiver stays disabled in the same menu."
	echo "10) Press the home button to set the device to the home screen at the start of CTS."
	echo "You have 1 min to setup the device"
	#read -p "Continue (y/n)?" CONT
	sleep 20
}


function CopyApks(){


	if [ "$androidVersion" == "7.0" ] || [ "$androidVersion" == "7.1" ] || [ "$androidVersion" == "8.0" ] || [ "$androidVersion" == "8.1" ] || [ "$androidVersion" == "9.0" ] || [ "$androidVersion" == "10" ]|| [ "$androidVersion" == "11" ] ;then
	echo " "

	else
	echo "*********************************************Copy CTS DEVICE ADMIN APK********************************************"
	echo $androidVersion
		for((i=0;i<countDevice;i=i+1))
		do
			adb -s ${serialArray[$i]} install  -r /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/testcases/CtsDeviceAdmin.apk 
		#	adb -s ${serialArray[$i]} shell am start -S "'com.android.settings/.Settings\$DeviceAdminSettingsActivity'"
		done
		sleep 3s 
	fi
}


function LaunchChrome(){

	echo " "
	echo "*********************************************Browser selection*****************************************************"
	echo "Choose Chrome in your device screen (Always)"
	for((i=0;i<countDevice;i=i+1))
	do
		echo "adb -s ${serialArray[$i]} shell am start -a android.intent.action.VIEW -d http://amigousa2001.pixnet.net/blog/post/308470075"
		adb -s ${serialArray[$i]} shell am start -a android.intent.action.VIEW -d http://amigousa2001.pixnet.net/blog/post/308470075
	done
	sleep 15s
}


function SelectLauncher(){

	echo " "
	echo "************************************************Launch Launcher*********************************************************"
	echo "If you have many launchers please set one (Always option)"
	for((i=0;i<countDevice;i=i+1))
	do
		adb -s ${serialArray[$i]} shell am start -a android.intent.action.MAIN -c android.intent.category.HOME
	done
}


function CTS(){

	echo "****************************************************Done***********************************************************"
#	echo "************************************************Launch CTS*********************************************************"
	if [ $androidVersion == "7.0" ]  || [ $androidVersion == "7.1" ] ;then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		 x-terminal-emulator -T $name -e ./cts-tradefed run cts ${serial_options[@]} --shards $countDevice --disable-reboot --skip-preconditions  --exclude-filter CtsAppSecurityHostTestCases
	elif [ $androidVersion == "8.0" ] || [ "$androidVersion" == "8.1" ] ;then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		x-terminal-emulator -T $name"_CTS_""${version[1]}" -e ./cts-tradefed run cts-suite --shard-count $countDevice ${serial_options[@]}   --disable-reboot --skip-preconditions 
	elif [ $androidVersion == "9.0" ] ;then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		x-terminal-emulator -T $name"_CTS_""${version[1]}" -e ./cts-tradefed run cts-suite  --shard-count $countDevice ${serial_options[@]}   --disable-reboot --skip-preconditions --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5


	elif [ $androidVersion == "10" ] ;then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		x-terminal-emulator -T $name"_CTS_""${version[1]}" -e ./cts-tradefed run cts --shard-count $countDevice ${serial_options[@]}   --skip-preconditions --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5
	elif [ $androidVersion == "11" ] ;then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		x-terminal-emulator -T $name"_CTS_""${version[1]}" -e ./cts-tradefed run cts --shard-count $countDevice ${serial_options[@]}   --skip-preconditions --module-arg CtsMediaTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaStressTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5 \--module-arg CtsMediaBitstreamsTestCases:local-media-path:/CTS_tool/Media/android-cts-media-1.5


	elif [ $androidVersion == "6.0" ];then
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		 x-terminal-emulator -T $name"_CTS_""${version[1]}"  -e ./cts-tradefed run cts ${serial_options[@]} --shards $countDevice --plan CTS-TF --disable-reboot --skip-preconditions	
	else
		cd /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
		 x-terminal-emulator -T $name"_CTS_""${version[1]}"  -e ./cts-tradefed run cts ${serial_options[@]} --shards $countDevice --plan CTS-TF --disable-reboot
	fi
}

 
function compareFingerPrint(){
	
	#input finger print
	#read -p "please input your fingerprint:" fingerPrint
	fingerPrint=$(adb -s  ${serialArray[$1]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
	#echo 	$fingerPrint
	for((i=0;i<countDevice;i=i+1))
	do
		#capture device finger print 
		deviceFingerPrint=$(adb -s  ${serialArray[$i]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
	#	echo 	$deviceFingerPrintp[$i]	
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



function compareClientID(){

	#input client ID
	#read -p "please input your clientID:" clientID
	
	for((i=0;i<countDevice;i=i+1))
	do
	#capture device client ID
	deviceClientID=$(adb -s ${serialArray[$i]} shell getprop | grep "\[ro.com.google.clientidbase\]" | sed 's/\[ro.com.google.clientidbase\]: \[//' | sed 's/\].*//')

	#capture device gms version
	hasGms=$(adb -s ${serialArray[$i]} shell getprop | grep gms)
	
	#check gms string not null
	if [ "$hasGms" != "" ];then
		
		#compare input and current client ID
		if [ "$deviceClientID" == "$clientID" ];then
			echo "clientID is correct"
		else
			#input nothing will show current client ID
			if [ "$clientID" == "" ];then
				echo "device Client ID= ""$deviceClientID"
			#input not match current client ID
			else
				echo "Client ID is not correct"
				echo "device Client ID: ""$deviceClientID"
				echo "please check"
				echo "after 2 mins this program will exit"
				endScript
			fi
		fi
	else
		echo "this device dosen't have Client ID"
	fi 
	done
}

function changeJavaVersion(){

	device_Java_Version=$(adb -s ${serialArray[$1]} shell getprop | grep "\[ro.build.version.release\]" | sed 's/\[ro.build.version.release\]: \[//' | sed 's/4.*/4/' | sed 's/5.*/5/' | sed 's/6.*/6/' | sed 's/7.*/7/' | sed 's/8.*/8/' | sed 's/9.*/9/' )
	now_PC_JavaVersion=$(java -version 2>&1 | awk 'NR==1{ gsub(/"/,""); print $3 }' | cut -c1-3)

	if [ "$device_Java_Version" == "4" ];then
		if [ "$now_PC_JavaVersion" != "1.6" ];then
			echo "Change java version to 1.6"
			echo $password | sudo -S update-java-alternatives --set java-1.6.0-openjdk-amd64
		fi	
	elif [ "$device_Java_Version" == "5" ];then
		if [ "$now_PC_JavaVersion" != "1.7" ];then
			echo "Change java version to 1.7"
			echo $password | sudo -S update-java-alternatives --set java-1.7.0-openjdk-amd64
		fi	
	elif [ "$device_Java_Version" == "6" ];then
		if [ "$now_PC_JavaVersion" != "1.8" ];then
			echo "Change java version to 1.8"
			echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
		fi	
	elif [ "$device_Java_Version" == "7" ];then
		if [ "$now_PC_JavaVersion" != "1.8" ];then
			echo "Change java version to 1.8"
			echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
		fi	
	elif [ "$device_Java_Version" == "8" ];then
		if [ "$now_PC_JavaVersion" != "1.8" ];then
			echo "Change java version to 1.8"
			echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
		fi
	elif [ "$device_Java_Version" == "9" ];then
		if [ "$now_PC_JavaVersion" != "1.8" ];then
			echo "Change java version to 1.8"
			echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
		fi	
	elif [ "$device_Java_Version" == "10" ];then
		if [ "$now_PC_JavaVersion" != "1.8" ];then
			echo "Change java version to 1.8"
			echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
		fi
	elif [ "$device_Java_Version" == "11" ];then
		if [ "$now_PC_JavaVersion" != "1.11" ];then
			echo "Change java version to 1.11	"
			echo $password | sudo -S update-java-alternatives --set java-1.11.0-openjdk-amd64
		fi
	fi
	java -version
}


function MultiSerial(){

	adb devices | grep daemon
	echo ""
	read -p "how many devices : " countDevice
	echo ""
	declare -i devicesNum=$(adb devices | sed -n '$=')
	devicesNum=$devicesNum-2
	printf "%3s %23s %8s   %14s    %35s \n" No SerialID Status ProductName Fingerprint
	for((i=0;i<devicesNum;i=i+1))
		do
			k=$(($i+2))
			eval SerialID$i=$(adb devices | sed -n "$k"p | awk '{print $1}')
			eval Status$i=$(adb devices | sed -n "$k"p | awk '{print $2}')
			eval ProductName$i=$(eval adb -s \$SerialID$i shell getprop ro.product.name)
			eval deviceFingerPrint$i=$(eval adb -s  \$SerialID$i shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
			eval printf "'%3s %23s %8s %14s         %-14s  \n'" $(($i+1)) \$SerialID$i  \$Status$i \$ProductName$i \$deviceFingerPrint$i
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

}


function CopyMedia(){

devicespace=$(adb -s ${serialArray[0]} shell df -h | grep ' /data' | sed 's/[^ ]*//' | sed 's/[^0-9]*//' | sed 's/ .*//' | sed 's/G//')
if [ $androidVersion == "7.0" ]  || [ $androidVersion == "7.1" ]|| [ "$androidVersion" == "8.0" ] || [ "$androidVersion" == "8.1" ];then
media1920=$"5"
media1280=$"3"

if  [ $devicespace -gt $media1920 ] ;then
	echo $devicespace

		
	cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		 x-terminal-emulator -e  bash copy_media.sh 1920x1080 -s ${serialArray[$i]} &
		done
	 x-terminal-emulator -e bash copy_media.sh  -s ${serialArray[0]}


elif [ $devicespace -gt  $media1280 ] ;then
	echo $devicespace
	
cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		 x-terminal-emulator -e  bash copy_media.sh 1280x720 -s ${serialArray[$i]} &
		done
	x-terminal-emulator -e bash copy_media.sh 1280x720 -s ${serialArray[0]}
else
	cd /CTS_tool/Media/android-cts-media-1.5

	for((i=1;i<countDevice;i=i+1))
		do
		 x-terminal-emulator -e bash copy_media.sh 720x480 -s ${serialArray[$i]} &
		done
	x-terminal-emulator -e bash copy_media.sh 720x480 -s ${serialArray[0]}

fi
fi
}


function reCopyMedia_function(){

	for((count=0;count<=48;count=count+1))
	do
		echo "---------------recopy media check-------------------"
		date -d'+15 hour' +%Y/%m/%d/%T 
		echo "brand : $brand     name: $name"


		for((j=1;j<=$countDevice;j=j+1))
		do
		#check device exist media
		hasMedia=$(eval adb -s \$serial$j shell ls -s /mnt/sdcard/test/bbb_full/480x360/webm_libvpx_libvorbis/bbb_full.ffmpeg.480x360.webm.libvpx_500kbps_25fps.libvorbis_stereo_128kbps_44100Hz.webm)

		#echo $hasMedia
		#output to .txt 
		echo $hasMedia > grepString$j.txt

		#capture string from .txt
		HAS=$(grep -ri "No such file or directory" grepString$j.txt)
		#echo " HAS ="$HAS

		eval echo "check device$j : \$serial$j"
		rm grepString$j.txt
		#check parameter "HAS" not null
		if ["$HAS" = ""];then 
			echo "device have Media file"
		else 
			echo "need to copy"
			cd /CTS_tool/Media/android-cts-media-1.5
			eval bash copy_media.sh 1920x1080 -s \$serial$j
		fi
		done


		autoContinue
		echo "----------------------------------------------------"
		echo "sleep now..."
		sleep $sleepTime
	done
}


function endScript(){
	if [ $1 == 1 ]; then
		message="fingerprint not valid"
		
	elif [ $1 == 2 ]; then
		message="Device abi issue"
		
	elif [ $1 == 3 ]; then
		message="Tool not found. Check in /CTS_tool "
			
	else	
		message="Something wrong"
	fi
	echo "script stop "
	zenity --info --text="$message" && exit
}


function createAck(){
	mkdir /3pl_report/cts/$toolVersion/$brand/$name/ack
    ackString=$(ps aux | grep /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools/cts-tradefed | grep xterm)
	echo "****"
	echo "$ackString"
	echo "****"
	if [ "$ackString" != "" ];then	
		echo full run > /3pl_report/cts/$toolVersion/$brand/$name/ack/"$testerName"_"$name"_FR.ack
		echo "upload ack to FTP..."
		    upload_to_FTP
	else 
		    echo "3PLlaunch CTS fail, please recheck"
	fi
}


function upload_to_FTP(){
#	sleep 3s
#	expect -c "
#	spawn rsync -av --progress --ignore-existing /3pl_report/cts/$toolVersion/"$brand"/"$name"/ack jinny@$toolVersion-test.pegatroncorp.com:/disk3/$toolVersion
#	expect \"yes/no?\"
#	send \"yes\r\"
#	expect \"Password\"
#	send \"pega#1234\r\"

#	interact"

lftp sftp://$SFTP_USER:$SFTP_PWD@$SFTP_SERVER -e  "put /3pl_report/cts/${toolVersion}/${brand}/${name}/ack/${testerName}_${name}_FR.ack -o /disk3/3pl_report/ack/ ; bye"

}






function checkNotExecuted(){
	echo "run continue script"

	cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/results
	resultFolderName=$(ls | grep zip | sed s'/.zip//')
#	echo $resultFolderName

	cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/results/$resultFolderName
	notExecuted=$(grep '<Summary failed=' testResult.xml | sed s'/.*notExecuted="//' | sed s'/" timeout=.*//')
	echo notExecuted= $notExecuted 
#   $(grep '<Summary failed=' testResult.xml | sed s'/.*notExecuted="//' | sed s'/" timeout=.*//')

	if [ $notExecuted -eq 0 ];then
		echo "ya! finish test"
	else
		changeJavaVersion
		cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/results
		rm $resultFolderName.zip

		cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools
		if [ $androidVersion == "6.0" ];then
			xterm -geometry 1024x600+0+0 -e  /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools/cts-tradefed run cts ${serial_options[@]} --shards $countDevice --continue-session 0  --disable-reboot --skip-preconditions &
			cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools
		else 
			xterm -geometry 1024x600+0+0 -e  /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools/cts-tradefed run cts ${serial_options[@]} --shards $countDevice --continue-session 0 --disable-reboot &
			cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools
		fi
	fi
}



function autoContinue(){

	echo "--------------------auto continue-------------------"
	#control on recopyMedia_function

	if [ $androidVersion == "7.0" ]|| [  $androidVersion == "7.1" ] || [ $androidVersion == "8.0" ] || [ "$androidVersion" == "8.1" ]; 
	then
		cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/results
		zip=$(ls | grep "zip")
		##判斷zip是否為空
		if [ ! "$zip" ]; then
			#echo "zip staus is null"
			echo "testing or device(s) disconnect"
		else
			#echo "zip staus is not null"
			echo "test finish and check notExecuted"
			checkMoDulesDone
		fi
	else
		cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/repository/results
		zip=$(ls | grep "zip")
		##判斷zip是否為空
		if [ ! "$zip" ]; then
			#echo "zip staus is null"
			echo "testing or device(s) disconnect"
		else
			#echo "zip staus is not null"
			echo "test finish and check notExecuted"
			checkNotExecuted
	 	fi
	fi	
}

function checkMoDulesDone(){
	echo "run continue script for Android 7 device"

	cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/results

	test_result=$(find  -name "test_result.xml" | sort -r | head -n 1)
	resultFolderName=$(ls -1dt ./*/ |sort -r| head -n 1)
	resultFolderName=$(echo $resultFolderName | sed 's/.\///')
	echo "resultFolderName:"$resultFolderName
	numberZip=$(ls *.zip | wc -l) 
	echo "number of zips : " $numberZip
		numberDirect=$(ls -d */ | wc -l) 
		numberRetries=$(find ./ -name "test_result.xml" | wc -l)
		numberRetries="$(($numberRetries - 1))"
	echo "number of numberRetries : " $numberRetries
#		cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/results/$resultFolderName
#<Summary pass="442824" failed="17" not_executed="0" modules_done="277" modules_total="277" />
	modulesTotal=$(grep '<Summary pass=' $test_result | sed 's/.*modules_total=\"//'|sed 's/\".*//')
	modulesDone=$(grep '<Summary pass='  $test_result | sed 's/.*modules_done=\"//'|sed 's/\".*//')
	mv *.zip ..
	if [ $modulesTotal -eq $modulesDone ];then
		echo "ya! finish all testing modules done"
		
	else
		checkIsRunningDirectory=$(ls -1dt ./*/ |sort -r |head -n 1)
echo "is running dir :" $checkIsRunningDirectory
		if [[ $(find $checkIsRunningDirectory -name "test_re*") ]] ;then
			cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools
			if [ $androidVersion == "7.0" ] || [  $androidVersion == "7.1" ];then
				echo "javiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
					changeJavaVersion
					xterm -geometry 1024x600+0+0 -e  /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools/cts-tradefed run cts ${serial_options[@]}  --shards $countDevice --retry $numberRetries --disable-reboot --skip-preconditions --exclude-filter CtsAppSecurityHostTestCases & cd /3pl_report/cts/$toolVersion/$brand/$name/android-cts/tools
			fi
	  else
		echo "running or cancelled"
		fi
	fi
}




serialAndToolToArray "$@" 
#MultiSerial
CTSDIRECTORY_python
changeJavaVersion
compareFingerPrint
#compareClientID
nautilus /3pl_report/cts/"${version[1]}"/$brand/$name/android-cts/tools
CopyApks
#LaunchChrome
#SelectLauncher
CopyMedia
#CtsSettings
CTS
#createAck
#reCopyMedia_function
