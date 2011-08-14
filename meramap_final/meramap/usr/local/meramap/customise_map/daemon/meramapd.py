#!/usr/bin/python
#
#    This file is part of townguide - a simple utility to produce a
#    town guide identifying key amenities from OpenStreetMap data.
#
#    Townguide is free software: you can redistribute it and/or modify
#    it under ther terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Townguide is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with townguide.  If not, see <http://www.gnu.org/licenses/>.
#
#    Copyright Graham Jones 2009, 2010
#
import os,sys
from datetime import datetime
import time

WDIR = '/usr/local/meramap/daemon'


class renderQueue:
    def __init__(self,daemon,cFname,retry,pidfile):
        
        if cFname==None:
            print "using default directories"
            self.wkdir = "/home/graham/townguide/src/www/output"
            self.datadir = "/home/graham/townguide/src"
            self.mapFileName = "/home/graham/mapnik_osm/osm.xml"
        else:
            print "reading directories from file %s." % cFname
            ip = open(cFname,"r")
            lines=ip.readlines()
            # rstrip removes the trailing \n from the lines, which mess up
            # mapnik otherwise.
            self.datadir = lines[0].rstrip()
            self.mapFileName = lines[1].rstrip()
            self.wkdir = lines[2].rstrip()
            ip.close()
            

        
        
        self.dbname = "townguide"
        self.uname  = "graham"

        self.NOT_STARTED = 0
        self.RUNNING = 1
        self.COMPLETE = 2
        self.ERROR = 3

        self.statusList = {
            self.NOT_STARTED:'Not Started',
            self.RUNNING:'Running',
            self.COMPLETE:'Complete',
            self.ERROR:'Error'}

        if (retry):
            self.setRetryFailedJobs()


        if (daemon):
            # do the UNIX double-fork magic, see Stevens' "Advanced
            # Programming in the UNIX Environment" for details (ISBN 0201563177)
            try:
                pid = os.fork()
                if pid > 0:
                    # exit first parent
                    sys.exit(0)
            except OSError, e:
                print >>sys.stderr, "fork #1 failed: %d (%s)" % (e.errno, e.strerror)
                sys.exit(1)

            # decouple from parent environment
            os.chdir("/")   #don't prevent unmounting....
            os.setsid()
            os.umask(0)

            # do second fork
            try:
                pid = os.fork()
                if pid > 0:
                    # exit from second parent, print eventual PID before
                    #print "Daemon PID %d" % pid
                    of = open(pidfile,'w')
                    of.write("%d"%pid)
                    of.close()
                    sys.exit(0)
            except OSError, e:
                print >>sys.stderr, "fork #2 failed: %d (%s)" % (e.errno, e.strerror)
                sys.exit(1)

            # start the daemon main loop
            retcode = 0
            #retcode = self.createDaemon()
            #daemonize()
            print "createDaemon exited with retcode %d" % retcode
            self.queueLoop()


    def createDaemon(self):
        print "createDaemon"
        import os
        import sys
        UMASK=0
        MAXFD = 1024

        if (hasattr(os,"devnull")):
            REDIRECT_TO = os.devnull
        else:
            REDIRECT_TO = "/dev/null"

        REDIRECT_TO = "/dev/stdout"

        try:
            print "forking once..."
            pid = os.fork()
        except OSError, e:
            raise Exception, "%s [%d]" % (e.strerror,e.errno)

        if pid == 0:
            os.setsid()
            try:
                print "forking twice..."
                pid = os.fork()
            except OSError, e:
                raise Exception, "%s [%d]" % (e.strerror,e.errno)

            if pid==0:
                os.chdir(self.wkdir)
                os.umask(UMASK)
            else:
                print "exiting once - pid=%d" % pid
                os._exit(0)
        else:
            print "exiting twice - pid=%d" % pid
            os._exit(0)

        print "sorting out file descriptors"
        for fd in range(MAXFD):
            try:
                os.close(fd)
            except OSError:
                pass
        print "redirecting to %s" % REDIRECT_TO
        os.open(REDIRECT_TO,os.O_RDWR)
        os.dup2(0,1)
        os.dup2(0,2)

        print "returning"
        return(0)




    def queueLoop(self):
        print "queueLoop"
        while(1):

            if len(records) == 0:
                print "No Jobs Waiting"
                pass
            else:
                print "do something!!"
            time.sleep(1)

            
def daemonize():
    # See http://www.erlenstar.demon.co.uk/unix/faq_toc.html#TOC16
    if os.fork():   # launch child and...
        os._exit(0) # kill off parent
    os.setsid()
    if os.fork():   # launch child and...
        os._exit(0) # kill off parent again.
    null = os.open('/dev/null', os.O_RDWR)
    for i in range(3):
        try:
            os.dup2(null, i)
        except OSError, e:
            if e.errno != errno.EBADF:
                raise
    os.close(null)
        

if __name__ == "__main__":
    from optparse import OptionParser

    usage = "Usage %prog [options]"
    version = "SVN Revision $Rev: 7 $"
    parser = OptionParser(usage=usage,version=version)
    parser.add_option("-d", "--daemon", action="store_true",dest="daemon",
                      help="Run as a daemon")
    parser.add_option("-r", "--retry", action="store_true",dest="retry",
                      help="Run as a daemon")
    parser.add_option("-i", "--init", action="store_true",dest="init",
                      help="Initialise the database")
    parser.add_option("-f", "--file", dest="fname",
                      help="Name of xml file to be queued")
    parser.add_option("-p", "--pos", dest="position",
                      help="Return the position of specified job no in queue.")
    parser.add_option("-c", "--config", dest="cfname",
                      help="Configuration File Name")
    parser.add_option("--pid_file", dest="pidfile",
                      help="not used")
    parser.add_option("--logdir", dest="logdir",
                      help="not used")
    parser.set_defaults(
        retry=False,
        daemon=False,
        init=False,
        fname=None,
        position="-999",
        cfname=None,
        pidfile="/home/disk2/www/townguide/www/output/renderQueue.pid",
        logdir=None)
    (options,args)=parser.parse_args()
    
    print
    print "%s %s" % ("%prog",version)
    print

    if not options.logdir == None:
        print "redirecting output to %s/renderQueue.log" % options.logdir
        logf = open("%s/renderQueue.log" % options.logdir,"w")
        sys.stdout = logf
        sys.stderr = logf
        #sys.stderr = open("%s/renderQueue.err" % options.logdir,"w")
    else:
        print "Using standard input and output streams"

    print
    print options


        

    rq = renderQueue(options.daemon, options.cfname, options.retry, options.pidfile)

    if not options.daemon:
        if (options.fname != 'None'):
            rq.submitJob(options.fname)
        if (options.position != "-999"):
            rq.getQueuePosition(int(options.position))
    else:
        print "Well, the daemon should be running, exiting"
