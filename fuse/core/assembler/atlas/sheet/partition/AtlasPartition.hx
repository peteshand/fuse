package fuse.core.assembler.atlas.sheet.partition;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.Core;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class AtlasPartition implements ICoreRenderable
{
	static var objectCount:Int = 0;
	public var objectId:Int = -1;
	public var active:Bool;
	public var placed:Bool;
	
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	public var rightPartition:AtlasPartition;
	public var bottomPartition:AtlasPartition;
	//public var textureData:ITextureData;
	@:isVar public var textureId(get, set):Int = -1;
	public var coreTexture:CoreTexture;
	public var sourceTextureId(get, null):Int;
	
	public var textureIndex:Int;
	
	public function new() { 
		objectId = objectCount++;
	}
	
	public function init(x:Int, y:Int, width:Int, height:Int):AtlasPartition
	{
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
		placed = false;
		
		rightPartition = null;
		bottomPartition = null;
	}
	
	public function toString():String
	{
		return	"x = " + x + 
				" y = " + y + 
				" width = " + width + 
				" height = " + height;
	}
	
	inline function get_textureId():Int { return textureId; }
	
	function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
		}
		return value;
	}
	
	function get_sourceTextureId():Int 
	{
		if (coreTexture.textureData.placed == 0) {
			trace("use coreTexture.textureId");
		}
		else {
			trace("use atlas as source");
		}
		
		return coreTexture.textureId;
	}
}