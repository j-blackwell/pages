# James Robinson
Data Consultant


## Blog - Linux Gaming

### Controller
ds4srv

### Proton/Wine/GE
Change winecfg to Windows 10.

### Rocket League

### BakkesMod
Instructions from [this video](https://www.youtube.com/watch?v=XEhfQLZORf8).

1. [Download BakkesMod](https://bakkesmod.com/download.php)
2. Unzip the download and run the setup executable with wine: `wine BakkesModSetup.exe`
3. Upon completion of install, run BakkesMod.exe with wine.
4. If you are met with a message reading _"Mod is out of date, waiting for an update"_, then click `File -> Reinstall`. This should fix it.
5. Then you should see _"No RL installation detected"_. To fix this, you will need to find the path to your `RocketLeague.exe` file manually. First, go to the game's properties in steam, and browse the local files. This will give you the path to the game. In my case, it is `/home/jrob/.steam/debian-installation/steamapps/common/rocketleague`. Now in BakkesMod, go to `Settings -> Manually select BakkesMod folder` - a windows looking explorer should pop up. Here, your linux files can be accessed via the Z drive (in my case) in My Computer. However, also in my case, hidden files are not shown here, so in the file name bar, paste the above with a prefix of Z and backslashes, i.e. `Z:\home\jrob\.steam\debian-installation\steamapps\common\rocketleague`. Pressing open should then direct you to the game's folders where you can now find the `RocketLeague.exe` file. Close BakkesMod once you have done this.
6. Next up, you need to create a `rocket.sh` file in the BakkesMod folder (mine is `/home/jrob/.wine/drive_c/"Program Files"/BakkesMod`) with the following contents:
```
#!/bin/sh

_PROTON="/home/jrob/.steam/debian-installation/compatibilitytools.d/Proton-5.9-GE-1-MF/proton"

$_PROTON run /home/jrob/.wine/drive_c/"Program Files"/BakkesMod/BakkesMod.exe &
$_PROTON run RocketLeague.exe
```
Run `chmod +x rocket.sh` to change the permissions of the file.
You can test that it is working by running `winconsole cmd` and then running the `rocket.sh` file from the windows command line and looking for error messages.

7. Add the following to the launch options for Rocket League in steam: `alacritty -e /home/jrob/.wine/drive_c/"Program Files"/BakkesMod/rocket.sh && echo %command% &>/dev/null`. If you had any pre-existing launch commands, add it before `$_PROTON` in the final line of `rocket.sh`.
8. Run Rocket League from steam.

