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
	var textureData:ITextureData;
	var nativeTexture(get, null):Texture;
	var textureBase(get, null):TextureBase;
	var directRender(get, set):Bool;
	var objectId:ObjectId;
	var textureId:TextureId;
	@:isVar var width(default, set):Null<Int>;
	@:isVar var height(default, set):Null<Int>;
	var onUpdate:Signal0;
	var onUpload:Signal0;
	var clearColour:Color;
	var _clear:Bool;
	var _alreadyClear:Bool;
	
	@:isVar public var offsetU(default, set):Float;
	@:isVar public var offsetV(default, set):Float;
	@:isVar public var scaleU(default, set):Float;
	@:isVar public var scaleV(default, set):Float;

	function upload():Void;
	function dispose():Void;

	function addChangeListener(image:Image):Void;
	function removeChangeListener(image:Image):Void;

	function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):SubTexture;

	private function setTextureData():Void;
}