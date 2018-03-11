package fuse.core.backend.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import mantle.notifier.Notifier;

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
	
	public function new(textureId:Int) 
	{
		this.textureId = textureId;
		textureData = CommsObjGen.getTextureData(textureId);
		textureAvailable = new Notifier<Int>(0);
		textureAvailable.add(OnTextureAvailableChange);
		
		changeCount = new Notifier<Int>(-1);
		changeCount.add(OnCountChange);
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
		
		p2Width = textureData.p2Width;
		p2Height = textureData.p2Height;
		
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
	
	public function checkForChanges():Void
	{
		textureHasChanged = false;
		changeCount.value = textureData.changeCount;
		textureAvailable.value = textureData.textureAvailable;
		
		if (textureHasChanged) {
			textureHasChanged = true;
			updateUVData();
		}
		
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
	
	//public inline function clearTextureChange() 
	//{
		//textureHasChanged = false;
	//}
}