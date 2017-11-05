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
	public var activeCount:Int = 0;
	var changeAvailable:Bool = false;
	var textureAvailable:Notifier<Int>;
	
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
	}
	
	function OnTextureAvailableChange() 
	{
		if (textureData.directRender == 1) return;
		changeAvailable = true;
	}
	
	public function updateUVData() 
	{
		uvLeft = textureData.x / textureData.p2Width;
		uvTop = textureData.y / textureData.p2Height;
		uvRight = (textureData.x + textureData.width) / textureData.p2Width;
		uvBottom = (textureData.y + textureData.height) / textureData.p2Height;
	}
	
	function get_textureHasChanged():Bool 
	{
		textureAvailable.value = textureData.textureAvailable;
		if (changeAvailable) {
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
		return textureData;
	}
	
	public inline function clearTextureChange() 
	{
		changeAvailable = false;
	}
}