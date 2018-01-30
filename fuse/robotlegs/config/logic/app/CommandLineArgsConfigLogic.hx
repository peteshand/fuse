package fuse.robotlegs.config.logic.app;

import flash.desktop.NativeApplication;
import flash.events.InvokeEvent;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.logic.app.CastUtils;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class CommandLineArgsConfigLogic
{
	@inject public var configModel:IConfigModel;
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, OnInvoke); 
	}
	
	private function OnInvoke(e:InvokeEvent):Void 
	{
		var i:Int = e.arguments.length - 1;
		while (i >= 0) 
		{
			if (i == 0) break;
			
			var key:String = e.arguments[i-1];
			var value:Dynamic = CastUtils.castValue(e.arguments[i]);
			try {
				Reflect.setProperty(configModel, key, value);
				trace("config property '" + key + "' set to '" + value + "'");
			}
			catch (e:Dynamic) {
				trace("can't write " + key + " to config");
			}
			i -= 2;
		}
	}
}