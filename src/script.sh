#!/bin/sh

validArg=1
stopAntivirus=0
startVpn=0
stopVpn=0
unlockProfile=0

if [ $# -eq 0 ]; then
	validArg=0
fi

# Loop through the args
while [ $# -gt 0  -a  $validArg -eq 1 ]; do
	validArg=0;
	if [ $1 == "stop-antivirus" ];	then	stopAntivirus=1;	validArg=1;	fi
	if [ $1 == "start-vpn" ];		then	startVpn=1;			validArg=1;	fi
	if [ $1 == "stop-vpn" ];		then	stopVpn=1;			validArg=1;	fi
	if [ $1 == "unlock-profile" ];	then	unlockProfile=1;	validArg=1;	fi

	if [ $validArg -eq 1 ]; then
		shift
	fi
done

Help()
{
	echo
	echo "Usage: sudo sh script.sh	[stop-antivirus] [start-vpn] [stop-vpn] [unlock-profile]"
	echo
}

if [ "$EUID" -ne 0 ];	then
	echo
	echo "Please run as root"
  	Help
  	exit 1
fi

if [ $validArg -eq 0 ]; then
	Help
	exit 1
fi

# Stop Mcafee
StopAntiVirus()
{
	echo
	echo "Stopping Mcafee AntiVirus"
	launchctl remove com.mcafee.ssm.ScanManager
	echo
}

# Start BESAgentControlPanel
StartVPN()
{
	echo
	echo "Starting BESAgentControlPanel"
	/Library/BESAgent/BESAgent.app/Contents/MacOS/BESAgentControlPanel.sh -start
	echo
}

# Stop BESAgentControlPanel
StopVPN()
{
	echo
	echo "Stopping BESAgentControlPanel"
	/Library/BESAgent/BESAgent.app/Contents/MacOS/BESAgentControlPanel.sh -stop
	sleep 2
	launchctl stop net.pulsesecure.AccessService
	echo
}

# Enable disabled system preferences (Touch ID, iCloud etc.)
# NOTE: unplug LAN cable.
UnlockProfile()
{
	echo
	echo "Unlocking profile"
	MDM_UUID=$(profiles -Lv | awk '/attribute: name: MDM/,/attribute: profileUUID:/' | awk '/attribute: profileUUID:/ {print $NF}')
	echo "MDM_UUID:" $MDM_UUID

	if [ -z "$MDM_UUID" ]; then
        echo "MDM profile NOT found. Attempting to manage"
        jamf manage
	else
        echo "MDM profile found. Removing MDM before attempting to manage"
        profiles -R -p "$MDM_UUID"
        sleep 2
        jamf manage
	fi

	echo "Disabling JAMF"
    sleep 1
    launchctl remove com.jamfsoftware.task.Every\ 15\ Minutes
    launchctl remove com.jamfsoftware.jamf.daemon
    launchctl remove com.jamfsoftware.jamf.agent
    echo "Listing enabled JAMF services"
    launchctl list | grep com.jam
    echo
}

if [ $stopAntivirus -eq 1 ]; then
	StopAntiVirus
fi


if [ $startVpn -eq 1 ]; then
	StartVPN
fi

if [ $stopVpn -eq 1 ]; then
	StopVPN
fi


if [ $unlockProfile -eq 1 ]; then
	UnlockProfile
fi

exit 0