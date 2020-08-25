## misc  
  
miscellaneous files  
  
requires:    
```
apt install curl wget lynx libao4 python3-pip python3-setuptools
```  
```
yum install curl wget lynx libao python3-pip python3-setuptools
```  
```
pacman -S curl wget lynx libao python-pip python-setuptools
```  
PIP Packages:
```
sudo -H pip3 install --upgrade shodan ytmdl asciinema toot tootstream castero rainbowstream git+https://github.com/sixohsix/python-irclib
```
Automatic install/update:
```
bash -c "$(curl -LSs https://github.com/dfmgr/misc/raw/master/install.sh)"
```
Manual install:
```
mv -fv "$HOME/.config/misc" "$HOME/.config/misc.bak"
git clone https://github.com/dfmgr/misc "$HOME/.config/misc"
for f in Xresources curlrc gntrc inputrc libao lynx.cfg lynx.lss profile rpmmacros xscreensaver ; do ln -sf $APPDIR/$f $HOME/.$f ; done
```
  
  
<p align=center>
  <a href="https://github.com/dfmgr/misc" target="_blank">misc site</a>
</p>  
