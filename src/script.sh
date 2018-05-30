#!/bin/sh

validArg=1
stopAntiVirus=0
startAntiVirus=0
startVpn=0
stopVpn=0
unlockProfile=0

if [ $# -eq 0 ]; then
    validArg=0
fi

# Loop through the args
while [ $# -gt 0  -a  $validArg -eq 1 ]; do
    validArg=0;
    if [ $1 == "stop-av" ];         then    stopAntiVirus=1;    validArg=1;	fi
    if [ $1 == "start-av" ];        then    startAntiVirus=1;   validArg=1;	fi
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
    echo "Usage: sh script.sh	[start-av] [stop-av] [start-vpn] [stop-vpn] [unlock-profile]"
    echo
}

if [ $validArg -eq 0 ]; then
    Help
    exit 1
fi

# Stop McAfee
StopAntiVirus()
{
    launchctl unload /Library/LaunchAgents/com.mcafee.menulet.plist
    launchctl unload /Library/LaunchAgents/com.mcafee.reporter.plist
}

# Start McAfee
StartAntiVirus()
{
    launchctl load /Library/LaunchAgents/com.mcafee.menulet.plist
    launchctl load /Library/LaunchAgents/com.mcafee.reporter.plist
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
UnlockProfile()
{
    /usr/local/bin/jamf removeFramework
}

if [ $stopAntiVirus -eq 1 ]; then
    StopAntiVirus
fi

if [ $startAntiVirus -eq 1 ]; then
    StartAntiVirus
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