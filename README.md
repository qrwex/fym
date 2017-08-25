# Free your Mac

### Usage
```sh
$ sudo sh script.sh	[stop-antivirus] [start-vpn] [stop-vpn] [unlock-profile]
```
### Antivirus
Stop Mcafee:
```sh
$ sudo sh script.sh	stop-antivirus
```
### VPN
Start PulseSecure:
```sh
$ sudo sh script.sh	start-vpn
```

Stop PulseSecure:
```sh
$ sudo sh script.sh	stop-vpn
```

### System Preferences
Enable disabled system preferences (Touch ID, iCloud etc.). Unplug LAN cable before executing.
```sh
$ sudo sh script.sh	unlock-profile
```