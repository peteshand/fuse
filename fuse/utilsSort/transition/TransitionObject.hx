package fuse.utilsSort.transition;

import fuse.utilsSort.transition.TransitionSettings;
import fuse.utilsSort.transition.plugins.TransitionPlugins;
import fuse.utilsSort.transition.plugins.TransitionPlugins.Plugin;
import motion.easing.Expo;
import motion.easing.IEasing;
import fuse.signal.Signal0;
import openfl.errors.Error;


/**
 * ...
 * @author P.J.Shand
 */
class TransitionObject implements ITransitionObject
{
	public var target:Target;
	private var transitionPropsMap = new Map<String,TransitionProps>();
	private var transitingIn:Bool;
	
	private var value:Float = -2;
	
	private var optionProperties:Array<String>;
	private var properties:Dynamic = {};
	var visSetter:Bool->Bool;
	public var option:TransitionSettings = {};
	public var onSet = new Signal0();
	
	// Update vars
	var uStartValue:Float;
	var uEndValue:Float;
	var uShowEase:IEasing;
	var uHideEase:IEasing;
	var uCorrectedValue:Float;
	var uNewValue:Float;
	
	var uEnd:Float;
	var uStart:Float;
	var uNewEnd:Float;
	var uProp:TransitionProps;
	var settingAlpha:Bool;
	
	public function new(target:Target) 
	{
		this.target = target;
	}
	
	public function showEase(ease:IEasing):ITransitionObject
	{
		option.showEase = ease;
		return set(properties, option);
	}
	
	public function hideEase(value:IEasing):ITransitionObject
	{
		option.showEase = value;
		return set(properties, option);
	}
	
	public function autoVisible(value:Bool):ITransitionObject
	{
		option.autoVisible = value;
		UpdateAutoVis();
		return set(properties, option);
	}
	
	public function autoVisObject(value:Dynamic):ITransitionObject
	{
		option.autoVisObject = value;
		UpdateAutoVis();
		return set(properties, option);
	}
	
	public function ease(value:IEasing):ITransitionObject
	{
		option.ease = value;
		return set(properties, option);
	}
	
	public function start(value:Float):ITransitionObject
	{
		option.start = value;
		set(properties, option);
		return this;
	}
	
	public function end(value:Float):ITransitionObject
	{
		option.end = value;
		return set(properties, option);
	}
	
	private function setDefault(option:TransitionSettings):Void
	{
		if (option.ease == null) option.ease = Expo.easeInOut;
		if (option.start == null) option.start = 0;
		if (option.end == null) option.end = 1;
		if (option.startHidden == null) option.startHidden = true;
		if (option.autoVisible == null) option.autoVisible = true;
		if (option.autoVisObject == null) option.autoVisObject = target;
	}
	
	public function set(_properties:Dynamic=null, _option:TransitionSettings=null):ITransitionObject 
	{
		if (_option != null) option = _option;
		setDefault(option);
		if (_properties != null) properties = _properties;
		
		if (_properties == null) {
			option.autoVisible = true;
		}
		
		var propertiesToAddfields = Reflect.fields (_properties);
		for (property in propertiesToAddfields)
		{	
			if (property == "alpha") {
				settingAlpha = true;
			}
			var classType = getClass(Reflect.getProperty(_properties, property));
			if (classType != Array) {
				throw new Error("Incorrect property type: " + classType + ". Expecting Array of length 2, [ShowValue, HideValue]");
				continue;
			}
			var prop:Array<Dynamic> = Reflect.getProperty(_properties, property);
			
			if (Reflect.getProperty(prop, 'length') < 2 || Reflect.getProperty(prop, 'length') > 3) {
				throw new Error("Expecting Array of length 2, [HideValue, ShowValue]\nor or 3 [StartHideValue, ShowValue, EndHideValue]");
				continue;
			}
			
			for (i in 0...prop.length) 
			{
				if (Std.is(prop[i], String)) { 
					var strProp:String = prop[i];
					if (strProp.substr(0, 1) == "-") {
						prop[i] = Reflect.getProperty(target, property) - Std.parseFloat(strProp.substring(1, strProp.length));
					}
					else if (strProp.substr(0, 1) == "+") {
						prop[i] = Reflect.getProperty(target, property) + Std.parseFloat(strProp.substring(1, strProp.length));
					}
					else {
						prop[i] = Reflect.getProperty(target, property) + Std.parseFloat(strProp);
					}
				}	
			}
			
			if (prop.length == 2) {
				prop[2] = prop[0];
			}
			
			var value:Array<Dynamic> = Reflect.getProperty(_properties, property);
			var _hasSetter = hasSetter(target, property);
			var setter:Float -> Void;
			var plugin:Plugin = TransitionPlugins.getPlugin(target, property, option);
			if (_hasSetter){
				var innerSetter:Float->Void = untyped target["set_" + property];
				setter = plugin.setter(target, property, innerSetter, option);
			}else{
				setter = plugin.prop(target, property, option);
			}
			transitionPropsMap.set(property, { value:value, setter:setter } );
		}
		
		UpdateAutoVis();
		
		return cast this;
	}
	
