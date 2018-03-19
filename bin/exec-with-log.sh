#!/bin/sh

# SOURCE: https://github.com/freedesktop/telepathy-salut/blob/8ad4fd8cd6f2f59fea168311324a98e2af1a8c7f/tests/twisted/tools/exec-with-log.sh.in

cd "@abs_top_builddir@/tests/twisted/tools"

export SALUT_DEBUG=all GIBBER_DEBUG=all WOCKY_DEBUG=all
export SALUT_PLUGIN_DIR="@abs_top_builddir@/plugins/.libs"
export G_SLICE=debug-blocks
G_MESSAGES_DEBUG=all
export G_MESSAGES_DEBUG
ulimit -c unlimited
exec >> salut-testing.log 2>&1

if test -n "$SALUT_TEST_VALGRIND"; then
	export G_DEBUG=gc-friendly
	export G_SLICE=always-malloc
	SALUT_WRAPPER="valgrind --leak-check=full --num-callers=20"
elif test -n "$SALUT_TEST_REFDBG"; then
        if test -z "$REFDBG_OPTIONS" ; then
                export REFDBG_OPTIONS="btnum=10"
        fi
        if test -z "$SALUT_WRAPPER" ; then
                SALUT_WRAPPER="refdbg"
        fi
elif test -n "$SALUT_TEST_BACKTRACE"; then
        SALUT_WRAPPER="gdb -q -x run_and_bt.gdb"
fi

if ! test -n "$SALUT_TEST_REAL_AVAHI"; then
    # The bus-daemon that is activating us doesn't know it's also the system bus
    export DBUS_SYSTEM_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS"
fi

export G_DEBUG=fatal-warnings" ${G_DEBUG}"
exec @abs_top_builddir@/libtool --mode=execute $SALUT_WRAPPER @abs_top_builddir@/src/telepathy-salut
