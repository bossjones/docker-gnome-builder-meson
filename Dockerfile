FROM fedora:rawhide

LABEL Maintainer "Malcolm Jones <bossjones@theblacktonystark.com>"

RUN dnf -y update && \
    dnf group install "C Development Tools and Libraries" -y; \
    dnf -y install git gcc-c++ gjs gjs-devel libpeas-devel \
    gtksourceview3-devel libgit2-devel libgit2-glib-devel clang-devel file vala-devel vala llvm-devel vte-devel \
    vte291-devel vala-tools redhat-rpm-config; \
    dnf groupinstall -y development-libs development-tools gnome-software-development; \
    dnf -y install ninja-build \
    libdazzle-devel json-glib-devel jsonrpc-glib-devel vte291-devel libxml2-devel desktop-file-utils webkit2gtk3-devel appstream-devel libappstream-glib libappstream-glib-devel libappstream-glib-builder-devel ctags ctags-etags devhelp-libs devhelp-devel flatpak-devel flatpak-libs flatpak-builder gspell-devel sysprof-devel autoconf automake enchant-devel template-glib-devel \
    gcc gcc-c++ \
    gcc-gfortran gcc-objc \
    gcc-objc++ java-devel \
    mono-core mono-devel \
    libdazzle-devel \
    libgcc-devel \
    libgit2-glib-devel \
    libpeas-devel \
    libsoup-devel \
    libsysprof-ui \
    libxml2-devel \
    template-glib-devel \
    vala \
    boost-devel \
    gtest-devel \
    gmock-devel \
    qt5-qtbase-devel \
    wxGTK3-devel \
    flex bison \
    gettext \
    gnustep-base-devel \
    git-core \
    "pkgconfig(protobuf)" \
    "pkgconfig(glib-2.0)" \
    "pkgconfig(gobject-introspection-1.0)" \
    "pkgconfig(zlib)"; \
    dnf clean all


RUN cd /usr/local/src/; \
    curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
    curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
    python ez_setup.py; \
    python get-pip.py; \
    dnf install python3-devel -y; \
    cd /usr/local/src/; \
    python3 ez_setup.py; \
    python3 get-pip.py; \
    pip3 install -I path.py==7.7.1; \
    pip3 install virtualenv virtualenvwrapper ipython; \
    pip3 install meson

RUN cd /usr/local/src && \
    git clone git://git.gnome.org/gnome-builder && \
    cd gnome-builder && \
    meson --prefix=/usr build && \
    ninja -C build && \
    ninja -C build install

RUN useradd -m -d /home/developer developer

USER developer

ENTRYPOINT ["/usr/bin/gnome-builder"]
