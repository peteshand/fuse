package mantle.managers.layout2.settings;
import openfl.errors.Error;
import openfl.geom.Rectangle;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class LayoutSettings
{
	public var scale:LayoutScale = LayoutScale.NONE;
	public var scaleRounding:Float = -1;
	
	#if swc @:protected #end
	private var _hScale:String;
	#if swc @:protected #end
	private var _vScale:String;
	
	#if swc @:extern #end
	public var vScale(get, set):String;
	#if swc @:extern #end
	public var hScale(get, set):String;
	
	//////////////////////////////////////
	#if swc @:protected #end
	private var _frame:RectDef;
	#if swc @:protected #end
	private static var iDisplayObjectXML:Xml;
	#if swc @:protected #end
	private static var properties = new Array<String>();
	
	public var align:AlignSettings = new AlignSettings();
	public var anchor:AnchorSettings = new AnchorSettings();
	
	#if swc @:extern #end
	public var frame(get, set):RectDef;
	public var updateBounds:Bool = true;
	public var bounds:RectDef;
	public var nest:Bool = false;
	
	//////////////////////////
	
	public function new(scale:LayoutScale=null) 
	{
		if (scale != null) {
			this.scale = scale;
		}
		
		if (iDisplayObjectXML == null) {
			properties.push("x");
			properties.push("y");
			properties.push("width");
			properties.push("height");
		}
	}		
	
	#if swc @:getter(vScale) #end
	private function get_vScale():String 
	{
		if (_vScale == null) return scale;
		return _vScale;
	}
	
	#if swc @:setter(vScale) #end
	private function set_vScale(value:String):String 
	{
		_vScale = value;
		return value;
	}
	
	#if swc @:getter(hScale) #end
	private function get_hScale():String 
	{
		if (_hScale == null) return scale;
		return _hScale;
	}
	
	#if swc @:setter(hScale) #end
	private function set_hScale(value:String):String 
	{
		_hScale = value;
		return value;
	}
	/////////////////////////////////////////////
	
	#if swc @:getter(frame) #end
	private function get_frame():RectDef 
	{
		return _frame;
	}
	
	#if swc @:setter(frame) #end
	private function set_frame(value:RectDef):RectDef 
	{
		_frame = value;
		return value;
	}
}

typedef RectDef = {
	x:Float,
	y:Float,
	width:Float,
	height:Float
}