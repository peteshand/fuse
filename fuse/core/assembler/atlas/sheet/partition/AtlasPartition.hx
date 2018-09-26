package fuse.core.assembler.atlas.sheet.partition;

import fuse.texture.TextureId;
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
	@:isVar public var textureObjectId(get, set):ObjectId = -1;
	@:isVar public var textureIndex(get, set):Int;
	public var coreTexture:CoreTexture;
	public var sourceTextureId(get, null):TextureId;
	
	public var lastFramePairPartition:AtlasPartition;
	public var lastRenderTarget:TextureId;
	
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
	
	inline function get_textureObjectId():ObjectId { return textureObjectId; }
	
	function set_textureObjectId(value:ObjectId):ObjectId { 
		if (textureObjectId != value){
			textureObjectId = value;
			//trace("textureObjectId = " + textureObjectId);
			if (coreTexture != null && textureObjectId == -1) {
				Core.textures.deregister(coreTexture.textureData.baseData.objectId);
				coreTexture = null;
			}
			
			//trace("coreTexture = " + coreTexture);
			//trace("coreTexture.textureData.baseData.objectId = " + coreTexture.textureData.baseData.objectId);
			if (coreTexture == null || coreTexture.textureData.baseData.objectId != textureObjectId) {
				//trace("register textureId = " + textureObjectId);
				coreTexture = Core.textures.register(textureObjectId);
			}
		}
		return value;
	}
	
	function get_sourceTextureId():TextureId 
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