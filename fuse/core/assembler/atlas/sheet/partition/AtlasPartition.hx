package fuse.core.assembler.atlas.sheet.partition;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.Core;
import fuse.core.backend.texture.CoreTexture;
import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */

class AtlasPartition implements ICoreRenderable
{
	static var objectCount:Int = 0;
	public var objectId:ObjectId = -1;
	public var active:Bool;
	public var placed:Bool;
	public var blendMode:Int = 0;
	public var shaderId:Int = 0;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var rotate:Bool;
	
	public var rightPartition:AtlasPartition;
	public var bottomPartition:AtlasPartition;
	//public var textureData:ITextureData;
	@:isVar public var textureId(get, set):Int = -1;
	@:isVar public var textureIndex(get, set):Int;
	public var coreTexture:CoreTexture;
	public var sourceTextureId(get, null):Int;
	
	public var lastFramePairPartition:AtlasPartition;
	public var lastRenderTarget:Int;
	
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
		rotate = false;
		
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
				Core.textures.deregister(coreTexture.textureData.baseData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.baseData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
		}
		return value;
	}
	
	function get_sourceTextureId():Int 
	{
		//if (AtlasUtils.alreadyPlaced(coreTexture.textureData)) {
		
		if (lastFramePairPartition == null) {
			//trace("use coreTexture.textureId: " + coreTexture.textureId);
			return coreTexture.textureId;
		}
		else {
			//trace("use atlas as source: " + lastRenderTarget + ", " + coreTexture.textureId);
			return lastRenderTarget;
		}
	}
	
	function get_textureIndex():Int 
	{
		return textureIndex;
	}
	
	function set_textureIndex(value:Int):Int 
	{
		return textureIndex = value;
	}
}