#!/bin/sh
#
# Startup script for Spawn-fcgi

RETVAL=0
prog="spawn-fcgi"


start() {
        echo "Starting spawn-fcgi: "
        sudo spawn-fcgi -f /home/q/htdocs/devweb/web.py -P /home/q/htdocs/fcgi.pid -a 127.0.0.1 -p 12321 -u www -F 5
        RETVAL=$?
        return $RETVAL
}

stop() {
        echo "Stopping spawn-fcgi: "
        less /home/q/htdocs/fcgi.pid | xargs sudo kill -9 
        RETVAL=$?
        [ $RETVAL -eq 0 ] && sudo rm -f /home/q/htdocs/fcgi.pid
        return $RETVAL
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        restart)
                stop
                start
                ;;
        *)
                echo $"Usage: $0 {start|stop|restart}"
                RETVAL=1
esac

exit $RETVAL