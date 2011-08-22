//////////////////////////////////////////////////////////////////////
// Initialise the map and add event handlers
var bbox1 = new L.LatLng(0,0);
var bbox2 = new L.LatLng(0,0);

var mapDivID = "mapdiv";

// initialize the map on the "map" div with a given center and zoom
var map = new L.Map('mapdiv', {
	center: new L.LatLng(51.505, -0.09),
	zoom: 13
});

var OSMUrl = 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
OSMLayer = new L.TileLayer(OSMUrl, {
	maxZoom: 18
});

map.addLayer(OSMLayer);

//map.on('click', onMapClick);
//map.on('mousedown', onMousedown);
//map.on('dragstart', onDragStart);
//map.on('dragend', onDragEnd);

/////////////////////////////////////////////////////////////////
// Add event handlers for user interface components
// Set the text showing the height of the map.
var mapDivHeight = jQuery("#"+mapDivID).height();
var heightStr = "height: " + mapDivHeight;
jQuery("#heightDiv").text(heightStr);

jQuery("#increaseHeightButton").click(increaseMapHeight);
jQuery("#decreaseHeightButton").click(decreaseMapHeight);
jQuery("#submitButton").click(submitMap);

//////////////////////////////////////////////////////////////////////////
// Event Handler callback functions
function increaseMapHeight() {
	var mapDivHeight = jQuery("#"+mapDivID).height();
	if (mapDivHeight < 800) {
		jQuery("#"+mapDivID).height(mapDivHeight+50);
		var mapDivHeight = jQuery("#"+mapDivID).height();
		var heightStr = "height: " + mapDivHeight;
		jQuery("#heightDiv").text(heightStr);
	}
}

function decreaseMapHeight() {
	var mapDivHeight = jQuery("#"+mapDivID).height();
	if (mapDivHeight > 100) {
		jQuery("#"+mapDivID).height(mapDivHeight-50);
		var mapDivHeight = jQuery("#"+mapDivID).height();
		var heightStr = "height: " + mapDivHeight;
		jQuery("#heightDiv").text(heightStr);
	}
}

function onMapClick(e) {
	alert("You clicked the map at " + e.latlng);
}

function onMousedown(e) {
	alert("Mouse down at " + e.latlng);
}

function onDragStart(e) {
	//alert("Drag Start at " + e.latlng);
}

function onDragEnd(e) {
	//alert("Drag End at " + e.latlng);
}

/////////////////////////////////////////////////////////////////////
// Functions to populate the user interface from a JSON string
// and create a JSON string from the user interface state
//
function submitMap() {
	var mapJSON = map2JSON();
	//alert(mapJSON);
	var data = new Object;
	data.json = mapJSON;
	//data["test"] = "test";
	//alert(data.json);
	jQuery.ajax({
		url: "http://localhost/disrend/index.php/townguide/queueMap",
		type: "POST",
		data: data,
		success: mapSubmitSuccess,
		error: mapSubmitError
	});
}

function mapSubmitSuccess(data, textStatus, jqXHR) {
	alert("mapSubmitSucess() - " + data + " - " + textStatus);
}

function mapSubmitError(jqXHR,textStatus,errorThrown) {
	alert("mapSubmitError() - " + errorThrown);
}

function map2JSON() {
	mapObj = new Object();
	mapObj.title = jQuery("#titleText").val();
	mapObj.bounds = map.getBounds();
	mapObj.imgWidth = jQuery("#imgWidth").val();
	mapObj.imgHeight = jQuery("#imgHeight").val();
	mapObj.imgRes = jQuery("#imgResSelect").val();
	mapObj.styleID = jQuery("#styleSelect").val();
	mapObj.contours = jQuery("#contoursCheckbox").is(":checked");
	mapObj.grid = jQuery("#gridCheckbox").is(":checked");
	var mapJSON = JSON.stringify(mapObj);
	return mapJSON;
}