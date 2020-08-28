## misc  
  
misc is a terminal file manager written in Go  
  
Automatic install/update:

```shell
bash -c "$(curl -LSs https://github.com/dfmgr/misc/raw/master/install.sh)"
```

Manual install:
  
requires:

Debian based:

```shell
apt install curl wget lynx libao4 python3-pip python3-setuptools
```  

Fedora Based:

```shell
yum install curl wget lynx libao python3-pip python3-setuptools
```  

Arch Based:

```shell
pacman -S curl wget lynx libao python-pip python-setuptools
```  

MacOS:  

```shell
brew install curl wget lynx libao python-pip python-setuptools
```

PIP Packages:

```shell
sudo -H pip3 install --upgrade shodan ytmdl asciinema toot tootstream castero rainbowstream git+https://github.com/sixohsix/python-irclib
```

```shell
mv -fv "$HOME/.config/misc" "$HOME/.config/misc.bak"
git clone https://github.com/dfmgr/misc "$HOME/.config/misc"
  for f in Xresources curlrc wgetrc gntrc inputrc libao profile rpmmacros xscreensaver config/lynx/lynx.cfg config/lynx/lynx.lss config/xresources config/dunst; do
    ln_sf "$APPDIR/$f" "$HOME/.$f"
  done
```
  
<p align=center>
  <a href="https://github.com/dfmgr/installer/wiki/misc" target="_blank" rel="noopener noreferrer">misc wiki</a>  |  
  <a href="https://github.com/dfmgr/misc" target="_blank" rel="noopener noreferrer">misc site</a>
</p>  
