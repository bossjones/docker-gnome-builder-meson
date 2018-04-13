SOURCE: https://github.com/jaraco/keyring/blob/master/README.rst

Using Keyring on Ubuntu 16.04
=============================

The following is a complete transcript for installing keyring in a
virtual environment on Ubuntu 16.04.  No config file was used.::

  $ sudo apt install python3-venv libdbus-glib-1-dev
  $ cd /tmp
  $ pyvenv py3
  $ source py3/bin/activate
  $ pip install -U pip
  $ pip install secretstorage dbus-python
  $ pip install keyring
  $ python
  >>> import keyring
  >>> keyring.get_keyring()
  <keyring.backends.SecretService.Keyring object at 0x7f9b9c971ba8>
  >>> keyring.set_password("system", "username", "password")
  >>> keyring.get_password("system", "username")
  'password'


Using Keyring on headless Linux systems
=======================================

It is possible to use the SecretService backend on Linux systems without
X11 server available (only D-Bus is required). To do that, you need the
following:

* Install the `GNOME Keyring`_ daemon.
* Start a D-Bus session, e.g. run ``dbus-run-session -- sh`` and run
  the following commands inside that shell.
* Run ``gnome-keyring-daemon`` with ``--unlock`` option. The description of
  that option says:

      Read a password from stdin, and use it to unlock the login keyring
      or create it if the login keyring does not exist.

  When that command is started, enter your password into stdin and
  press Ctrl+D (end of data). After that the daemon will fork into
  background (use ``--foreground`` option to prevent that).
* Now you can use the SecretService backend of Keyring. Remember to
  run your application in the same D-Bus session as the daemon.

.. _GNOME Keyring: https://wiki.gnome.org/Projects/GnomeKeyring
