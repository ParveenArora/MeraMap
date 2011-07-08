#!/usr/bin/python

import struct
import sys
import math
import os
import socket
import time
import cgi

#Simpel minmax function for 3 vars
def minmax (a,b,c):
  a = max(a,b)
  a = min(a,c)
  return a


#Basic vars
METATILE = 8
PATH = "/var/tiles/metatiles/"
TILEDIR = "/var/lib/mod_tile"
SOCKET = "/var/run/renderd/renderd.sock"
xml = "/home/lawgon/install/mapnik/india.xml"
rlist = dict()

#Try to split the url.
#If this fails redirect to 404
try:
  qstr = os.environ["REDIRECT_URL"]
  qstr = qstr.split("/")

  X = int(qstr[3])
  Y = int(qstr[4].split(".")[0])
  Z = int(qstr[2])
except:
  url = "http://tile.openstreetmap.nl/404.png"
  print 'Status: 302 Moved Temporarily'
  print 'Location:', url
  print 'Pragma: no-cache'
  print 'Content-Type: text/html'
  print
        
  print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML//EN">'
  print '<title>Redirect (302)</title>'
  print '<h1>302 Moved Temporarily</h1>'
  print '<p>The answer to your request is located at'
  hurl = cgi.escape(url, 1)
  print '<a href="%s">%s</a>.' % (hurl, hurl)
  exit()

cur_png = ""


#All entries in offset
class entry:
  def __init__(self, offset, size):
    self.offset = offset
    self.size = size

def xyz_to_meta(xml, x, y, z):
  mask = METATILE -1
  x &= ~mask
  y &= ~mask
  hashes = {}
  for i in range(0,5):
    hashes[i] = ((x & 0x0f) << 4) | (y & 0x0f)
    x >>= 4
    y >>= 4
  meta = "%s/%s/%d/%u/%u/%u/%u/%u.meta" % (PATH, xml, z, hashes[4], hashes[3], hashes[2], hashes[1], hashes[0])
  return meta

def xyz_to_meta_offset(x, y, z):
  mask = METATILE -1
  offset = (x & mask) * METATILE + (y & mask)
  return offset

#render the meta tile and unpack it
def render(xi, yi, zi, xml, s):
  global cur_png
  msg = struct.pack("5i41sxxx", 2, 1, xi, yi, zi, xml)
  s.send(msg)

  data = s.recv(1024)
  version, status, x, y, z, xml = struct.unpack("5i41sxxx", data)

  version = int(version)
  status = int(status)
  x = int(x)
  y = int(y)
  z = int(z)
  xml = xml.rstrip('\000')

  #Where will the tile be writen
  mtile = xyz_to_meta(xml,x,y,z)

  #Open the tile
  f = open(mtile)

  #Basic offset
  offset = 0
  meta = f.read(4)
  offset = offset + 4

  #Total size, min x and y and the zoom
  size, minx, miny, curz = struct.unpack("4i", f.read(16))
  offset = offset + 16

  size1d = int(math.sqrt(size))

  entries = list()

  #Get all the entries
  for i in range(0,size):
    toffset, tsize = struct.unpack("2i", f.read(8))
    e = entry(toffset, tsize)
    entries.append(e)

  #create stylesheet dir
  spath = TILEDIR + "/" + xml
  if not os.path.isdir(spath):
    os.mkdir(spath)
  
  #create zoom dir
  zpath = spath + "/" + str(curz)
  if not os.path.isdir(zpath):
    os.mkdir(zpath)

  for x in range(0, size1d):
    myx = minx+x
    xpath = zpath + "/" + str(myx)
    if not os.path.isdir(xpath):
      os.mkdir(xpath)

    for y in range(0, size1d):
      e = entries[x * METATILE + y]
      f.seek(e.offset)
      tile = f.read(e.size)
      
      myy = miny+y

      if (myx == xi and myy == yi):
        cur_png = tile

      png = open(xpath + "/" + str(myy) + ".png", 'w')
      png.write(tile)
      png.close()

  f.close()

  return

def render_tiles(minx, maxx, miny, maxy, z, xml):
  print z, minx, maxx, miny, maxy
  for x in range(minx, maxx+1):
    for y in range(miny,maxy+1):
      meta = xyz_to_meta(xml, x, y, z)
      rlist[meta] = [x,y,z]
      
  return

s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(SOCKET)

try:
  render(X, Y, Z, xml, s)
except:
  url = "http://tile.openstreetmap.nl/404.png"
  print 'Status: 302 Moved Temporarily'
  print 'Location:', url
  print 'Pragma: no-cache'
  print 'Content-Type: text/html'
  print

  print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML//EN">'
  print '<title>Redirect (302)</title>'
  print '<h1>302 Moved Temporarily</h1>'
  print '<p>The answer to your request is located at'
  hurl = cgi.escape(url, 1)
  print '<a href="%s">%s</a>.' % (hurl, hurl)
  exit()

s.close()

try:
  if cur_png != "":
    print "Content-type: image/png\n"
    print cur_png
except:
  exit()

exit()
