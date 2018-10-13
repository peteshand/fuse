package fuse.core.front.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.display.Image;
import fuse.texture.TextureId;
import msignal.Signal.Signal0;
import fuse.core.front.texture.ITexture;
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
class BaseTexture implements ITexture {
	//static var coreTextures = new Map<TextureId, BaseTexture>();

	//var coreTexture(get, never):BaseTexture;

	static var objectIdCount:Int = 0;
	static var textureIdCount:Int = 0;

	var onTextureUploadCompleteCallback:Void->Void;
	var persistent:Int;
	var p2Texture:Bool;
	var uploadFromBitmapDataAsync:BitmapData->UInt->Void;

	public var objectId:ObjectId;
	public var textureId:TextureId;
	
	public var textureData:ITextureData;
	
	@:isVar public var width(default, set):Null<Int>;
	@:isVar public var height(default, set):Null<Int>;
	public var onUpdate = new Signal0();
	public var onUpload = new Signal0();
	public var nativeTexture(get, null):Texture;
	public var textureBase(get, null):TextureBase;
	public var dependantDisplays = new Map<Int, Image>();
	public var clearColour:Color = 0;
	public var _clear:Bool = false;
	public var _alreadyClear:Bool = false;
	@:isVar public var directRender(get, set):Bool = false;

	@:isVar public var offsetU(default, set):Float = 0;
	@:isVar public var offsetV(default, set):Float = 0;
	@:isVar public var scaleU(default, set):Float = 1;
	@:isVar public var scaleV(default, set):Float = 1;

	public function new(width:Int, height:Int, queUpload:Bool = true, onTextureUploadCompleteCallback:Void->Void = null, p2Texture:Bool = true, _textureId:Null<TextureId> = null, _objectId:Null<ObjectId> = null) {
		// objectId = BaseTexture.objectIdCount++;

		if (_textureId == null) {
			this.textureId = BaseTexture.textureIdCount++;
		} else {
			this.textureId = _textureId;
			if (BaseTexture.textureIdCount <= _textureId) BaseTexture.textureIdCount = _textureId + 1;
		}
		
		if (_objectId == null) {
			this.objectId = BaseTexture.objectIdCount++;
			//this.textureId = BaseTexture.textureIdCount++;
		} else {
			this.objectId = _objectId;
			//this.textureId = _textureId;
			if (BaseTexture.objectIdCount <= _objectId) BaseTexture.objectIdCount = _objectId + 1;
			//if (BaseTexture.textureIdCount <= _textureId) BaseTexture.textureIdCount = _textureId + 1;
		}
		
		this.width = width;
		this.height = height;
		this.p2Texture = p2Texture;
		this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		textureData = CommsObjGen.getTextureData(objectId, textureId);

		// setTextureData();
		Fuse.current.workerSetup.addTexture( { objectId:objectId, textureId:textureId });

		onUpdate.add(function() {
			for (image in dependantDisplays.iterator())
				image.OnTextureUpdate();
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

		textureData.textureAvailable = 0;
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

	function get_textureBase():TextureBase {
		return textureData.textureBase;
	}

	function get_directRender():Bool {
		return directRender;
	}

	function get_nativeTexture():Texture {
		return textureData.nativeTexture;
	}

	/*function get_coreTexture():BaseTexture {
		return coreTextures.get(objectId);
	}*/

	public function addChangeListener(image:Image) {
		//coreTexture.dependantDisplays.set(image.objectId, image);
		dependantDisplays.set(image.objectId, image);
	}

	public function removeChangeListener(image:Image) {
		//coreTexture.dependantDisplays.remove(image.objectId);
		dependantDisplays.remove(image.objectId);
	}

	function set_offsetU(value:Float):Float
	{
		textureData.offsetU = offsetU = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		//textureData.changeCount++;
		return offsetU;
	}

	function set_offsetV(value:Float):Float
	{
		textureData.offsetV = offsetV = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		//textureData.changeCount++;
		return offsetV;
	}

	function set_scaleU(value:Float):Float
	{
		textureData.scaleU = scaleU = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		//textureData.changeCount++;
		return scaleU;
	}

	function set_scaleV(value:Float):Float
	{
		textureData.scaleV = scaleV = value;
		Fuse.current.workerSetup.updateTexture(objectId);
		//textureData.changeCount++;
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

	public function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):SubTexture
	{
		var texture = new SubTexture(width, height, this);
		texture.offsetU = offsetU;
		texture.offsetV = offsetV;
		texture.scaleU = scaleU;
		texture.scaleV = scaleV;
		return texture;
	}
}
