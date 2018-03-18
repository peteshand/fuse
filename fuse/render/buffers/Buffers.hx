package fuse.render.buffers;
import fuse.render.buffers.Buffer;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class Buffers
{
	public static var buffers:Map<Int, Buffer>;
	static public var lastBuffer:Buffer;
	static public var currentBuffer:Buffer;
	static var context3D:Context3D;
	static var buckets:Array<Int>;
	
	static public function init(context3D:Context3D) 
	{
		Buffers.context3D = context3D;
		
		buckets = [
			50,
			100,
			250,
			500,
			1000,
			2000,
			3000,
			4000,
			5000,
			10000
		];
		
		buffers = new Map<Int, Buffer>();
		//for (i in 0...buckets.length) getBuffer(buckets[i]);
	}
	
	public function new() { }
	
	public static function getBuffer(numItems:Int):Buffer
	{
		var bufferSize:Int = getGroupBufferSize(numItems); // numItems;// 
		
		lastBuffer = currentBuffer;
		
		currentBuffer = buffers.get(bufferSize);
		if (currentBuffer == null) {
			currentBuffer = new Buffer(context3D, bufferSize);
			buffers.set(bufferSize, currentBuffer);
		}
		
		if (currentBuffer != lastBuffer) {
			//if (lastBuffer != null) {
				//currentBuffer.deactivate();
			//}
			if (currentBuffer != null) {
				currentBuffer.activate();
			}
		}
		
		return currentBuffer;
	}
	
	public static function getGroupBufferSize(numItems:Int) 
	{
		for (i in 0...buckets.length) 
		{
			if (numItems <= buckets[i]) return buckets[i];
		}
		return numItems;
	}
	
	static public function deactivate() 
	{
		currentBuffer.deactivate();
		currentBuffer = null;
	}
}