package fuse.utilsSort.transition.plugins;
import fuse.utilsSort.transition.TransitionSettings;
import fuse.utilsSort.transition.plugins.TransitionPlugins.DefaultPlugin;
import fuse.utilsSort.transition.plugins.TransitionPlugins.IntPlugin;
import fuse.utilsSort.transition.plugins.TransitionPlugins.Plugin;
import openfl.errors.Error;

/**
 * ...
 * @author Thomas Byrne
 */
class TransitionPlugins
{
	static private var standardInstalled:Bool;
	static private var _defaultPlugin:Plugin;
	static private var _plugins:Map<String, Plugin> = new Map();

	public inline static function installStandard() 
	{
		if (standardInstalled) return;
		standardInstalled = true;
		
		install("x", IntPlugin);
		install("y", IntPlugin);
		install("alpha", AlphaPlugin);
		defaultPlugin(DefaultPlugin);
	}
	
	static public function defaultPlugin(plugin:Plugin) 
	{
		_defaultPlugin = plugin;
	}
	
	static public function install(prop:String, plugin:Plugin) 
	{
		_plugins.set(prop, plugin);
	}
	
	static public function getPlugin(target:Dynamic, prop:String, option:TransitionSettings) 
	{
		var ret = _plugins.get(prop);
		if (ret != null && ret.match(target, prop, option) ){
			return ret;
		}else{
			return _defaultPlugin;
		}
	}
	
}

typedef Plugin =
{
	function match(target:Dynamic, prop:String, option:TransitionSettings) : Bool;
	function prop(target:Dynamic, prop:String, option:TransitionSettings) : Float->Void;
	function setter(target:Dynamic, prop:String, innerSetter:Float->Void, option:TransitionSettings) : Float->Void;
}

class DefaultPlugin
{
	public static function match(target:Dynamic, prop:String, option:TransitionSettings) : Bool
	{
		return true;
	}
	public static function prop(target:Dynamic, prop:String, option:TransitionSettings) : Float->Void
	{
		return applyProp.bind(target, prop, _);
	}
	public static function setter(target:Dynamic, prop:String, innerSetter:Float->Void, option:TransitionSettings) : Float->Void
	{
		return applySetter.bind(target, innerSetter, _);
	}
	
	public static function applyProp(target:Dynamic, prop:String, value:Float) 
	{
		untyped target[prop] = value;
	}
	
	public static function applySetter(target:Dynamic, innerSetter:Float->Void, value:Float) 
	{
		#if !js
			innerSetter(value);
		#else
			untyped innerSetter.call(target, Math.round(value));
		#end
	}
}

class IntPlugin
{
	public static function match(target:Dynamic, prop:String, option:TransitionSettings) : Bool
	{
		return true;
	}
	public static function prop(target:Dynamic, prop:String, option:TransitionSettings) : Float->Void
	{
		return applyProp.bind(target, prop, _);
	}
	public static function setter(target:Dynamic, prop:String, innerSetter:Float->Void, option:TransitionSettings) : Float->Void
	{
		return applySetter.bind(target, innerSetter, _);
	}
	
	public static function applySetter(target:Dynamic, innerSetter:Float->Void, value:Float) 
	{
		#if !js
			innerSetter(Math.round(value));
		#else
			untyped innerSetter.call(target, Math.round(value));
		#end
	}
	public static function applyProp(target:Dynamic, prop:String, value:Float) 
	{
		untyped target[prop] = Math.round(value);
	}
}

class AlphaPlugin
{
	public static function match(target:Dynamic, prop:String, option:TransitionSettings) : Bool
	{
		return option.autoVisible;
	}
	public static function prop(target:Dynamic, prop:String, option:TransitionSettings) : Float->Void
	{
		var autoVisObject = (option.autoVisObject != null ? option.autoVisObject : target);
		return applyProp.bind(target, prop, _, autoVisObject);
	}
	public static function setter(target:Dynamic, prop:String, innerSetter:Float->Void, option:TransitionSettings) : Float->Void
	{
		var autoVisObject = (option.autoVisObject != null ? option.autoVisObject : target);
		var visSetter:Bool -> Void = null;
		try {
			visSetter = untyped option.autoVisObject["set_visible"];
		}
		catch (e:Error) {
			
		}
		return applySetter.bind(target, innerSetter, _, visSetter);
	}
	
	public static function applyProp(target:Dynamic, prop:String, value:Float, autoVisObject:Dynamic) 
	{
		untyped target[prop] = value;
		if (value == 0) autoVisObject.visible = false;
		else autoVisObject.visible = true;
	}
	
	public static function applySetter(target:Dynamic, innerSetter:Float->Void, value:Float, visSetter:Bool->Void) 
	{
		#if !js
			innerSetter(value);
			if (visSetter != null){
				if (value == 0) visSetter(false);
				else visSetter(true);
			}
		#else
			untyped innerSetter.call(target, value);
			if (visSetter != null){
				if (value == 0) untyped visSetter.call(target, false);
				else untyped visSetter.call(target, true);
			}
		#end
	}
}