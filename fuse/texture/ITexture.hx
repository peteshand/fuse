package fuse.texture;

import fuse.display.Image;
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
	//var textureId:TextureId;
	var width:Null<Int>;
	var height:Null<Int>;
	var onUpdate:Signal0;
	var clearColour:Color;
	var _clear:Bool;
	var _alreadyClear:Bool;
	
	function upload():Void;
	function dispose():Void;

	function addChangeListener(image:Image):Void;
	function removeChangeListener(image:Image):Void;
}