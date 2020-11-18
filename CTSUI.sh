#!/bin/bash
version=$"20201112"
pc=$(whoami)
SFTP_SERVER="ftp.pegatroncorp.com"
SFTP_USER="FTP_vendorV751-RW"
SFTP_PWD="66x3gF^!v"
home=$(whoami)
ubuntuVersion=$(lsb_release -r -s)

cp -r /CTS_tool/for_pythonUI/CTSUI.sh /home/$home 
chmod 755 /home/$home/CTSUI.sh
cp -r /CTS_tool/for_pythonUI/CTSUI.sh /home/$home/Desktop
chmod 755 /home/$home/Desktop/CTSUI.sh


function checkversion()
{
	cd /CTS_tool/for_pythonUI
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1SxsD5PohijHJZTknm7xY377H8b1qJvIU" -O CTSUI.sh  
	echo "1"| sudo -S chmod 755 CTSUItest.sh

	input="/CTS_tool/for_pythonUI/version.txt"
	while IFS= read -r line
	do
	#  echo "$line"
	  ss=$line
	done < "$input"


	if [ $version == $ss ]; then
	echo "done"

	else
	echo "Download CTStool.zip"
	echo $version > version.txt
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1Ks0zwAWuHC-11v9X_Tj7T_-yW94h-i7D" -O CTStool.zip 
        unzip -o CTStool.zip
fi

}
function GoogleDriveDownload()
{
	cd /CTS_tool/for_pythonUI
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1SxsD5PohijHJZTknm7xY377H8b1qJvIU" -O CTSUI.sh  
	echo "1"| sudo -S chmod 755 CTSUI.sh
	sleep 2
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1lu1LF9V6Ahn7wgzOf8q8MY0l7Vzdp1B6" -O CTS1.py  
	echo "1"| sudo -S chmod 755 CTS1.py 
	sleep 3
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1RGlch5kmur1tqR_9Yv4YcbmMRm5fpeaX" -O DeviceSetup.py
	echo "1"| sudo -S chmod 755 DeviceSetup.py
	sleep 3
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1DIrTTxwkH9mwvrC4uc70zZRKgJgBi5cU" -O GTS20190227_forpython.sh  
	echo "1"| sudo -S chmod 755 GTS20190227_forpython.sh
	sleep 3
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1RsXtilvdRz9M-U3R1lqniEGFKgJlZ-LU" -O INSTANT_20181220_forpython.sh 
	echo "1"| sudo -S chmod 755 INSTANT_20181220_forpython.sh
	sleep 3
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1ZYj1JrpnlIcmjJCWiplETb-v_CWqqimo" -O VTS20190110_forpython.sh
	echo "1"| sudo -S chmod 755 VTS20190110_forpython.sh
	sleep 3
	wget --no-check-certificate  "https://drive.google.com/uc?export=download&id=1KIH8yaq9nv45SY9Bx1wCl4AjMjd6a-bk" -O CTS_full_test_script_20190110_forpython.sh
	echo "1"| sudo -S chmod 755 CTS_full_test_script_20190110_forpython.sh
	sleep 3




}


function Sync_CTSUI()
{
	echo "1"| sudo -S sudo apt-get install -y python-tk
	#lftp ftp://$SFTP_USER:$SFTP_PWD@$SFTP_SERVER -e 'mirror -n  /CTS_tools/for_pythonUI/CTS_tool/for_pythonUI ; bye'
	echo "1"| sudo apt-get install python3-bs4
	sudo chmod 755 /CTS_tool/for_pythonUI/*

	yes | '/home/'$home'/android-sdk-linux/tools/bin/sdkmanager' --update
	echo "=============================================================================="
	echo ""
	echo ""
	if [ $ubuntuVersion == '18.04' ] ;then
	echo "1"| sudo pip install virtualenv --upgrade
	fi
	python '/CTS_tool/for_pythonUI/CTS1.py'
}

function MediaLocal()
{
	cd /CTS_tool/Media
	search_GtsMediatxt=$(ls | grep -m1 GtsMedia-dynamic-config-1.0.txt )
	GtsMedia=GtsMedia-dynamic-config-1.0.txt

	if [ "$search_GtsMediatxt" == "$GtsMedia" ] ;then
	echo "GtsMedia.txt existing"
	else

	cd /CTS_tool/Media
	echo " " > GtsMedia-dynamic-config-1.0.txt
	echo "Cerate GtsMedia.txt"
	fi

	search_CtsMediatxt=$(ls | grep -m1 CtsMedia.txt )
	CtsMedia=CtsMedia.txt
	if [ "$search_CtsMediatxt" == "$CtsMedia" ] ;then
	echo "CtsMedia.txt existing"
	else

	cd /CTS_tool/Media
	echo "/CTS_tool/Media/android-cts-media-1.5" > CtsMedia.txt
	echo "Cerate CtsMedia.txt"
	fi




	cd ~
	CheckBashrcGts=$(grep -q  "export GtsMedia" .bashrc && echo "0" || echo "1")
	if [ $CheckBashrcGts == "1" ];then
	echo 'GtsMedia=$(head /CTS_tool/Media/GtsMedia-dynamic-config-1.0.txt)' >>~/.bashrc
	echo "export GtsMedia" >> ~/.bashrc
		else
		echo "bashrc existing"

	fi
	
	CheckBashrcCts=$(grep -q  "export CtsMedia" .bashrc && echo "0" || echo "1")
	if [ $CheckBashrcCts == "1" ];then
	echo 'CtsMedia=$(head /CTS_tool/Media/CtsMedia.txt)' >>~/.bashrc
	echo "export CtsMedia" >> ~/.bashrc
		else
		echo "bashrc existing"

	fi


}

#MediaLocal
#echo "############################################"
#if [ $ubuntuVersion == '16.04' ];then
#Ubuntu16
#fi
###############################
######################
#GoogleDriveDownload
checkversion
CheckOpenJdk
Sync_CTSUI
