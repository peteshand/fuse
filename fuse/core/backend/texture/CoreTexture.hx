package fuse.core.backend.texture;

import fuse.core.backend.display.CoreImage;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureSizeData;
import mantle.notifier.Notifier;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */

class CoreTexture
{
	public var textureId:Int;
	@:isVar public var textureData(get, set):ITextureData;
	public var activeCount:Int = 0;
	var textureAvailable:Notifier<Int>;
	var changeCount:Notifier<Int>;
	var p2Width:Int;
	var p2Height:Int;
	
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
	public var onTextureChange = new Signal0();
	var dependantDisplays = new Map<Int, CoreImage>();
	
	public function new(textureId:Int) 
	{
		this.textureId = textureId;
		textureData = CommsObjGen.getTextureData(textureId);
		
		
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
	
	public function updateUVData() 
	{
		uvsHaveChanged = false;
		
		var activeData:TextureSizeData = textureData.activeData;
		p2Width = activeData.p2Width;
		p2Height = activeData.p2Height;
		
		_uvLeft = (activeData.x + activeData.offsetU) / p2Width;
		_uvTop = (activeData.y + activeData.offsetV) / p2Height;
		_uvRight = (activeData.x + (activeData.width * activeData.scaleU) + activeData.offsetU) / p2Width;
		_uvBottom = (activeData.y + (activeData.height * activeData.scaleV) + activeData.offsetV) / p2Height;
		
		if (uvLeft != _uvLeft || uvTop != _uvTop || uvRight != _uvRight || uvBottom != _uvBottom) {
			//trace([uvLeft, _uvLeft, uvTop, _uvTop, uvRight, _uvRight, uvBottom, _uvBottom]);
			uvsHaveChanged = true;
		}
		
		uvLeft = _uvLeft;
		uvTop = _uvTop;
		uvRight = _uvRight;
		uvBottom = _uvBottom;
	}
	
	public function checkForChanges():Void
	{
		textureHasChanged = false;
		changeCount.value = textureData.changeCount;
		textureAvailable.value = textureData.textureAvailable;
		
		if (textureHasChanged) {
			textureHasChanged = true;
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