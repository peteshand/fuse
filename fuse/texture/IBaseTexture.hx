package fuse.texture;

import fuse.utils.Color;
import msignal.Signal.Signal0;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;

import fuse.core.communication.data.textureData.ITextureData;
import fuse.texture.BaseTexture;
import openfl.display.BitmapData;

/**
 * @author P.J.Shand
 */
interface IBaseTexture 
{
	public  var textureData:ITextureData;
	public var nativeTexture(get, null):Texture;
	public var textureBase(get, null):TextureBase;
	public var textureId:Int;
	public var width:Null<Int>;
	public var height:Null<Int>;
	public var onUpdate:Signal0;
	public var clearColour:Color;
	public  var _clear:Bool;
	public  var _alreadyClear:Bool;
	
	public  function upload():Void;
	function dispose():Void;
}