	function UpdateAutoVis() 
	{
		try {
			visSetter = untyped option.autoVisObject["set_visible"];
		} catch ( e : Dynamic ) try {
			visSetter = function(value:Bool):Bool { return option.autoVisObject.visible = value; };
		}
		catch ( e : Dynamic ) try {
			visSetter = function(value:Bool):Bool { return value; };
		}
	}
	
	function hasSetter(obj:Dynamic, value:String):Bool /*untyped*/
	{
		#if air
		return Reflect.hasField(obj, "set_" + value);
		#else
		try {
			untyped obj["set_" + value];
			return true;
		} catch( e : Dynamic ) try {
			return false;
		}
		#end
	}
	
	private function getClass(obj:Dynamic):Class<Dynamic> {
		return Type.getClass(obj);
	}
	
	public function remove(propertiesToRemove:Dynamic):Void 
	{
		var fields = Reflect.fields(propertiesToRemove);
		for (property in fields) {
			
			transitionPropsMap.remove(property);
		}
	}
	
	public function dispose():Void 
	{
		target = null;
		transitionPropsMap = null;
		visSetter = null;
		uProp = null;
		onSet.removeAll();
	}
	
	public function update(value:Float):Void 
	{
		if (this.value == value) return;
		
		this.value = value;
		uEnd = option.end;
		uStart = option.start;
		if (value > 0) {
			uNewEnd = 1 - uStart;
			uStart = 1 - uEnd;
			uEnd = uNewEnd;
		}
		
		for (key in transitionPropsMap.keys())
		{
			uProp = transitionPropsMap.get(key);
			
			if (value < 0) {
				uStartValue = uProp.value[0];
				uEndValue = uProp.value[1];
				uNewValue = value + 1;
			}
			else {
				uStartValue = uProp.value[1];
				uEndValue = uProp.value[2];
				uNewValue = value;
			}
			
			
			
			uCorrectedValue = uNewValue / (uEnd - uStart);
			uCorrectedValue -= uStart / (uEnd - uStart);
			if (uCorrectedValue < 0) uCorrectedValue = 0;
			if (uCorrectedValue > 1) uCorrectedValue = 1;
			
			uShowEase = option.showEase;
			uHideEase = option.hideEase;
			if (uShowEase == null) uShowEase = option.ease;
			if (uHideEase == null) uHideEase = option.ease;
			
			if (transitingIn) uCorrectedValue = uShowEase.calculate(uCorrectedValue);
			else uCorrectedValue = uHideEase.calculate(uCorrectedValue);
			
			if (uCorrectedValue < 0) uCorrectedValue = 0;
			if (uCorrectedValue > 1) uCorrectedValue = 1;
			
			var value = uStartValue + ((uEndValue - uStartValue) * uCorrectedValue);
			
			#if air
				uProp.setter(value);
			#else
				Reflect.setProperty(target, key, value);
			#end
		}
		
		if (option.autoVisible && settingAlpha) {
			if (value <= -1 || value >= 1) {
				#if html5
					if (visSetter != null) {
						untyped visSetter.call(option.autoVisObject, false);
					}
				#else
					visSetter(false);
				#end
			}
			else {
				#if html5
					if (visSetter != null) {
						untyped visSetter.call(option.autoVisObject, true);
					}
				#else
					visSetter(true);
				#end
			}
		}
	}
	
	public function showBegin():Void 
	{
		transitingIn = true;
	}
	
	public function showEnd():Void 
	{
		
	}
	
	public function hideBegin():Void 
	{
		transitingIn = false;
	}
	
	public function hideEnd():Void 
	{
		
	}
}

typedef Frame =
{
	var x:Float;
	var y:Float;
	var width:Float;
	var height:Float;
}

typedef Target =
{
	?visible:Bool
}

typedef TransitionProps =
{
	value:Array<Dynamic>,
	setter:Float->Void
}