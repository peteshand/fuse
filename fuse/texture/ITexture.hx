package fuse.texture;

import fuse.display.Image;
import fuse.utils.Color;
import msignal.Signal.Signal0;
import fuse.core.communication.data.textureData.ITextureData;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import fuse.texture.TextureId;
import fuse.utils.ObjectId;


/**
 * @author P.J.Shand
 */
interface ITexture 
{
	var objectId(get, null):ObjectId;
	var textureId(get, null):TextureId;
	
	var onUpdate:Signal0;
	var onUpload:Signal0;
    var width(get, set):Null<Int>;
	var height(get, set):Null<Int>;
    var offsetU(get, set):Float;
	var offsetV(get, set):Float;
	var scaleU(get, set):Float;
	var scaleV(get, set):Float;
	var directRender(get, set):Bool;


    var textureData(get, set):ITextureData;
	var nativeTexture(get, null):Texture;
	var textureBase(get, null):TextureBase;
	
	var clearColour(get, set):Color;
	var _clear(get, set):Bool;
	var _alreadyClear(get, set):Bool;
	
	function upload():Void;
	function dispose():Void;

	function addChangeListener(image:Image):Void;
	function removeChangeListener(image:Image):Void;

	function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):SubTexture;
}