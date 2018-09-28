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


# Clean up docker layers, eg

source: https://github.com/repository-jp/docker-cookbook/blob/39251c82abb1b7d5248bb3b7c592e4cec38d3ee2/applications/pyenv-virtualenv/v20160315/centos/6.7/Dockerfile

```
# Install pyenv.
RUN wget https://github.com/yyuu/pyenv/archive/v${pyenv_version}.tar.gz && \
    tar xvzf v${pyenv_version}.tar.gz && \
    mv pyenv-${pyenv_version} pyenv && \
    rm -f v${pyenv_version}.tar.gz && \
    echo 'export PYENV_ROOT="/usr/local/src/pyenv"' >> /etc/profile.d/pyenv.sh && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/profile.d/pyenv.sh && \
    echo 'eval "$(pyenv init -)"' >> /etc/profile.d/pyenv.sh && \
    exec $SHELL -l && \
    pyenv --version

# Install pyenv-virtualenv.
WORKDIR /usr/local/src/pyenv/plugins
RUN wget https://github.com/yyuu/pyenv-virtualenv/archive/v${pyenv_virtualenv_version}.tar.gz && \
    tar xvzf v${pyenv_virtualenv_version}.tar.gz && \
    mv pyenv-virtualenv-${pyenv_virtualenv_version} pyenv-virtualenv && \
    rm -f v${pyenv_virtualenv_version}.tar.gz && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile.d/pyenv.sh && \
    exec $SHELL -l && \
    pyenv virtualenv --version
```


# another example better pyenv install

- [ ]https://github.com/egormin/ansible_portable/blob/250d6f09e8da7dffa67049b557ae6e48f7665f21/test/runner/Dockerfile

- [ ] https://github.com/croissant/dockerfiles/blob/06d3458f9a99198e439f241f326e18a206290a10/emacs-nox/Dockerfile


# remember to use

RUN su ${USER} -c 'CONFIGURE_OPTS="--enable-shared" /home/${USER}/.pyenv/bin/pyenv install 3.6.2'
