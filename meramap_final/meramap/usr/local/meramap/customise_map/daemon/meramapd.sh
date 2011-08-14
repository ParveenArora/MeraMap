#!/bin/sh
#
# $Id$
#
# renderQueued	initscript for townguide renderQueue.py
#		This file should be placed in /etc/init.d.
#
# Original Author: Graham Jones
#

set -e

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="renderQueue townguide job queue manager"
NAME=meramapd.py
DAEMON=/usr/local/meramap/daemon/$NAME
PIDFILE=/usr/local/meramap/daemon/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
USER=www-data
LOGDIR=/usr/local/meramap/daemon

# Read config file if it is present.
if [ -r /etc/default/$NAME ]
then
	. /etc/default/$NAME
fi

#
#	Function that starts the daemon/service.
#
d_start() {
	start-stop-daemon --start \
                --chuid $USER \
		--exec $DAEMON \
	        --pidfile $PIDFILE \
                -- \
                --daemon \
                --logdir $LOGDIR \
	        --config /var/www/townguide/townguide.cfg \
	        --pid_file $PIDFILE \
	        -r
}
#	Function that stops the daemon/service.
#
d_stop() {
	start-stop-daemon -o --stop --name renderQueue
}

#
#	Function that sends a SIGHUP to the daemon/service.
#
d_reload() {
	start-stop-daemon --stop --quiet \
		--name $NAME --signal 1
}

case "$1" in
  start)
	echo -n "Starting $DESC"
	d_start
	echo "."
	;;
  stop)
	echo -n "Stopping $DESC"
	d_stop
	echo "."
	;;
  restart|force-reload)
	#
	#	If the "reload" option is implemented, move the "force-reload"
	#	option to the "reload" entry above. If not, "force-reload" is
	#	just the same as "restart".
	#
	echo -n "Restarting $NAME"
	d_stop
	sleep 1
	d_start
	echo "."
	;;
  *)
	# echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
	echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0
