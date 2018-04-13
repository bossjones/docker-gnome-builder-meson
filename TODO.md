- [ ] Add tmux support
- [ ] Add pyenv support
- [ ] Add rbenv support
- [ ] Add nvm support
- [ ] How can I copy text from xterm (Awesome, Debian, VirtualBox)?https://unix.stackexchange.com/questions/225062/how-can-i-copy-text-from-xterm-awesome-debian-virtualbox
- [ ] Add default X rc config files, eg:
    - [ ] `.gtkrc-2.0`: https://github.com/fcwu/docker-ubuntu-vnc-desktop/blob/master/image/root/.gtkrc-2.0
    - [ ] `~/.Xresources`
    - [ ] `xinit`
    - [ ] `xinitrc-common`
    - [ ] `$HOME/.Xmodmap` https://github.com/saimn/dotfiles/blob/master/xinitrc
    - [ ] `$HOME/.Xdefaults`
    - [ ] `~/.xprofile`
- [ ] Consider supervisord as startup system
- [ ] Consider straight up systemd as startup system


```
# Mess w/ fedora workstation

# Enable the GUI at startup
systemctl enable gdm.service
systemctl set-default graphical.target
```
