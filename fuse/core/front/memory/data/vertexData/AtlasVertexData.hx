package fuse.core.front.memory.data.vertexData;
import fuse.Fuse;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasVertexData extends VertexData
{
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	static var poolStartPosition:Int;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public function new() 
	{
		super();
		poolStartPosition = Fuse.current.keaMemory.atlasVertexDataPool.start;
	}
	
	override function readFloat(offset:Int):Float
	{
		return Memory.getFloat(AtlasVertexData.basePosition + offset);
	}
	
	override function writeFloat(offset:Int, value:Float):Void
	{
		Memory.setFloat(AtlasVertexData.basePosition + offset, value);
	}
	
	static inline function get_OBJECT_POSITION():Int 
	{
		return AtlasVertexData.OBJECT_POSITION;
	}
	
	static inline function set_OBJECT_POSITION(value:Int):Int 
	{
		AtlasVertexData.OBJECT_POSITION = value;
		
		AtlasVertexData._basePosition = poolStartPosition + (VertexData.OBJECT_POSITION * VertexData.BYTES_PER_ITEM);
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}