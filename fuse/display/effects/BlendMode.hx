package fuse.display.effects;

import openfl.display3D.Context3DBlendFactor;

/**
 * ...
 * @author P.J.Shand
 */
class BlendMode
{
	static var factors:Map<Int, BlendFactors>;
	
	static function __init__():Void
	{
		factors = new Map<Int, BlendFactors>();
		factors.set(0, { sourceFactor:Context3DBlendFactor.ONE, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA } );
	}
	
	public function new() 
	{
		
	}
	
	static public function getBlendFactors(key:Int):BlendFactors
	{
		return factors.get(key);
	}
	
}

typedef BlendFactors =
{
	sourceFactor:Context3DBlendFactor, 
	destinationFactor:Context3DBlendFactor
}