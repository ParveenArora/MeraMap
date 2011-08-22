import json
from pprint import pprint
json_data=open('meramap.json')
import varaibles

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
   
import sys
import fileinput

#for i, line in enumerate(fileinput.input('z0_generate_tiles.py', inplace = 1)):
#    sys.stdout.write(line.replace('20.212',southWest_lng))

o = open("output.py","a") #open for append
# output store in output.py file
for line in open("z0_generate_tiles.py"):
   line = line.replace("old_southWest_lng",new_southWest_lng)
   line = line.replace("old_southWest_lat",new_southWest_lat)
   line = line.replace("old_northEast_lng",new_northEast_lng)
   line = line.replace("old_northEast_lat",new_northEast_lat)
   line = line.replace("old_maxzoomlevel",new_maxzoomlevel)
   line = line.replace("old_minizoomlevel",new_minizoomlevel)
   o.write(line + "\n") 
o.close()
print "it works"
#75.724,20.212, 76.047,30.97
