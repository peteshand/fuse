package fuse.robotlegs.config;

import fuse.info.AppInfo;
import fuse.signal.Signal0;
import openfl.errors.Error;
import openfl.geom.Rectangle;

import fuse.info.DeviceInfo;
import fuse.robotlegs.config.model.ConfigData;
import fuse.robotlegs.config.model.ConfigSettings;
import fuse.robotlegs.config.model.ConfigSummary;
import fuse.robotlegs.config.model.Locations;
import fuse.robotlegs.config.utils.ConfigUtil;

#if air
import fuse.filesystem.File;
#end

/**
 * ...
 * @author P.J.Shand
 */
class BaseConfigModel
{
	public var configSummary:ConfigSummary;
	public var globalSummary:ConfigSummary;
	
	public var localDynamicData = new Map<String, Dynamic>();
	public var onLocalDynamicSet = new Signal0();
	
	public var globalDynamicData = new Map<String, Dynamic>();
	public var onGlobalDynamicSet = new Signal0();
	
	public var timeout:Int = 60000;
	public var activeFPS:Int = 60;
	public var throttleFPS:Int = 4;
	public var throttleTimeout:Int = 60000;
	
	public var configReady:Bool = false;
	
	public var retainScreenPosition:Bool = true;
	public var fullscreenOnInit:Bool = true;
	public var draggableWindow:Bool = true;
	public var resizableWindow:Bool = true;
	public var logErrors:Bool = true;
	
	public var closeOnCriticalError:Bool = false;
	public var alwaysOnTop:Bool;
	public var fullWindowResize:Bool = true;
	public var setContextMenu:Bool;
	public var autoScaleViewport:Bool;
	public var hideMouse:Bool;
	public var terminalName:String;
	
	public var resourceSyncEnabled:Bool = false;
	public var resourceAppId:String;
	
	public var emailServerScript:Null<String>;
	public var emails:Array<String>;
	
	#if air
	private static var _storageDirectory:File;
	public static var storagePath(get, null):String;
	public static function get_storagePath():String 
	{
		if (_storageDirectory==null) {
			if (DeviceInfo.isIOS) {
				_storageDirectory = File.applicationStorageDirectory.resolvePath("imagination/" + AppInfo.appId);
			}
			else {
				_storageDirectory = File.documentsDirectory.resolvePath("imagination/" + AppInfo.appId);
			}
			
			if (!_storageDirectory.exists) _storageDirectory.createDirectory();
		}
		return _storageDirectory.nativePath;
	}
	#end
	
	
	public var naturalSize:Array<UInt>;
	
	public function new() {
		
	}
	
	public function set(key:String, _value:Dynamic, global:Bool=false):Void
	{
		if (get(key, global) != _value) {
			
			var dynamicData:Map<String, Dynamic> = localDynamicData;
			if (global) dynamicData = globalDynamicData;
			
			if (_value == null) dynamicData.remove(key);
			else dynamicData.set(key, _value);
			
			var summary:ConfigSummary = getSummary(global);
			try {
				Reflect.setProperty(this, key, _value);
			}
			catch (e:Error) {
				
			}
			
			if (global) onGlobalDynamicSet.dispatch();
			else onLocalDynamicSet.dispatch();
			/*var summary:ConfigSummary = getSummary(global);
			try {
				Reflect.setProperty(this, key, _value);
			}
			catch (e:Error) {
				
			}
			ConfigUtil.setConfigDataValue(key, summary.combinedConfigData, _value);
			ConfigUtil.setConfigDataLocation(key, summary.combinedConfigData, Locations.LOCATION_LOCAL);
			
			ConfigUtil.setConfigDataValue(key, summary.localConfigData, _value);
			ConfigUtil.setConfigDataLocation(key, summary.localConfigData, Locations.LOCATION_LOCAL);
			
			onDynamicSet.dispatch();*/
		}
	}
	
	public function get(key:String, global:Bool=false):Dynamic
	{
		var dynamicData:Map<String, Dynamic> = localDynamicData;
		if (global) dynamicData = globalDynamicData;
		
		if (dynamicData.exists(key)) {
			return dynamicData.get(key);
		}
		return null;
		
		//var summary:ConfigSummary = getSummary(global);
		//var configProp:ConfigProp = ConfigUtil.getConfigProp(key, summary.combinedConfigData);
		//if (configProp == null) return null;
		//return configProp.value;
	}
	
	/*
	 * Gets either Dynamic or real property.
	 */
	public function getProp(key:String):Dynamic
	{
		var dynamicData:Map<String, Dynamic> = localDynamicData;
		
		if (localDynamicData.exists(key)) {
			return localDynamicData.get(key);
		}
		try{
			return Reflect.field(this, key);
		}catch(e:Dynamic){
			return null;
		}
	}
	
	/*public function setLocation(key:String, location:Locations, global:Bool=false):Void
	{
		if (getLocation(key) != location) {
			var summary:ConfigSummary = getSummary(global);
			
			ConfigUtil.setConfigDataLocation(key, summary.combinedConfigData, location);
			ConfigUtil.setConfigDataLocation(key, summary.localConfigData, location);
			onDynamicSet.dispatch();
		}
	}*/
	
	/*public function getLocation(key:String, global:Bool=false):Dynamic
	{
		var summary:ConfigSummary = getSummary(global);
		var configProp:ConfigProp = ConfigUtil.getConfigProp(key, summary.combinedConfigData);
		if (configProp == null) return null;
		return configProp._activeLocation;
	}*/
	
	function getSummary(global:Bool) 
	{
		if (global) return globalSummary;
		else return configSummary;
	}
}