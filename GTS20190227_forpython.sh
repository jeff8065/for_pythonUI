#!/bin/bash 
#Use : GTS for python

password='1'

#--module-arg GtsExoPlayerTestCases:config-url:http://$MediaLocalIp/CTS_tool/Media/dynamic-config-1.0.json \--module-arg GtsYouTubeTestCases:config-url:http://$MediaLocalIp/CTS_tool/Media/YouTube-dynamic-config-1.0.json \--module-arg GtsMediaTestCases:instrumentation-arg:media-path:=http://$MediaLocalIp/CTS_tool/Media/wvmedia
version=""

serialArray=()
serial_options=()
i=0
MediaLocalIp=$(grep Media_Local_IP '/CTS_tool/for_pythonUI/WiFiconfig.ini' | awk '{print $3}')
#echo $MediaLocalIp "############" 


#sleep 10
function serialAndToolToArray(){
#forpython $@	
	while getopts "v:s:m:" option
	do
	
    	case "${option}" in
        
        	v)version=${OPTARG}
		  echo $version
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
		#	echo $countDevice
		  done	 
		;;

        	m)GTSMediaLocal=${OPTARG}
	
		if [ $GTSMediaLocal == "Local" ];then
		 GTSMediaLocal=" --module-arg GtsExoPlayerTestCases:config-url:http://$MediaLocalIp/CTS_tool/Media/dynamic-config-1.0.json --module-arg GtsYouTubeTestCases:config-url:http://$MediaLocalIp/CTS_tool/Media/YouTube-dynamic-config-1.0.json --module-arg GtsMediaTestCases:instrumentation-arg:media-path:=http://$MediaLocalIp/CTS_tool/Media/wvmedia"
		  echo "Local IP: "$MediaLocalIp 
		else 
		GTSMediaLocal=$""
	
		fi		
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
		#	echo ${serial_options[@]}
			
		done
	brand=$(adb -s ${serialArray[$1]} shell getprop ro.product.brand | sed 's/\r//' )
	name=$( adb -s ${serialArray[$1]} shell getprop ro.product.name | sed 's/\r//' )
	today=$(date +"%Y%m%d")
	name="$name"'_'"$today"

}




function MultiSerial(){
	echo "multiserial"
	serialArray=()
	serial_options=()
	
	echo $serialArray
	echo $serial_options
	echo $arguments
	i=0
	for var in $arguments
	do
		
		eval serial$i="$var"
		eval echo "serial$i"="$"serial$i
		eval serialArray+=("$"serial$i)
		
		eval echo "aaa""$serialArray"
		serial_options+=("-s")
		eval serial_options+=("$"serial$i)
		i=$((i + 1))
		echo $i
		countDevice=$i
	done
	echo $serialArray[$1]
	echo $serialArray[$1]

	wewe="1"	
	if [ "$wewe" == "0" ];then
		echo "aaaaaaaaaaaaaaa"
		adb devices | grep daemon
		echo ""
		read -p "how many devices : " countDevice
		echo ""
		declare -i devicesNum=$(adb devices | sed -n '$=')
		devicesNum=$devicesNum-2
		printf "%3s %23s %8s %14s \n" No SerialID Status ProductName
		for((i=0;i<devicesNum;i=i+1))
			do
				k=$(($i+2))
				eval SerialID$i=$(adb devices | sed -n "$k"p | awk '{print $1}')
				eval Status$i=$(adb devices | sed -n "$k"p | awk '{print $2}')
				eval ProductName$i=$(eval adb -s \$SerialID$i shell getprop ro.product.name)
				eval printf "'%3s %23s %8s %14s \n'" $(($i+1)) \$SerialID$i  \$Status$i \$ProductName$i
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
	fi


}

