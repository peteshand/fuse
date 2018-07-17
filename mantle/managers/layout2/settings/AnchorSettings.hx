package mantle.managers.layout2.settings;

#if swc
	import flash.geom.Point;
#else
	import openfl.geom.Point;
#end

/**
 * ...
 * @author P.J.Shand
 */
class AnchorSettings
{
	public var pixels:Fraction = { };
	public var fraction:Fraction = { };
	
	public function new() { }	
}

typedef Pixels = {
	?x:Float,
	?y:Float
}

typedef Fraction = {
	?x:Float,
	?y:Float
}