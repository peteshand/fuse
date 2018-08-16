package robotlegs.extensions.impl.services.config;

import mantle.delay.Delay;
import robotlegs.extensions.impl.utils.json.JsonFormatter;
import haxe.Json;
import org.swiftsuspenders.utils.DescribedType;
#if (air && !mobile)
	import mantle.util.fs.File;
	import fuse.filesystem.FileTools;
#end
/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class ConfigSaveService implements DescribedType
{
	//var configFile:File;
	//@inject public var configModel:IConfigModel;
	
	public function new() { 
		
		//configFile = File.documentsDirectory.resolvePath("imagination/" + App.getAppId() + "/config/" + ConfigSettings.FILE_NAME_LOCAL + ".json");
	}	
	
	#if (air && !mobile)
	/*public function saveCombinedToLocal() 
	{
		var configData:ConfigData = configModel.configSummary.combinedConfigData;
		if (configData == null) return;
		
		if (configFile.exists && configModel.configSummary.localConfigData == null) {
			warn("local config file already exists, however this data is currently not loaded, aborting override save");
			return;
		}
		
		configData._location = Locations.LOCATION_LOCAL;
		configData._filename = ConfigSettings.FILE_NAME_LOCAL;
		
		saveConfigData(configData, Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_LOCAL + ".json"));
	}*/
	
	//public function saveDynamic() 
	//{
		//var data:Array<Dynamic> = [];
		//for (key in configModel.dynamicData.keys()) 
		//{
			//var obj:Dynamic = { };
			//Reflect.setProperty(obj, key, configModel.dynamicData.get(key));
			//data.push( obj );
		//}
		//var dynamicConfig:Dynamic = { "props":data };
		//saveConfigData(dynamicConfig, Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_DYNAMIC + ".json"));
		//
		//
		//var configData:ConfigData = configModel.configSummary.combinedConfigData;
		///*if (configData == null) return;
		//
		//if (configFile.exists && configModel.configSummary.localConfigData == null) {
			//warn("local config file already exists, however this data is currently not loaded, aborting override save");
			//return;
		//}
		//
		//configData._location = Locations.LOCATION_LOCAL;
		//configData._filename = ConfigSettings.FILE_NAME_DYNAMIC;
		//
		//saveConfigData(configData, ConfigSettings.FILE_NAME_DYNAMIC);*/
	//}
	
	//public function saveRemoteCache() 
	//{
	//	var configData:ConfigData = configModel.configSummary.remoteConfigData;
	//	saveConfigData(configData, ConfigSettings.FILE_NAME_REMOTE);
	//}
	
	/*public function copyGlobalSeed() 
	{
		var globalConfigFile:File = Storage.globalConfigDirectory.resolvePath(ConfigSettings.FILE_NAME_LOCAL + ".json");
		if (!globalConfigFile.exists) {
			var jsonStr:String = Assets.getText("config/" + ConfigSettings.FILE_NAME_GLOBAL_SEED + ".json");
			FileTools.saveContentAsyncWithConfirm(globalConfigFile.nativePath, jsonStr, Confirm, onSaveComplete);
		}
	}*/
	
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
		//trace("saveContentAsyncWithConfirm complete");
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