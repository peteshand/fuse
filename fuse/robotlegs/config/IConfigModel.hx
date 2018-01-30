package fuse.robotlegs.config;

import fuse.signal.Signal0;
import fuse.robotlegs.config.commands.ConfigCommand;
import fuse.robotlegs.config.model.ConfigSummary;
import fuse.robotlegs.config.model.Locations;

/**
 * @author P.J.Shand
 */
interface IConfigModel 
{
	var timeout:Int;
	var activeFPS:Int;
	var throttleFPS:Int;
	var throttleTimeout:Int;
	
	var configReady:Bool;
	var retainScreenPosition:Bool;
	var fullscreenOnInit:Bool;
	var draggableWindow:Bool;
	var resizableWindow:Bool;
	var logErrors:Bool;
	var naturalSize:Array<UInt>;
	
	var closeOnCriticalError:Bool;
	var alwaysOnTop:Bool;
	var fullWindowResize:Bool;
	var setContextMenu:Bool;
	var autoScaleViewport:Bool;
	var hideMouse:Bool;
	
	var resourceSyncEnabled:Bool;
	var resourceAppId:String;
	
	var emailServerScript:Null<String>;
	var emails:Array<String>;

	@:allow(fuse.robotlegs.config.commands.ConfigCommand)
	var configSummary:ConfigSummary;
	var globalSummary:ConfigSummary;
	
	function set(key:String, value:Dynamic, global:Bool = false):Void;
	function get(key:String, global:Bool = false):Dynamic;
	//function setLocation(key:String, location:Locations, global:Bool = false):Void;
	//function getLocation(key:String, global:Bool = false):Dynamic;
	
	
	
	
	var localDynamicData:Map<String, Dynamic>;
	var onLocalDynamicSet:Signal0;
	
	var globalDynamicData:Map<String, Dynamic>;
	var onGlobalDynamicSet:Signal0;
}