# Pimp my lock
You've got to pimp my lock !

## Installation
If you are logged at 42Paris, you can skip to `Usage at 42Paris` section
```bash
make
```

## General usage
```bash
./pimp_my_lock.sh <path_to_media> [<x> <y> [<width> <height>]]
```

## Usage at 42Paris
```bash
/sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock/pimp_my_lock.sh <path_to_media> [<x> <y> [<width> <height>]]
```

## How do I change the lock button to Pimp my lock at 42Paris ?
- Create a script called "$HOME/pimp_my_lock_wrapper.sh" that will start Pimp my lock with your arguments 
- Disable old lock button: 
	gnome-extensions disable lockscreen@42network.org
- Get Pimp my lock's button:
	cp -R /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock/lockscreen@pimpmylock.sh ~/.local/share/gnome-shell/extensions/
- Restart your session
- Enable Pimp my lock's button:
	gnome-extensions enable lockscreen@pimpmylock.sh

## Contributing
1. Fork this repository (https://github.com/jerem-ma/pimp_my_lock/fork)
2. Create a feature branch
3. Do your things
4. Open a Pull Request
