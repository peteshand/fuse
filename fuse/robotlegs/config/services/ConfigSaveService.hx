package fuse.robotlegs.config.services;

import fuse.robotlegs.config.utils.JsonFormatter;
import fuse.utils.delay.Delay;
import fuse.filesystem.FileTools;
import fuse.filesystem.File;
import haxe.Json;


/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ConfigSaveService 
{
	public function new() { 
		
	}	
	
	#if air
	
	public function saveConfigData(configData:Dynamic, saveLocation:File):Void
	{
		try{
			var strData:String = null;
			if (Std.is(configData, String)) strData = cast configData;
			else strData = Json.stringify(configData);
			var formatedJson:String = JsonFormatter.formatJsonString(strData);
			FileTools.saveContentAsyncWithConfirm(saveLocation.nativePath, formatedJson, Confirm, onSaveComplete);
			
		}catch (e:Dynamic){
			// File in use error is probably most common here
			Delay.byTime(1000,  saveConfigData, [configData, saveLocation]);
		}
	}
	
	function onSaveComplete() 
	{
		
	}
	
	function Confirm(content:String, savedContent:String):Bool
	{
		if (savedContent == null) return false;
		if (savedContent == "null") return false;
		if (savedContent == "") return false;
		
		try {
			var json:Dynamic = Json.parse(savedContent);
			return true;
		}
		catch (e:Dynamic) {
			//trace("config save failed because the output can't be json parsed: " + e);
		}
		return false;
	}
	
	#end
}