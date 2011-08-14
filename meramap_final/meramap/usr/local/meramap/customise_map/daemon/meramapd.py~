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
import psycopg2 as psycopg
import os,sys
from datetime import datetime
import time
from prefs import prefs
import townguide
#import townguide2 as townguide

WDIR = '/home/disk2/www/townguide'


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
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                         'user=%s' % self.uname)
        mark = connection.cursor()

        sqlstr = "select * from queue where status=%d order by jobno;" \
            % self.NOT_STARTED
        
        while(1):
            mark.execute(sqlstr)
            records = mark.fetchall()
            if len(records) == 0:
                #print "No Jobs Waiting"
                pass
            else:
                jobNo = records[0][0]
                print "next job is %d." % jobNo
                self.renderJob(jobNo)
            self.setRunningJobsFailed()
            time.sleep(1)

            
    def renderJob(self,jobNo):
        """Execute the specified job number using the townguide renderer.
        """
        print "renderJob(%d)" % jobNo
        self.setJobStatus(jobNo,self.RUNNING)
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                         'user=%s' % self.uname)
        mark = connection.cursor()

        sqlstr = "select jobno, renderer,xml from queue where jobno=%d;" \
            % jobNo
        
        mark.execute(sqlstr)
        recordArr = mark.fetchone()
        renderer = recordArr[1]
        print "Renderer=%d" % renderer
        xmlStr = recordArr[2]
        print "xmlStr = %s" % xmlStr

        jobDir = "%s/%d" % (self.wkdir,jobNo)
        if not os.path.exists(jobDir):
            try:
                os.makedirs(jobDir)
            except:
                print "***********************************************"
                print "odd - got an error making the output directory"
                print "trying to carry on regardless!!!"
                print "***********************************************"

        xmlFile = "%s/townguide.xml" % (jobDir)
        try:
            op = open(xmlFile,"w")
            op.write(xmlStr)
            op.close()
            pr = prefs()
            pr.loadPrefs(xmlFile)
            pl = pr.getPrefs()

            pl['datadir'] = self.datadir
            pl['outdir'] = jobDir
            pl['mapfile'] = self.mapFileName
            
            print "mapFileName=%s." % self.mapFileName

            #            try:
            #jobLog = open("%s/townguide.log" % (jobDir))
            #queueLog = sys.stdout

            #sys.stdout = jobLog
            #sys.stderr = jobLog

            #if renderer==1:
            #    tg = townguide.townguide(pr)
            #else:
            #    tg = townguide2.townguide(pr)
            tg = townguide.townguide(pr)
            self.setJobStatus(jobNo,self.COMPLETE)
            sys.stdout.flush()
            #sys.stdout = queueLog
            #sys.stderr = queueLog
            #except:
            #    print "Oh No - error opening log file, or townguide failed"
            #    self.setJobStatus(jobNo,self.ERROR)
        except Exception, e:
            print "Oh No - Error processing job number %d" % jobNo
            print "Unexpected error:", sys.exc_info()[0]
            print "%s" % (dir(e))
            print sys.exc_info()
            self.setJobStatus(jobNo,self.ERROR)
            #raise
        #time.sleep(5)
        
    
    def setJobStatus(self,jobNo,status):
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                         'user=%s' % self.uname)
        mark = connection.cursor()
        sqlstr = "update queue set status=%d where jobno=%d;" \
            % (status,jobNo)
        mark.execute(sqlstr)
        connection.commit()
   
    def setRunningJobsFailed(self):
        """change the status of all jobs showing "running" status
        to "failed" status - this is run as part of the rendering queue
        to make sure that any jobs that crashed the render daemon are changed
        to "failed" status
        """
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                         'user=%s' % self.uname)
        mark = connection.cursor()
        sqlstr = "update queue set status=3 where status=1;"
        mark.execute(sqlstr)
        connection.commit()

    def setRetryFailedJobs(self):
        """change the status of all jobs showing "failed" status
        to "not started" status 
        """
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                         'user=%s' % self.uname)
        mark = connection.cursor()
        sqlstr = "update queue set status=0 where status=3;"
        mark.execute(sqlstr)
        connection.commit()



    def getQueuePosition(self,jobNo):
        """Returns the position in the queue of job number JobNo.
        Returns 0 if the job is complete, or -1 if it failed,
        or -999 if it does not exist.
        """
        status = self.getJobStatus(jobNo)
        print "status=%d (%s)" % (status,self.statusList[status])
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                     'user=%s' % self.uname)
        mark = connection.cursor()
        sqlstr = "select count(jobNo) from queue where "\
            "queue.jobno<%d and status=%d;" \
            % (jobNo, self.NOT_STARTED)
        mark.execute(sqlstr)
        records = mark.fetchall()
        print "getQueuePosition(jobno=%d) = %d" % (jobNo,records[0][0])
        return(records[0][0])

    def getJobStatus(self,jobNo):
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                     'user=%s' % self.uname)
        mark = connection.cursor()
        sqlstr = "select status from queue where jobno=%d" % jobNo
        mark.execute(sqlstr)
        result = mark.fetchall()
        if result==None or len(result)==0:
            status=-999
        else:
            status=result[0][0]
        return status

    def submitJob(self,xmlFile):
        """ Submits the job specified by file xmlFile to the queue
        and returns the job number.
        """
        print "submitJob"
        connection = psycopg.connect('dbname=%s' % self.dbname,\
                                     'user=%s' % self.uname)
        mark = connection.cursor()

        sqlstr = "select max(jobNo) from queue;"
        mark.execute(sqlstr)
        records = mark.fetchall()
        lastJobNo = records[0][0]
        if lastJobNo == None:
            lastJobNo = 0
        jobNo = lastJobNo + 1

        # Read the XML file contents to extract the title etc.
        pr = prefs()
        pr.loadPrefs(xmlFile)
        pl = pr.getPrefs()
        origin = pl['origin']
        (latStr,lonStr) = origin.split(",")
        originLat = float(latStr)
        originLon = float(lonStr)
        title = pl['title']
        now = datetime.now()

        # Read the XML file into a string to store it in the database
        if(not os.path.exists(xmlFile)):
            print "Error - File %s does not exist." % xmlFile
            return
        ip = open(xmlFile,"r")
        lines=ip.readlines()
        xmlStr=''
        for line in lines:
            xmlStr = "%s%s" % (xmlStr,line)
        ip.close

        # Now substitute 'dangerous' characters that will mess up postgreSQL
        substitutions = {
            "'":"\\'",
            "\\":"\\"}
        xmlStrSafe = ""
        for n in range(len(xmlStr)):
            ch = xmlStr[n]
            subs = substitutions.get(ch)
            #print "ch=%s, subs=%s" % (ch,subs)
            if subs == None:
                subs = ch
            xmlStrSafe = "%s%s" % (xmlStrSafe,subs)

        # And finally add a new record to the database to be picked up
        # by the queue daemon.
        sqlstr = "insert into queue (status, title, originlat, originlon,"\
            "subdate, statusdate, xml) values "\
            "( %d, '%s', %f, %f, timestamp'%s', timestamp'%s', '%s');" \
            % ( 
               self.NOT_STARTED,
               title,
               originLat,
               originLon,
               now, 
               now, 
               xmlStrSafe)
        mark.execute(sqlstr)
        connection.commit()

        # Print out the entire queue - this will have to go eventually
        #sqlstr = "select * from queue;"
        #mark.execute(sqlstr)
        #records = mark.fetchall()
        #print len(records)
        #for rec in records:
        #    print rec
        

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
