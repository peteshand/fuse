package fuse.core.backend.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */

class CoreTexture
{
	public var textureId:Int;
	@:isVar public var textureData(get, set):ITextureData;
	//public var textureData:ITextureData;
	public var activeCount:Int = 0;
	var changeAvailable:Bool = false;
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
	
	public var textureHasChanged(get, null):Bool;
	
	public function new(textureId:Int) 
	{
		this.textureId = textureId;
		textureData = CommsObjGen.getTextureData(textureId);
		textureAvailable = new Notifier<Int>(0);
		textureAvailable.add(OnTextureAvailableChange);
		
		changeCount = new Notifier<Int>(0);
		changeCount.add(OnCountChange);
	}
	
	function OnCountChange() 
	{
		OnTextureAvailableChange();
	}
	
	inline function OnTextureAvailableChange() 
	{
		if (textureData.directRender == 1) return;
		changeAvailable = true;
	}
	
	public function updateUVData() 
	{
		uvsHaveChanged = false;
		
		p2Width = textureData.p2Width;
		p2Height = textureData.p2Height;
		
		//_uvLeft = _uvRight = textureData.x;
		//_uvTop = _uvBottom = textureData.y;
		//_uvLeft /= p2Width;
		//_uvTop /= p2Height;
		//
		//_uvRight += textureData.width;
		//_uvBottom += textureData.height;
		//_uvRight /= p2Width;
		//_uvBottom /= p2Height;
		
		_uvLeft = textureData.x / textureData.p2Width;
		_uvTop = textureData.y / textureData.p2Height;
		_uvRight = (textureData.x + textureData.width) / textureData.p2Width;
		_uvBottom = (textureData.y + textureData.height) / textureData.p2Height;
		
		if (uvLeft != _uvLeft || uvTop != _uvTop || uvRight != _uvRight || uvBottom != _uvBottom) {
			//trace([uvLeft, _uvLeft, uvTop, _uvTop, uvRight, _uvRight, uvBottom, _uvBottom]);
			uvsHaveChanged = true;
		}
		
		uvLeft = _uvLeft;
		uvTop = _uvTop;
		uvRight = _uvRight;
		uvBottom = _uvBottom;
	}
	
	inline function get_textureHasChanged():Bool 
	{
		changeCount.value = textureData.changeCount;
		textureAvailable.value = textureData.textureAvailable;
		if (changeAvailable) {
			updateUVData();
			changeAvailable = false;
			return true;
		}
		return false;
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
	
	public inline function clearTextureChange() 
	{
		changeAvailable = false;
	}
}