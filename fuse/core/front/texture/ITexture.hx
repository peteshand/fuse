package fuse.core.front.texture;

import fuse.display.Image;
import fuse.texture.TextureId;
import fuse.utils.Color;
import msignal.Signal.Signal0;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import fuse.utils.ObjectId;
import fuse.core.communication.data.textureData.ITextureData;

/**
 * @author P.J.Shand
 */
interface ITexture 
{
	var objectId:ObjectId;
	var textureId:TextureId;
	var onUpdate:Signal0;
	var onUpload:Signal0;

	@:isVar var width(get, set):Null<Int>;
	@:isVar var height(get, set):Null<Int>;
	@:isVar var offsetU(get, set):Float;
	@:isVar var offsetV(get, set):Float;
	@:isVar var scaleU(get, set):Float;
	@:isVar var scaleV(get, set):Float;
	@:isVar var directRender(get, set):Bool;

	var textureData:ITextureData;
	var nativeTexture(get, null):Texture;
	var textureBase(get, null):TextureBase;
	var clearColour:Color;
	var _clear:Bool;
	var _alreadyClear:Bool;
	
	

	function upload():Void;
	function dispose():Void;

	function addChangeListener(image:Image):Void;
	function removeChangeListener(image:Image):Void;

	function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):SubTexture;

	private function setTextureData():Void;
}