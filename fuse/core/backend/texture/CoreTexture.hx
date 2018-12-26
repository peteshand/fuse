package fuse.core.backend.texture;

import fuse.core.front.texture.TextureRef;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;
import fuse.core.backend.display.CoreImage;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureSizeData;
import notifier.Notifier;
import notifier.Signal;

/**
 * ...
 * @author P.J.Shand
 */

class CoreTexture
{
	public var textureId:TextureId;
	public var objectId:ObjectId;
	
	@:isVar public var textureData(get, set):ITextureData;
	public var activeCount:Int = 0;
	var textureAvailable:Notifier<Int>;
	var changeCount:Notifier<Int>;
	var p2Width:Int;
	var p2Height:Int;

	@:isVar public var rotate(default, set):Bool = false;

	public var uvsHaveChanged:Bool = true;
	
	public var _uvLeft	:Float = 0;
	public var _uvTop	:Float = 0;
	public var _uvRight	:Float = 1;
	public var _uvBottom:Float = 1;
	
	public var uvLeft	:Float = 0;
	public var uvTop	:Float = 0;
	public var uvRight	:Float = 1;
	public var uvBottom	:Float = 1;
	
	public var textureHasChanged:Bool = true;
	public var onTextureChange = new Signal();
	var dependantDisplays = new Map<Int, CoreImage>();
	
	public function new(textureRef:TextureRef) 
	{
		textureId = textureRef.textureId;
		objectId = textureRef.objectId;
		
		textureData = CommsObjGen.getTextureData(objectId, textureId);
		
		
		//copyBaseValues();

		textureAvailable = new Notifier<Int>(0);
		textureAvailable.add(OnTextureAvailableChange);
		
		changeCount = new Notifier<Int>(-1);
		changeCount.add(OnCountChange);
		
		onTextureChange.add(function() {
			for (key in dependantDisplays.keys()) {
				var image = dependantDisplays.get(key);
				if (image != null) image.OnTextureChange();
			}
		});
	}

	public function update()
	{
		copyBaseValues();
		updateUVData();
	}
	
	function copyBaseValues()
	{
		textureData.baseData.x = textureData.x;
		textureData.baseData.y = textureData.y;
		textureData.baseData.width = textureData.width;
		textureData.baseData.height = textureData.height;
		textureData.baseData.p2Width = textureData.p2Width;
		textureData.baseData.p2Height = textureData.p2Height;
		
		textureData.atlasData.offsetU = textureData.offsetU;
		textureData.atlasData.offsetV = textureData.offsetV;
		textureData.atlasData.scaleU = textureData.scaleU;
		textureData.atlasData.scaleV = textureData.scaleV;
	}
	
	function OnCountChange() 
	{
		OnTextureAvailableChange();
	}
	
	inline function OnTextureAvailableChange() 
	{
		textureHasChanged = true;
	}

	function set_rotate(value:Bool):Bool
	{
		if (rotate == value) return value;
		rotate = value;
		updateUVData();
		return rotate;
	}
	
	public function updateUVData() 
	{
		var activeData:TextureSizeData = textureData.activeData;
		p2Width = activeData.p2Width;
		p2Height = activeData.p2Height;
		
		if (this.rotate) {
			_uvLeft = (activeData.x + (activeData.offsetV * activeData.width)) / p2Width;
			_uvTop = (activeData.y + (activeData.height * (1 - activeData.scaleU)) - (activeData.offsetU * activeData.height)) / p2Height;
			_uvRight = (activeData.x + (activeData.width * activeData.scaleV) + (activeData.offsetV * activeData.width)) / p2Width;
			_uvBottom = (activeData.y + (activeData.height) - (activeData.offsetU * activeData.height)) / p2Height;
		} else {
			_uvLeft = (activeData.x + (activeData.offsetU * activeData.width)) / p2Width;
			_uvTop = (activeData.y + (activeData.offsetV * activeData.height)) / p2Height;
			_uvRight = (activeData.x + (activeData.width * activeData.scaleU) + (activeData.offsetU * activeData.width)) / p2Width;
			_uvBottom = (activeData.y + (activeData.height * activeData.scaleV) + (activeData.offsetV * activeData.height)) / p2Height;
		}
		
		
		if (uvLeft != _uvLeft || uvTop != _uvTop || uvRight != _uvRight || uvBottom != _uvBottom) {
			//trace([uvLeft, _uvLeft, uvTop, _uvTop, uvRight, _uvRight, uvBottom, _uvBottom]);
			uvsHaveChanged = true;
		}
		
		uvLeft = _uvLeft;
		uvTop = _uvTop;
		uvRight = _uvRight;
		uvBottom = _uvBottom;
		
	}

	public function getUVData(uvItem:UVItem) 
	{
		var activeData:TextureSizeData = textureData.activeData;
		p2Width = activeData.p2Width;
		p2Height = activeData.p2Height;
		
		uvItem.offsetU += activeData.offsetU;
		uvItem.offsetV += activeData.offsetV;
		uvItem.scaleU *= activeData.scaleU;
		uvItem.scaleV *= activeData.scaleV;
		
		if (this.rotate) {
			uvItem.uvLeft = (activeData.x + (uvItem.offsetV * activeData.width)) / p2Width;
			uvItem.uvTop = (activeData.y + (activeData.height * (1 - uvItem.scaleU)) - (uvItem.offsetU * activeData.height)) / p2Height;
			uvItem.uvRight = (activeData.x + (activeData.width * uvItem.scaleV) + (uvItem.offsetV * activeData.width)) / p2Width;
			uvItem.uvBottom = (activeData.y + (activeData.height) - (uvItem.offsetU * activeData.height)) / p2Height;
		} else {
			uvItem.uvLeft = (activeData.x + (uvItem.offsetU * activeData.width)) / p2Width;
			uvItem.uvTop = (activeData.y + (uvItem.offsetV * activeData.height)) / p2Height;
			uvItem.uvRight = (activeData.x + (activeData.width * uvItem.scaleU) + (uvItem.offsetU * activeData.width)) / p2Width;
			uvItem.uvBottom = (activeData.y + (activeData.height * uvItem.scaleV) + (uvItem.offsetV * activeData.height)) / p2Height;
		}
	}
	
	public function checkForChanges():Void
	{
		textureHasChanged = false;
		changeCount.value = textureData.changeCount;
		textureAvailable.value = textureData.textureAvailable;
		
		if (textureHasChanged) {
			//textureHasChanged = true;
			updateUVData();
			onTextureChange.dispatch();
			//trace("change: " + this.textureId);
		}
	}
	
	public function addChangeListener(coreImage:CoreImage) 
	{
		dependantDisplays.set(coreImage.objectId, coreImage);
	}
	
	public function removeChangeListener(coreImage:CoreImage) 
	{
		dependantDisplays.remove(coreImage.objectId);
	}
	
	inline function get_textureData():ITextureData 
	{
		return textureData;
	}
	
	inline function set_textureData(value:ITextureData):ITextureData 
	{
		textureData = value;
		updateUVData();
		return textureData;
	}
}

typedef UVItem =
{
	uvLeft:Float,
	uvTop:Float,
	uvRight:Float,
	uvBottom:Float,

	offsetU:Float,
	offsetV:Float,
	scaleU:Float,
	scaleV:Float
}