#!/usr/bin/env python

#script to convert sparc data to gpx
#copyright Kenneth Gonsalves
#license - BSD
#note: OSM requires trackpoint gpx files and waypoint gpx files to be separate
#TODO: make this crap look like python code
#current usage: sparc2gpx -t|-w infile.txt outfile.gpx
#-t is for trackpoints
#-w is for waypoints

import datetime
import sys
import os

def latconf(parms):
    """a crappy way of converting latitude"""
    latt=str(parms[2])
    degrees = latt[0:2]
    minutes = latt[2:]
    mins = float(minutes)
    mins = round(mins/60,6)
    degs = float(degrees)
    latitude = str(degs+mins)
    if parms[3] == 'S':
        latitude = '-'+latitude
    return latitude
    
def lonconf(parms):
    """an equally crappy way of converting longitude"""
    latt=str(parms[4])
    degrees = latt[0:3]
    minutes = latt[3:]
    mins = float(minutes)
    mins = round(mins/60,6)
    degs = float(degrees)
    longitude = str(degs+mins)
    if parms[5] == 'W':
        longitude = '-'+longitude
    return longitude

def dateconf(parms):
    """inelegant conversion of dates"""
    dt = parms[1].split('.')[0]
    tstr = 'T'+dt[0:2]+':'+dt[2:4]+':'+dt[4:6]+'Z'
    dte = str(parms[6])
    return '20'+dte[4:6]+'-'+dte[2:4]+'-'+dte[0:2]+tstr

def checkparms(parms):
    """checks all the input parameters"""
    b0rked = 0
    if len(parms) != 4:
        sys.exit('sparc2gpx takes precisely 4 parameters, you have given %s parameters'
            % len(parms))
    infile = parms[2]
    outfile = parms[3]
    #check if infile exists
    try:
        ifile = open(infile,'r')
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
    if parms[1] != '-t' and parms[1] != '-w':
        sys.exit('unknown argument %s' % sys.argv[1])
    option = sys.argv[1][1:]
    #check if we are over writing the outfile
    try:   
        ofile = open(outfile,'r')
        b0rked = 1
    except:
        pass
    if b0rked:
            sys.exit('file %s exists - choose another file name for output' % outfile)
    ofile = open(outfile,'w')
    return option,ifile,ofile

#process trackpoints
def processtrackpoints(ifile,ofile):
    ofile.write("""<?xml version="1.0"?>\n""")
    ofile.write('<gpx>\n')
    ofile.write("<time>%s</time>\n" %datetime.datetime.now())
    track = False
    for line in ifile.readlines():
        # a new track
        if line[0] == 'T':
            if track:
                ofile.write('</trkseg>\n</trk>\n')
            ofile.write("<trk><name>%s</name>\n" % line[2:].strip())
            ofile.write("<trkseg>\n")
            track = True
        ln = line.split(',')
        if len(ln) == 9:
            ofile.write("""<trkpt lat="%s" lon="%s">\n""" %(latconf(ln),
            lonconf(ln)))
            ofile.write("<ele>%s</ele>\n" % ln[7])
            ofile.write("<time>%s</time>\n" % dateconf(ln))
            ofile.write("</trkpt>\n")
    ofile.write("</trkseg>\n")
    ofile.write("</trk>\n")
    ofile.write("</gpx>\n")
    ofile.close()
    ifile.close()
    
    #process waypoints - we also need to calculate max/min lat/long
def processwaypoints(ifile,ofile):
    """creates a tempfile as the bounding box needs to be inserted
        should we do this in memory?"""
    tofile = open('./tempfile','w')
    maxlat = 0.00
    minlat = 0.00
    maxlong = 0.00
    minlong = 0.00
    for line in ifile.readlines():
        if line[0] == 'W':
            lnl = line.split(',')
            ln = lnl[1:]
            lat = latconf(ln)
            lon = lonconf(ln)
            tofile.write("""<wpt lat="%s" lon="%s">\n""" %(lat,lon))
            lat = float(lat)
            lon = float(lon)
            if maxlat == 0.00 or (maxlat != 0.00 and maxlat < lat):
                maxlat = lat
            if minlat == 0.00 or (minlat != 0.00 and minlat > lat):
                minlat = lat
            if maxlong == 0.00 or (maxlong != 0.00 and maxlong < lon):
                maxlong = lon
            if minlong == 0.00 or (minlong != 0.00 and minlong > lon):
                minlong = lon
            
            tofile.write("<ele>%s</ele>\n" % ln[7])
            tofile.write("<name>%s</name>\n" % lnl[0][1:])
            tofile.write("<cmt>%s</cmt>\n" % dateconf(ln))
            tofile.write("<desc>%s</desc>\n" % dateconf(ln))
            tofile.write("<sym>Waypoint</sym>\n")
            tofile.write("</wpt>\n")
    tofile.write("</gpx>\n")
    tofile.close()
    ifile.close()
    #add the bounding box
    ofile.write("""<?xml version="1.0"?>\n""")
    ofile.write('<gpx>\n')
    ofile.write("<time>%s</time>\n" %datetime.datetime.now())
    ofile.write("""<bounds minlat="%s" minlon="%s" maxlat="%s" maxlon="%s"/>\n"""\
                %(minlat,minlong,maxlat,maxlong))
    tofile = open('./tempfile','r')
    for line in tofile.readlines():
        ofile.write(line)
    ofile.close()
    tofile.close()
    os.unlink('./tempfile')
    
if __name__=='__main__':
    option,ifile,ofile = checkparms(sys.argv)
    if option == 't':
        processtrackpoints(ifile,ofile)
    else:
        processwaypoints(ifile,ofile)