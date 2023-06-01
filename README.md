# Script for slignal-cli installation with Octopi

After having encountered several difficulties installing Signal-cli on octopi, I decided to create my own installation script.

Basically, it automates the download of Signal-cli pre-compiled for Raspberry Pi, the pre-compiled library for RPI and puts everything in the right files.
The main advantage of this script is that no compilation is required. Everything is already compiled on Github.
On small systems that have 1GB of RAM for example, this is very useful.

## Installation

You must first install Octopi and access your session by SSH.
Then update Octopi with:
```sh
sudo apt-get update && sudo apt-get upgrade
```
then reboot :
```sh
sudo reboot
```

Connect again by SSH then go to the root of your system:
```sh
cd ~
```
and download my script
```sh
sudo wget https://
```
Getting the latest version number of signal-cli [here](https://github.com/AsamK/signal-cli/releases/).
_As of this writing, the version is 0.11.11_

Change the version number in the script:
```sh
nano ./signal-cli-install.sh
```
Go with the down arrow to the line: _export VERSION=0.11.11_ change to the number noted above.
Save with ```CTRL + X``` then ```Y``` then ```ENTER```

make the script executable and launch it 
```sh
sudo chmod +x ./signal-cli-install.sh && sudo ./signal-cli-install.sh
```

If all went well, you should see a version of the latest signal-cli installed.

Then, all you have to do is register by following [this tutorial](https://github.com/AsamK/signal-cli#usage)

**Attention!! You are required to register via captcha!!
If you want to register a landline number, follow [this post.](https://github.com/AsamK/signal-cli/issues/1202#issuecomment-1508810292)**


# Licence

This project uses signal-cli : https://github.com/AsamK/signal-cli

And libsignal : https://github.com/exquo/signal-libs-build/
