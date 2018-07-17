package robotlegs.extensions.impl.model.config;

import mantle.util.app.App;
import mantle.util.device.DeviceInfo;
import msignal.Signal.Signal0;
import openfl.errors.Error;
import openfl.geom.Rectangle;
import robotlegs.extensions.impl.model.config2.ConfigData;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.model.config2.ConfigSummary;
import robotlegs.extensions.impl.model.config2.Locations;
import robotlegs.extensions.impl.utils.config.ConfigUtil;

#if !html5
import mantle.util.fs.File;
#end

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
@:rtti
class BaseConfigModel 
{
	public var configSummary:ConfigSummary;
	
	public var localDynamicData = new Map<String, Dynamic>();
	public var onLocalDynamicSet = new Signal0();
	
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
	//public var fullWindowResize:Bool = true;
	//public var setContextMenu:Bool;
	public var autoScaleViewport:Bool;
	public var hideMouse:Bool;
	//public var terminalName:String;
	
	//public var resourceSyncEnabled:Bool = false;
	//public var resourceAppId:String;
	
	//public var emailServerScript:Null<String>;
	//public var emails:Array<String>;
	
	//#if !html5
	//private static var _storageDirectory:File;
	//public static var storagePath(get, null):String;
	//public static function get_storagePath():String 
	//{
		//if (_storageDirectory==null) {
			//if (DeviceInfo.isIOS) {
				//_storageDirectory = File.applicationStorageDirectory.resolvePath("imagination/" + App.getAppId());
			//}
			//else {
				//_storageDirectory = File.documentsDirectory.resolvePath("imagination/" + App.getAppId());
			//}
			//
			//if (!_storageDirectory.exists) _storageDirectory.createDirectory();
		//}
		//return _storageDirectory.nativePath;
	//}
	//#end
	//
	
	public var naturalSize:Array<UInt>;
	
	public function new() {
		
	}
	
	public function set(key:String, _value:Dynamic):Void
	{
		if (get(key) != _value) {
			
			var dynamicData:Map<String, Dynamic> = localDynamicData;
			
			if (_value == null) dynamicData.remove(key);
			else dynamicData.set(key, _value);
			
			var summary:ConfigSummary = configSummary;
			try {
				Reflect.setProperty(this, key, _value);
			}
			catch (e:Error) {
				
			}
			
			onLocalDynamicSet.dispatch();
			/*var summary:ConfigSummary = configSummary;
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
	
	public function get(key:String):Dynamic
	{
		var dynamicData:Map<String, Dynamic> = localDynamicData;
		
		if (dynamicData.exists(key)) {
			return dynamicData.get(key);
		}
		return null;
		
		//var summary:ConfigSummary = configSummary;
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
			var summary:ConfigSummary = configSummary;
			
			ConfigUtil.setConfigDataLocation(key, summary.combinedConfigData, location);
			ConfigUtil.setConfigDataLocation(key, summary.localConfigData, location);
			onDynamicSet.dispatch();
		}
	}*/
	
	/*public function getLocation(key:String, global:Bool=false):Dynamic
	{
		var summary:ConfigSummary = configSummary;
		var configProp:ConfigProp = ConfigUtil.getConfigProp(key, summary.combinedConfigData);
		if (configProp == null) return null;
		return configProp._activeLocation;
	}*/
}