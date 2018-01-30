package fuse.robotlegs.config.logic.html;
import fuse.utils.Storage;
import haxe.Json;
import openfl.errors.Error;
import openfl.net.SharedObject;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.model.ConfigSettings;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class HtmlDynamicConfigLogic
{
	@inject public var configModel:IConfigModel;
	private var localSharedObject:SharedObject;
	private var globalSharedObject:SharedObject;
	
	public function new() { }
	
	public function init() 
	{
		localSharedObject = SharedObject.getLocal("localHtmlDynamicConfigLogic");
		globalSharedObject = SharedObject.getLocal("globalHtmlDynamicConfigLogic");
		
		loadDynamicData(configModel.localDynamicData, localSharedObject);
		loadDynamicData(configModel.globalDynamicData, globalSharedObject);
		
		configModel.onLocalDynamicSet.add(OnLocalDynamicSet);
		configModel.onGlobalDynamicSet.add(OnGlobalDynamicSet);
	}
	
	function loadDynamicData(dynamicData:Map<String, Dynamic>, sharedObject:SharedObject) 
	{
		var fields:Array<String> = Reflect.fields(sharedObject.data);
		for (i in 0...fields.length) 
		{
			var field:String = fields[i];
			dynamicData.set(field, Reflect.getProperty(sharedObject.data, field));
		}
	}
	
	function OnLocalDynamicSet() 
	{
		for (key in configModel.localDynamicData.keys()) 
		{
			localSharedObject.setProperty(key, configModel.localDynamicData.get(key));
		}
		localSharedObject.flush();
	}
	
	function OnGlobalDynamicSet() 
	{
		for (key in configModel.localDynamicData.keys()) 
		{
			globalSharedObject.setProperty(key, configModel.globalDynamicData.get(key));
		}
		globalSharedObject.flush();
	}
}