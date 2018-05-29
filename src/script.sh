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
    if [ $1 == "stop-antivirus" ];  then    stopAntivirus=1;    validArg=1;	fi
    if [ $1 == "start-vpn" ];       then    startVpn=1;         validArg=1;	fi
    if [ $1 == "stop-vpn" ];        then    stopVpn=1;          validArg=1;	fi
    if [ $1 == "unlock-profile" ];  then    unlockProfile=1;    validArg=1;	fi

    if [ $validArg -eq 1 ]; then
        shift
    fi
done

Help()
{
    echo
    echo "Usage: sh script.sh	[stop-antivirus] [start-vpn] [stop-vpn] [unlock-profile]"
    echo
}

if [ $validArg -eq 0 ]; then
    Help
    exit 1
fi

# Stop McAfee
StopAntiVirus()
{
    launchctl remove com.mcafee.ssm.ScanManager
}

# Start Pulse Secure
StartVPN()
{
    launchctl load /Library/LaunchAgents/net.pulsesecure.pulsetray.plist
}

# Stop Pulse Secure
StopVPN()
{
    launchctl unload /Library/LaunchAgents/net.pulsesecure.pulsetray.plist
}

# Enable disabled system preferences (Touch ID, iCloud etc.)
# NOTE: unplug LAN cable.
UnlockProfile()
{
    /usr/local/bin/jamf removeFramework
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