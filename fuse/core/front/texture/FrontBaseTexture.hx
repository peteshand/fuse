package fuse.core.front.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.display.Image;
import fuse.texture.TextureId;
import signal.Signal;
import fuse.core.front.texture.IFrontTexture;
import fuse.utils.Color;
import fuse.utils.PowerOfTwo;
import openfl.display.BitmapData;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.Context3DTextureFormat;
import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class FrontBaseTexture implements IFrontTexture
{
	static var objectIdCount:Int = 0;
	static var textureIdCount:Int = 0;

	//var onTextureUploadCompleteCallback:Void->Void;
	var persistent:Int;
	var p2Texture:Bool;
	var uploadFromBitmapDataAsync:BitmapData->UInt->Void;
	
	public var objectId:ObjectId;
	public var textureId:TextureId;
	public var textureAvailable:Bool = false;
	public var onUpdate = new Signal();
	public var onUpload = new Signal();
	@:isVar public var width(get, set):Null<Int>;
	@:isVar public var height(get, set):Null<Int>;
	@:isVar public var offsetU(get, set):Float = 0;
	@:isVar public var offsetV(get, set):Float = 0;
	@:isVar public var scaleU(get, set):Float = 1;
	@:isVar public var scaleV(get, set):Float = 1;
	@:isVar public var directRender(get, set):Bool = false;

	public var textureData:ITextureData;
	public var nativeTexture(get, null):Texture;
	public var textureBase(get, null):TextureBase;
	public var clearColour:Color = 0;
	public var _clear:Bool = false;
	public var _alreadyClear:Bool = false;

	public var dependantDisplays = new Map<Int, Image>();
	
	public function new(width:Int, height:Int, queUpload:Bool = true, /*onTextureUploadCompleteCallback:Void->Void = null, */p2Texture:Bool = true, _textureId:Null<TextureId> = null, _objectId:Null<ObjectId> = null) {
		// objectId = FrontBaseTexture.objectIdCount++;

		if (_textureId == null) {
			this.textureId = FrontBaseTexture.textureIdCount++;
		} else {
			this.textureId = _textureId;
			if (FrontBaseTexture.textureIdCount <= _textureId) FrontBaseTexture.textureIdCount = _textureId + 1;
		}
		
		if (_objectId == null) {
			this.objectId = FrontBaseTexture.objectIdCount++;
			//this.textureId = FrontBaseTexture.textureIdCount++;
		} else {
			this.objectId = _objectId;
			//this.textureId = _textureId;
			if (FrontBaseTexture.objectIdCount <= _objectId) FrontBaseTexture.objectIdCount = _objectId + 1;
			//if (FrontBaseTexture.textureIdCount <= _textureId) FrontBaseTexture.textureIdCount = _textureId + 1;
		}
		
		this.width = width;
		this.height = height;
		this.p2Texture = p2Texture;
		//this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		textureData = CommsObjGen.getTextureData(objectId, textureId);

		// setTextureData();
		Fuse.current.workerSetup.addTexture( { objectId:objectId, textureId:textureId });

		onUpdate.add(function() {
			for (image in dependantDisplays.iterator())
				image.onTextureUpdate();
		});

		//coreTextures.set(this.textureId, this);

		if (queUpload)
			TextureUploadQue.add(this);
		else
			upload();
		
	}

	function setTextureData() {
		textureData.x = 0;
		textureData.y = 0;
		textureData.width = width;
		textureData.height = height;

		if (p2Texture) {
			textureData.p2Width = PowerOfTwo.getNextPowerOfTwo(width);
			textureData.p2Height = PowerOfTwo.getNextPowerOfTwo(height);
		} else {
			textureData.p2Width = width;
			textureData.p2Height = height;
		}
		
		textureData.offsetU = offsetU;
		textureData.offsetV = offsetV;
		textureData.scaleU = scaleU;
		textureData.scaleV = scaleV;

		//textureData.textureAvailable = 0;
		textureData.persistent = persistent;
		Fuse.current.workerSetup.updateTexture(objectId);
		onUpdate.dispatch();
	}

	public function createNativeTexture() {
		setTextureData();
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(textureData.p2Width, textureData.p2Height, Context3DTextureFormat.BGRA, false, 0);
		#if air
		try {
			uploadFromBitmapDataAsync = untyped textureData.nativeTexture["uploadFromBitmapDataAsync"];
		} catch (e:Dynamic) {}
		#else
		uploadFromBitmapDataAsync = Reflect.getProperty(textureData.nativeTexture, "uploadFromBitmapDataAsync");
		#end
		return textureData.textureBase;
	}

	public function upload() {
		throw "This function should be overriden";
	}

	public function dispose():Void {
		if (objectId <= 1) {
			// Can't dispose default textures
			return;
		}
		Fuse.current.workerSetup.removeTexture(objectId);
		Textures.deregisterTexture(textureId, this);
		textureData.dispose();
	}

	function set_directRender(value:Bool):Bool {
		if (directRender == value)
			return value;
		directRender = value;
		if (directRender)
			textureData.directRender = 1;
		else
			textureData.directRender = 0;
		return directRender;
	}

	function get_width():Null<Int>		{	return width;			}
	function get_height():Null<Int>		{	return height;			}
	function get_offsetU():Float		{	return offsetU;			}
	function get_offsetV():Float		{	return offsetV;			}
	function get_scaleU():Float			{	return scaleU;			}
	function get_scaleV():Float			{	return scaleV;			}
	function get_directRender():Bool	{	return directRender;	}
	
	function get_textureBase():TextureBase	{	return textureData.textureBase;		}
	function get_nativeTexture():Texture	{	return textureData.nativeTexture;	}

	public function addChangeListener(image:Image) {
		dependantDisplays.set(image.objectId, image);
		if (textureAvailable == true) {
			image.onTextureUpdate();
		}
		
	}

	public function removeChangeListener(image:Image) {
		dependantDisplays.remove(image.objectId);
	}

	function set_offsetU(value:Float):Float
	{
		textureData.offsetU = offsetU = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		return offsetU;
	}

	function set_offsetV(value:Float):Float
	{
		textureData.offsetV = offsetV = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		return offsetV;
	}

	function set_scaleU(value:Float):Float
	{
		textureData.scaleU = scaleU = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		return scaleU;
	}

	function set_scaleV(value:Float):Float
	{
		textureData.scaleV = scaleV = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		return scaleV;
	}

	function set_width(value:Null<Int>):Null<Int>
	{
		return width = value;
	}

	function set_height(value:Null<Int>):Null<Int>
	{
		return height = value;
	}

	public function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):FrontSubTexture
	{
		var texture = new FrontSubTexture(width, height, this);
		texture.offsetU = offsetU;
		texture.offsetV = offsetV;
		texture.scaleU = scaleU;
		texture.scaleV = scaleV;
		return texture;
	}
}
