package fuse.core.backend.atlas.partition;

import fuse.core.communication.data.textureData.ITextureData;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasPartition
{
	public var active:Bool;
	
	public var atlasIndex:Int;
	public var atlasTextureId:Int;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	public var rightPartition:AtlasPartition;
	public var bottomPartition:AtlasPartition;
	public var textureData:ITextureData;
	
	public function new() { }
	
	public function init(atlasIndex:Int, atlasTextureId:Int, x:Int, y:Int, width:Int, height:Int):AtlasPartition
	{
		this.atlasIndex = atlasIndex;
		this.atlasTextureId = atlasTextureId;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
		clear();
		
		return this;
	}
	
	public function clear() 
	{
		active = false;
		rightPartition = null;
		bottomPartition = null;
		textureData = null;
	}
	
	public function toString():String
	{
		return	" x = " + x + 
				" y = " + y + 
				" width = " + width + 
				" height = " + height;
	}
}