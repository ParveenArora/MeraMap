#!/usr/bin/python
import json
from pprint import pprint
import urllib2
import os, sys
from varaibles import *
json_data=open('/usr/local/meramap/customise_map/config/meramap.json')

data = json.load(json_data)
#pprint(data)
json_data.close()
#print data["maps"][0]["id"]
new_southWest_lat= str(data["bounds"]["_southWest"]["lat"])
new_southWest_lng= str(data["bounds"]["_southWest"]["lng"])
new_northEast_lat= str(data["bounds"]["_northEast"]["lat"])
new_northEast_lng= str(data["bounds"]["_northEast"]["lng"])
new_minizoomlevel= str(data["MiniZoomLevel"])
new_maxzoomlevel= str(data["MaxZoomLevel"])
print new_southWest_lat
print new_southWest_lng
print new_northEast_lat
print new_northEast_lng
print new_minizoomlevel
print new_maxzoomlevel

areafile = file("area.txt",'w')
print >> areafile, new_southWest_lng,",",new_southWest_lat,",",new_northEast_lng,",",new_northEast_lat
areafile.close()

   
import sys
import fileinput

#for i, line in enumerate(fileinput.input('z0_generate_tiles.py', inplace = 1)):
#    sys.stdout.write(line.replace('20.212',southWest_lng))

o = open("scripts/output.py","a") #open for append
# output store in output.py file
for line in open("scripts/z0_generate_tiles.py"):
#for line in open("z0_generate_tiles.py"):
   line = line.replace("old_southWest_lat",new_southWest_lng)
   line = line.replace("old_southWest_lng",new_southWest_lat)
   line = line.replace("old_northEast_lat",new_northEast_lng)
   line = line.replace("old_northEast_lng",new_northEast_lat)
   line = line.replace("old_maxzoomlevel",new_maxzoomlevel)
   line = line.replace("old_minizoomlevel",new_minizoomlevel)
   o.write(line + "\n") 
o.close()
print "it works"



#Download Data 

#functions - from http://old.nabble.com/Download-file-via-HTTP-GET-with-progress-monitoring---custom-headers--td18917651.html

def reportDownloadProgress(blocknum, bs, size):
    percent = int(blocknum*bs*100/size)
    print str(blocknum*bs ) + '/' + str(size) + 'downloaded| ' + str(percent) + '%'
   
def httpDownload(url, filename, headers=None, reporthook=None, postData=None):
    reqObj = urllib2.Request(url, postData, headers)
    fp = urllib2.urlopen(reqObj)
    headers = fp.info()
    ##    This function returns a file-like object with two additional methods:
    ##
    ##    * geturl() -- return the URL of the resource retrieved
    ##    * info() -- return the meta-information of the page, as a dictionary-like object
    ##
    ##Raises URLError on errors.
    ##
    ##Note that None may be returned if no handler handles the request (though the default installed global OpenerDirector uses UnknownHandler to ensure this never happens).

    #read & write fileObj to filename
    tfp = open(filename, 'wb')
    result = filename, headers
    bs = 1024*8
    size = -1
    read = 0
    blocknum = 0
   
    if reporthook:
        if "content-length" in headers:
            size = int(headers["Content-Length"])
        reporthook(blocknum, bs, size)
       
    while 1:
        block = fp.read(bs)
        if block == "":
            break
        read += len(block)
        tfp.write(block)
        blocknum += 1
        if reporthook:
            reporthook(blocknum, bs, size)
           
    fp.close()
    tfp.close()
    del fp
    del tfp

    # raise exception if actual size does not match content-length header
    if size >= 0 and read < size:
        raise ContentTooShortError("retrieval incomplete: got only %i out "
                                    "of %i bytes" % (read, size), result)

    return result

#test it

def downloadOsmData(ll):
    '''
    Downloads OSM Data from the jxapi server and imports it into postgresql.
    '''
    # XAPI Server
    print 'Using OSM JXAPI Server for data download'
    url="http://jxapi.openstreetmap.org/xapi/api/0.6/map?bbox=%f,%f,%f,%f" %\
        (ll)
    headers = {
        'User-Agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)',
        'Accept' :
            'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
        'Accept-Language' : 'fr-fr,en-us;q=0.7,en;q=0.3',
        'Accept-Charset' : 'ISO-8859-1,utf-8;q=0.7,*;q=0.7'
        }


    osmFile = "tmp.osm" 

    httpDownload(url, osmFile, headers, reportDownloadProgress)

    #f = urllib.urlopen(url)
    #print f.read()

        #os.system("wget %s -O %s" % (url,osmFile))

   # if os.path.exists(osmFile):
    #    try:
     #       print 'Importing data into postgresql database....'
      #         (self.preferences_list['tmp.osm'],"default.style",
       #          self.preferences_list['meramap_dba'],
        #         osmFile)
         #   print "Calling osm2pgsql with: %s" % osm2pgsqlStr
          #  retval = os.system(osm2pgsqlStr)
           # if (retval==0):
            #    print 'Data import complete.'
            #else:
             #   print 'osm2pgsql returned %d - exiting' % retval
                # system.exit(-1)
       # except:
        #    print "Exception Occurred running osm2pgsql"
         #   system.exit(-1)
    #else:
     #   print "ERROR:  Failed to download OSM data"
      #  print "Aborting...."
       # system.exit(-1)
new_southWest_lat = float(new_southWest_lat)
new_southWest_lng = float(new_southWest_lng)
new_northEast_lat  = float(new_northEast_lat)
new_northEast_lng = float(new_northEast_lng)


if __name__ == "__main__":
    ll = (new_southWest_lng,new_southWest_lat,new_northEast_lng,new_northEast_lat)
    downloadOsmData(ll)


