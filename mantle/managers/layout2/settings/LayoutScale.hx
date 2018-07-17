package mantle.managers.layout2.settings;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract LayoutScale(String) to String
{
	var NONE = "none";
	
	var MINIMUM = "minimum";
	var MAXIMUM = "maximum";
	var HORIZONTAL = "horizontal";
	var VERTICAL = "vertical";
	
	var STRETCH = "stretch";
	var LETTERBOX = "letterbox";
	var CROP = "crop";
}