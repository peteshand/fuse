package robotlegs.extensions.api.model.config;

import msignal.Signal.Signal0;
import openfl.geom.Rectangle;
import robotlegs.extensions.impl.commands.config.ConfigCommand;
import robotlegs.extensions.impl.model.config2.ConfigSummary;
import robotlegs.extensions.impl.model.config2.Locations;
	
/**
 * ...
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
	var autoScaleViewport:Bool;
	var hideMouse:Bool;
	
	@:allow(robotlegs.extensions.impl.commands.config.ConfigCommand)
	var configSummary:ConfigSummary;
	
	function set(key:String, value:Dynamic):Void;
	function get(key:String):Dynamic;
	
	var localDynamicData:Map<String, Dynamic>;
	var onLocalDynamicSet:Signal0;
}