function ChooseVersion(){
	#chooseversion and unzip and prepare
	if [ "$version" == "5.0r2" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/5.0r2/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/5.0_r2/gts-5.0_r2-4389763.zip -d  /3pl_report/gts/5.0r2/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "6.0r1" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/6.0r1/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/6.0_r1"(Android 6.0 - 9.0)"/gts-6.0_r1-4868992.zip -d  /3pl_report/gts/6.0r1/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "6.0r3" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/6.0r3/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/6.0_r3/gts-6.0_r3-5163385.zip -d  /3pl_report/gts/6.0r3/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "6.0r4" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/6.0r4/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/6.0_r4/android-gts-6.0_r4-5356336.zip -d  /3pl_report/gts/6.0r4/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "7.0r4" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/7.0r4/$brand/$name
		unzip -o -q "/CTS_tool/GTS_tool/7.0_r4 Formal Release/android-gts-7_r4-6219464.zip" -d  /3pl_report/gts/7.0r4/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "7.0r5" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/7.0r5/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/7.0_r5/android-gts-7_r5-6497315.zip -d  /3pl_report/gts/7.0r5/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "7.0r2" ];then
		compareFingerPrint
		mkdir -p /3pl_report/gts/7.0r2/$brand/$name
		unzip -o -q /CTS_tool/GTS_tool/7.0_r2/android-gts-7_r2-5805161.zip -d  /3pl_report/gts/7.0r2/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.8.0-openjdk-amd64
	#	adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/6.0r3/$brand/$name/android-xts/tools/"$name"widget
		#adb $serial_option shell am start -a android.intent.action.CALL -d tel:6767
	elif [ "$version" == "8.0r3" ];then
	#	echo $brand
	#	echo $name
		mkdir -p "/3pl_report"/gts/8.0r3/$brand/$name
		echo Folder  :   "/3pl_report"/gts/8.0r3/$brand/$name/$brand/$name
		compareFingerPrint
		#echo "/CTS_tool/GTS_tool/8.0_r1 Preview/android-gts-8-R1\(O-Q\)-6720564.zip"
		unzip -o -q /CTS_tool/GTS_tool//8.0_r3/"android-gts-8-R3(8-10)-7133222.zip" -d "/3pl_report"/gts/8.0r3/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.11.0-openjdk-amd64
		#adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/5.1r2/$brand/$name/android-gts/tools/"$name"widget
		#adb $serial_options shell am start -a android.intent.action.CALL -d tel:6767

	elif [ "$version" == "8.0r4" ];then
		mkdir -p "/3pl_report"/gts/8.0r4/$brand/$name
		echo Folder  :   "/3pl_report"/gts/8.0r4/$brand/$name/$brand/$name
		compareFingerPrint
		sdk=$(adb  ${serial_options[@]}  shell getprop ro.build.version.sdk)
		if [ "$sdk" == "30" ];then
		echo "unzip android-gts-8-R4(11)-7380330.zip "
		unzip -o -q /CTS_tool/GTS_tool/8.0_r4/"android-gts-8-R4(11)-7380330.zip" -d "/3pl_report"/gts/8.0r4/$brand/$name
		else
		echo "unzip android-gts-8-R4(8.1-10)-7380330.zi"
		unzip -o -q /CTS_tool/GTS_tool/8.0_r4/"android-gts-8-R4(8.1-10)-7380330.zip" -d "/3pl_report"/gts/8.0r4/$brand/$name
		fi
		echo $password | sudo -S update-java-alternatives --set java-1.11.0-openjdk-amd64
		
	elif [ "$version" == "8.0r2" ];then
	#	echo $brand
	#	echo $name
		mkdir -p "/3pl_report"/gts/8.0r2/$brand/$name
		echo Folder  :   "/3pl_report"/gts/8.0r2/$brand/$name/$brand/$name
		compareFingerPrint
		#echo "/CTS_tool/GTS_tool/8.0_r1 Preview/android-gts-8-R1\(O-Q\)-6720564.zip"
		unzip -o -q /CTS_tool/GTS_tool/"8.0_r2 Formal"/"android-gts-8-R2(8-10)--6955212.zip" -d "/3pl_report"/gts/8.0r2/$brand/$name
		echo $password | sudo -S update-java-alternatives --set java-1.11.0-openjdk-amd64
		#adb -s $serialID shell dumpsys appwidget >> /GTS_tool/3PL/5.1r2/$brand/$name/android-gts/tools/"$name"widget
		#adb $serial_options shell am start -a android.intent.action.CALL -d tel:6767
	fi
}

function compareFingerPrint(){
	
	#input finger print
	#read -p "please input your fingerprint:" fingerPrint
	fingerPrint=$(adb -s  ${serialArray[$1]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
#	echo 	$fingerPrint
	for((i=0;i<countDevice;i=i+1))
	do
		#capture device finger print 
		deviceFingerPrint=$(adb -s  ${serialArray[$i]} shell getprop | grep "\[ro.build.fingerprint\]" | sed 's/\[ro.build.fingerprint\]: \[//' | sed 's/\].*//')
		if echo $deviceFingerPrint[$i] | grep -ni 'user/release-keys'; then
			    echo ""
			else
				echo "fringer print is not correct"
				echo "device finger print: ""$deviceFingerPrint"
				echo "please recheck"
				endScript "$1"
			fi
	done

	#	if [ "$deviceFingerPrint" == "$fingerPrint" ];then
     	#		echo "fringer print is correct"



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



function runGTS(){

	if [ "$version" == "5.0r2" ];then
		nautilus "/3pl_report"/gts/5.0r2/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/5.0r2/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} 
	elif [ "$version"  == "6.0r1" ];then
		nautilus "/3pl_report"/gts/6.0r1/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/6.0r1/$brand/$name/android-gts/tools

		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts-suite --shard-count $countDevice ${serial_options[@]} 
	elif [ "$version" == "6.0r2" ];then
		nautilus "/3pl_report"/gts/6.0r2/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/6.0r2/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts-suite --shard-count $countDevice ${serial_options[@]} 
	elif [ "$version"  == "6.0r3" ];then
		nautilus "/3pl_report"/gts/6.0r3/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/6.0r3/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts-suite --shard-count $countDevice ${serial_options[@]} 
	elif [ "$version"  == "6.0r4" ];then
		nautilus "/3pl_report"/gts/6.0r4/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/6.0r4/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts-suite --shard-count $countDevice ${serial_options[@]} 

	elif [ "$version"  == "7.0r4" ];then
		nautilus "/3pl_report"/gts/7.0r4/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/7.0r4/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} $GTSMediaLocal

	elif [ "$version"  == "7.0r5" ];then
		nautilus "/3pl_report"/gts/7.0r5/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/7.0r5/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} $GTSMediaLocal

	elif [ "$version"  == "8.0r3" ];then
		nautilus "/3pl_report"/gts/8.0r3/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/8.0r3/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} $GTSMediaLocal

	elif [ "$version"  == "8.0r4" ];then
		nautilus "/3pl_report"/gts/8.0r4/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/8.0r4/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} $GTSMediaLocal
		
	elif [ "$version"  == "8.0r2" ];then
		nautilus "/3pl_report"/gts/8.0r2/$brand/$name/android-gts/tools
		cd "/3pl_report"/gts/8.0r2/$brand/$name/android-gts/tools
		x-terminal-emulator -T $name"_GTS_"$version -e ./gts-tradefed run gts --shard-count $countDevice ${serial_options[@]} $GTSMediaLocal

	fi

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



#MultiSerial
serialAndToolToArray "$@"

ChooseVersion


runGTS

