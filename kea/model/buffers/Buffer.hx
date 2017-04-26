package kea.model.buffers;
import kea.util.PowerOfTwo;
import kha.System;

/**
 * ...
 * @author P.J.Shand
 */
class Buffer
{
	public static inline var maxTextureSize:Int = 4096;
	public static var bufferWidth(get, null):Int;
	public static var bufferHeight(get, null):Int;
	
	public function new() 
	{
		
	}
	
	
	static function get_bufferWidth():Int 
	{
		var w:Int = PowerOfTwo.getNextPowerOfTwo(System.windowWidth());
		if (w > Buffer.maxTextureSize) w = Buffer.maxTextureSize;
		return w;
	}
	
	static function get_bufferHeight():Int 
	{
		var h:Int = PowerOfTwo.getNextPowerOfTwo(System.windowHeight());
		if (h > Buffer.maxTextureSize) h = Buffer.maxTextureSize;
		return h;
	}
}