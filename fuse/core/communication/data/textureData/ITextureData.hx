package fuse.core.communication.data.textureData;

import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;

/**
 * @author P.J.Shand
 */
typedef ITextureData = {
	// Backend Props
	// public var objectId:ObjectId;
	// public var textureId:TextureId;
	// public var rotate:Bool;
	public var activeData:TextureSizeData; // points to the active TextureSizeData
	public var baseData:TextureSizeData; // stores data about the source texture
	public var atlasData:TextureSizeData; // stores data about the dynamic texture atlas
	public var textureId:TextureId;
	public var x:Int; // x position in pixels on underlying texture
	public var y:Int; // y position in pixels on underlying texture
	public var width:Int; // width in pixels on underlying texture
	public var height:Int; // height in pixels on underlying texture
	public var p2Width:Int; // next power of 2 of width
	public var p2Height:Int; // next power of 2 of height
	public var offsetU:Float;
	public var offsetV:Float;
	public var scaleU:Float;
	public var scaleV:Float;
	public var placed:Int; //
	public var persistent:Int; //
	public var directRender:Int; //
	// public var atlasTextureId:Int;		//
	// public var textureAvailable:Int;	//
	// public var changeCount:Int;			//
	public var area(get, null):Float; //
	// Shared Props
	public var nativeTexture:Texture;
	public var textureBase:TextureBase;
	public function dispose():Void;
}
