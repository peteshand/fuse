package kea.model.buffers;
import kea2.utils.PowerOfTwo;
import kha.System;

/**
 * ...
 * @author P.J.Shand
 */
class Buffer
{
	public static inline var maxTextureSize:Int = 2048;
	static var _bufferWidth:Null<Int>;
	public static var bufferWidth(get, null):Int;
	static var _bufferHeight:Null<Int>;
	public static var bufferHeight(get, null):Int;
	
	public function new() 
	{
		
	}
	
	
	static function get_bufferWidth():Int 
	{
		if (_bufferWidth == null) {
			_bufferWidth = PowerOfTwo.getNextPowerOfTwo(System.windowWidth());
			if (_bufferWidth > Buffer.maxTextureSize) _bufferWidth = Buffer.maxTextureSize;
		}
		return _bufferWidth;
	}
	
	static function get_bufferHeight():Int 
	{
		if (_bufferHeight == null) {
			_bufferHeight = PowerOfTwo.getNextPowerOfTwo(System.windowHeight());
			if (_bufferHeight > Buffer.maxTextureSize) _bufferHeight = Buffer.maxTextureSize;
		}
		return _bufferHeight;
	}
}