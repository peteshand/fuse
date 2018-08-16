package fuse.core.communication.data.textureData;

import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import fuse.texture.TextureId;
import fuse.utils.ObjectId;
/**
 * ...
 * @author P.J.Shand
 */

@:keep
class TextureData
{
	// Backend Props
	//public var objectId:ObjectId;
	//public var textureId:TextureId;

	public var activeData:TextureSizeData; // points to the active TextureSizeData
	public var baseData:TextureSizeData; // stores data about the source texture
	public var atlasData:TextureSizeData; // stores data about the dynamic texture atlas

	public var x:Int = 0;
	public var y:Int = 0;
	public var width:Int = 1;
	public var height:Int = 1;
	public var p2Width:Int = 1;
	public var p2Height:Int = 1;

	public var offsetU:Float = 0;
	public var offsetV:Float = 0;
	public var scaleU:Float = 1;
	public var scaleV:Float = 1;

	public var textureAvailable:Int;
	public var placed:Int;
	public var persistent:Int;
	public var directRender:Int;
	//public var atlasTextureId:Int;
	//public var atlasBatchTextureIndex:Int;
	public var changeCount:Int = 0;
	public var area(get, null):Float;
	
	// Shared Props
	public var nativeTexture:Texture;
	public var textureBase:TextureBase;
	
	public function new(objectOffset:Int) 
	{
		//baseData = { textureId:0, x:0, y:0, width:1, height:1, p2Width:1, p2Height:1, offsetU:0.1, offsetV:0.1, scaleU:0.8, scaleV:0.8 };
		baseData = { textureId:0, x:0, y:0, width:1, height:1, p2Width:1, p2Height:1, offsetU:0, offsetV:0, scaleU:1, scaleV:1 };
		atlasData = { textureId:0, x:0, y:0, width:1, height:1, p2Width:1, p2Height:1, offsetU:0, offsetV:0, scaleU:1, scaleV:1 };

		activeData = baseData;
		baseData.textureId = objectOffset;
		atlasData.textureId = objectOffset;
		textureAvailable = 0;
		//objectId = objectOffset;
		//atlasTextureId = objectId;
		
	}
	
	public function toString():String
	{
		return "objectId = " + baseData.textureId + ", atlasIndex = " + atlasData.textureId + " - (" + activeData.x + ", " + activeData.y + ", " + activeData.width + ", " + activeData.height + ")";
	}
	
	function get_area():Float 
	{
		return activeData.width * activeData.height;
	}
	
	public function dispose():Void
	{
		if (textureBase != null) {
			textureBase.dispose();
			textureBase = null;
		}
	}
}