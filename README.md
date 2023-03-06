# Pimp my lock
You've got to pimp my lock !

![output](https://user-images.githubusercontent.com/59874848/223180437-5714a14d-59b5-431c-a334-d25244768233.gif)

## Installation
If you are logged at 42Paris, you can skip to [Usage at 42Paris](#usage-at-42paris) section
```bash
make
```

### Binary dependencies
- head
- column
- sed
- cat
- mediainfo
- tail
- pqiv
- mpv
- xwininfo
- grep
- awk
- wmctrl
- xdotool
- bash

### General installation (Ubuntu)
```bash
sudo apt install coreutils bsdextrautils x11-utils sed mediainfo pqiv mpv grep wmctrl xdotool bash
```
If any file are missing during build, try using `apt-file`. See [here](https://wiki.debian.org/apt-file)

## General usage
```bash
./pimp_my_lock.sh <path_to_media> [<x> <y> [<width> <height>]]
```

## Usage at 42Paris
```bash
/sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock.sh <path_to_media> [<x> <y> [<width> <height>]]
```

Values can be percents or keywords. See help using `/sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock` without arguments

## How do I change the lock button to Pimp my lock at 42Paris ?
- Create a script called "$HOME/pimp_my_lock_wrapper.sh" that will start Pimp my lock with your arguments 
- Disable old lock button: 
	gnome-extensions disable lockscreen@42network.org
- Get Pimp my lock's button:
	cp -R /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/lockscreen@pimpmylock.sh ~/.local/share/gnome-shell/extensions/
- Restart your session
- Enable Pimp my lock's button:
	gnome-extensions enable lockscreen@pimpmylock.sh

## A problem ?
If you have any problem, please open an issue on https://github.com/jerem-ma/pimp_my_lock/issues

## Contributing
1. Fork this repository (https://github.com/jerem-ma/pimp_my_lock/fork)
2. Create a feature branch
3. Do your things
4. Open a Pull Request on v2 branch
