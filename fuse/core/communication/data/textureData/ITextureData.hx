package fuse.core.communication.data.textureData;

import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;

/**
 * @author P.J.Shand
 */
typedef ITextureData =
{
	// Backend Props
	public var textureId:Int;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var p2Width:Int;
	public var p2Height:Int;
	public var baseX:Int;
	public var baseY:Int;
	public var baseWidth:Int;
	public var baseHeight:Int;
	public var baseP2Width:Int;
	public var baseP2Height:Int;
	public var textureAvailable:Int;
	public var placed:Int;
	public var persistent:Int;
	public var directRender:Int;
	public var atlasTextureId:Int;
	//public var atlasBatchTextureIndex:Int;
	public var changeCount:Int;	
	public var area:Float;
	
	// Shared Props
	public var nativeTexture:Texture;
	public var textureBase:TextureBase;
	
	public function dispose():Void;
}