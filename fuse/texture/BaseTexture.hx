package fuse.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.display.Image;
import msignal.Signal.Signal0;
import fuse.texture.ITexture;
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
	static var coreTextures = new Map<Int, BaseTexture>();

	public var coreTexture(get, never):BaseTexture;

	static var objectIdCount:Int = 0;
	static var textureIdCount:Int = 0;

	var onTextureUploadCompleteCallback:Void->Void;
	var persistent:Int;
	var p2Texture:Bool;
	var uploadFromBitmapDataAsync:BitmapData->UInt->Void;

	public var objectId:ObjectId;
	// public var textureId:TextureId;
	public var textureData:ITextureData;
	public var width:Null<Int>;
	public var height:Null<Int>;
	public var onUpdate = new Signal0();
	public var onUpload = new Signal0();
	public var nativeTexture(get, null):Texture;
	public var textureBase(get, null):TextureBase;
	public var dependantDisplays = new Map<Int, Image>();
	public var clearColour:Color = 0;
	public var _clear:Bool = false;
	public var _alreadyClear:Bool = false;
	@:isVar public var directRender(get, set):Bool = false;

	public function new(width:Int, height:Int, queUpload:Bool = true, onTextureUploadCompleteCallback:Void->Void = null, p2Texture:Bool = true,
			overTextureId:Null<Int> = null) {
		// objectId = BaseTexture.objectIdCount++;

		if (overTextureId == null)
			this.objectId = BaseTexture.objectIdCount++;
		else {
			this.objectId = overTextureId;
			if (BaseTexture.objectIdCount <= overTextureId) {
				BaseTexture.objectIdCount = overTextureId + 1;
			}
		}

		/*if (overTextureId == null) this.textureId = BaseTexture.textureIdCount++;
			else {
				this.textureId = overTextureId;
				if (BaseTexture.textureIdCount < overTextureId) {
					BaseTexture.textureIdCount = overTextureId + 1;
				}
		}*/

		// if (overTextureId == null) this.textureId = BaseTexture.textureIdCount++;
		// else this.textureId = overTextureId;

		this.width = width;
		this.height = height;
		this.p2Texture = p2Texture;
		this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		textureData = CommsObjGen.getTextureData(objectId);

		// setTextureData();
		Fuse.current.workerSetup.addTexture(objectId);

		if (queUpload)
			TextureUploadQue.add(this);
		else
			upload();

		Fuse.current.conductorData.frontStaticCount = 0;

		onUpdate.add(function() {
			for (image in dependantDisplays.iterator())
				image.OnTextureUpdate();
		});

		coreTextures.set(this.objectId, this);
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

		textureData.offsetU = 0;
		textureData.offsetV = 0;
		textureData.scaleU = 1;
		textureData.scaleV = 1;

		textureData.textureAvailable = 0;
		textureData.persistent = persistent;
		Fuse.current.workerSetup.updateTexture(objectId);
		onUpdate.dispatch();
	}

	public function createNativeTexture() {
		setTextureData();
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(textureData.p2Width, textureData.p2Height, Context3DTextureFormat
			.BGRA, false, 0);
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
		Textures.deregisterTexture(objectId, this);
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

	function get_coreTexture():BaseTexture {
		return coreTextures.get(objectId);
	}

	public function addChangeListener(image:Image) {
		coreTexture.dependantDisplays.set(image.objectId, image);
	}

	public function removeChangeListener(image:Image) {
		coreTexture.dependantDisplays.remove(image.objectId);
	}
}
