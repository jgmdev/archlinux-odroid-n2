#!/bin/bash

alarm_check_root() {
    if [ $(id -u) -ne 0 ]; then
        echo "You need to be root to execute this command." 1>&2
        exit 1
    fi
}

case "$1" in
    "status")
        if grep "/usr/lib" /etc/ld.so.conf.d/gl4es.conf > /dev/null ; then
            echo "GL4ES Enabled"
        else
            echo "GL4ES Disabled"
        fi

        exit 0
        ;;
    "toggle")
        alarm_check_root

        if grep "/usr/lib" /etc/ld.so.conf.d/gl4es.conf > /dev/null ; then
            echo "" > /etc/ld.so.conf.d/gl4es.conf
            echo "GL4ES Disabling..."
        else
            echo "/usr/lib/gl4es" > /etc/ld.so.conf.d/gl4es.conf
            echo "GL4ES Enabling..."
        fi

        ldconfig

        exit 0
        ;;
    "config")
        alarm_check_root
        nano /etc/profile.d/gl4es.sh

        exit 0
        ;;
    "run")
        shift

        if grep "/usr/lib" /etc/ld.so.conf.d/gl4es.conf > /dev/null ; then
            $@
        else
            LD_LIBRARY_PATH=/usr/lib/gl4es \
              $@
        fi

        exit 0
        ;;
    *)
        echo "Basic utility to administer gl4es."
        echo "Usage: odroid-gl4es <command>"
        echo ""
        echo "COMMANDS:"
        echo ""
        echo "  status - Print the gl4es activation status."
        echo ""
        echo "  toggle - Enable or disable gl4es OpenGL hi-jacking."
        echo ""
        echo "  config - Edit the environment variables related to gl4es."
        echo ""
        echo "  run <command> - Run a command with GL4ES enabled "
        echo "                  even if it is Disabled."
        echo ""

        exit 0
esac
