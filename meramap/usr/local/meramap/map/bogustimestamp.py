#!/usr/bin/env python

#add bogus datestamp to gpx file created by qlandkarte without time info
#copyright Kenneth Gonsalves
#license - BSD
#usage - ./bogustimestamp.py infile outfile.gpx


import datetime
import sys
import os
import re

def convertdate(id):
	"""converts to the gpx date format"""
	#gpx format is 2008-12-06T11:53:34Z
	outdate = str(id.year)+'-'+str(id.month)+'-'+str(id.day)
	outdate = outdate+'T'+str(id.hour)+':'+str(id.minute)+':'+str(id.second)+'Z'
	outdate = '    <time>'+outdate+'</time>'
	return outdate
	
def checkparms(parms):
    """checks all the input parameters"""
    b0rked = 0
    if len(parms) != 3:
        sys.exit('bogustimestamp takes precisely 3 parameters, you have given %s parameters'
            % len(parms))
    infile = parms[1]
    outfile = parms[2]
    #check if infile exists
    try:
		ifile = open(infile,'r')
		ifile.close()
    except:
        sys.exit('cannot open %s' % infile)
        2342
    
    #check if outfile has gpx extension
    tfile = outfile.split('.')
    if len(tfile) < 2:
        sys.exit('output file needs an extension')
    else:
        if outfile.split('.')[1] != 'gpx':
            sys.exit('output file should have a .gpx extension')
    #check if options are either -w or -t
    
    #check if we are over writing the outfile
    try:   
        ofile = open(outfile,'r')
        b0rked = 1
    except:
        pass
    if b0rked:
            sys.exit('file %s exists - choose another file name for output' % outfile)
    return infile,outfile
	
def addbogustime(ifile,ofile):
	"""takes the infile, adds the timestamp and writes"""
	x = datetime.timedelta(days=2) #two days in the past
	addsec = datetime.timedelta(seconds=2)
	addhour = datetime.timedelta(hours=1)
	instime = datetime.datetime.now() - x # a bogus start time
	infile = open(ifile,'r')
	outfile = open(ofile,'w')
	tstamp = re.compile(r'<time>')
	ele = re.compile(r'ele')
	seg = re.compile(r'<trkseg>')
	for line in infile.readlines():
		#put an hours gap after each tracksegment
		if seg.search(line): 
			instime = instime + addhour
		if ele.search(line):
			outfile.write(line)
			outfile.write(convertdate(instime))
			outfile.write('\n')
			instime = instime + addsec
		elif tstamp.search(line):
			pass #if there are real timestamps zap them
		else:
			outfile.write(line)
	infile.close()
	outfile.close()
		
	
	
	
if __name__=='__main__':
	ifile,ofile = checkparms(sys.argv)
	addbogustime(ifile,ofile)
