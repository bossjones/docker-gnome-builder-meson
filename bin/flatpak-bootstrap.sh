#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x
# set -eu -o pipefail

# grab sudo priviledges so we do not need to interrupt the following process if they are needed
# SOURCE: https://github.com/niccokunzmann/cp-docker-development/blob/212363005e107525bdbb9780508ec0d1b11b0f6c/docker/ubuntu/build/run_all.sh
sudo true

# sudo flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo

# flatpak remote-add --user --from gnome https://sdk.gnome.org/gnome.flatpakrepo

# flatpak install --user -y --from https://flathub.org/repo/appstream/org.gnome.Builder.flatpakref
# flatpak --user install gnome org.gnome.Platform//3.22
# flatpak --user install gnome org.gnome.Sdk//3.22
# SYSTEM WIDE, REQUIRES SUDO
# flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo
# flatpak install gnome org.gnome.Platform//3.22
# flatpak install gnome org.gnome.Sdk//3.22
# flatpak --user remote-add --gpg-import=/home/developer/gnome-sdk.gpg gnome https://sdk.gnome.org/gnome.flatpakrepo
# flatpak --user remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo

# Download the Gnome SDK keys
wget -P /home/developer https://sdk.gnome.org/keys/gnome-sdk.gpg
wget -P /home/developer https://sdk.gnome.org/keys/gnome-sdk-autobuilder.gpg

# Add the Gnome Flatpak Repositories:
# NOTE: The command below will give you this error ( SOURCE: https://github.com/flatpak/flatpak/issues/1187 )
# Installing for user: org.gnome.Sdk/x86_64/3.28 from flathub
# error: GPG signatures found, but none are in trusted keyring
# flatpak --user remote-add --gpg-import=/home/developer/gnome-sdk.gpg gnome https://sdk.gnome.org/repo/

flatpak --user remote-add --gpg-import=/home/developer/gnome-sdk.gpg gnome https://sdk.gnome.org/gnome.flatpakrepo

# flatpak --user remote-add --gpg-import=/home/developer/gnome-sdk.gpg gnome-apps https://sdk.gnome.org/repo-apps/

echo "BOSSJONES: Install the Gnome runtimes"
echo "BOSSJONES: Install the Gnome runtimes"
echo "BOSSJONES: Install the Gnome runtimes"

# Install the Gnome runtimes
flatpak --user install gnome org.gnome.Platform//3.22
flatpak --user install gnome org.gnome.Sdk//3.22
flatpak --user install gnome org.gnome.Platform//3.24
flatpak --user install gnome org.gnome.Sdk//3.24

echo "BOSSJONES: flatpak remotelist"
echo "BOSSJONES: flatpak remotelist"
echo "BOSSJONES: flatpak remotelist"

# flatpak remotelist
flatpak --user remote-list --show-details

echo "BOSSJONES: Check the installed runtimes"
echo "BOSSJONES: Check the installed runtimes"
echo "BOSSJONES: Check the installed runtimes"

# Check the installed runtimes
flatpak --user list --runtime --show-details

echo "BOSSJONES: Install gnome builder"
echo "BOSSJONES: Install gnome builder"
echo "BOSSJONES: Install gnome builder"

# Install gnome builder
flatpak --user install -y -v --from https://flathub.org/repo/appstream/org.gnome.Builder.flatpakref
