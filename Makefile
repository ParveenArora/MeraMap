all: meramap-api.deb meramap.deb

meramap.deb:
	dpkg --build meramap_final/meramap

meramap-api.deb:
	dpkg --build meramap-api

