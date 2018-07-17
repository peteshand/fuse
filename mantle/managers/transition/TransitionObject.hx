package mantle.managers.transition;

import mantle.managers.transition.TransitionObject.Target;
import mantle.managers.transition.TransitionSettings;
//import mantle.managers.transition.plugins.TransitionPlugins;
//import mantle.managers.transition.plugins.TransitionPlugins.Plugin;
import motion.easing.Expo;
import motion.easing.IEasing;
import motion.easing.Quad;
import msignal.Signal.Signal0;

using Logger;

#if swc
	import flash.errors.Error;
#else
	import openfl.errors.Error;
#end


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
	var visSetter:Dynamic;
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
	
	//public function autoVisible(value:Bool):ITransitionObject
	//{
		//option.autoVisible = value;
		//UpdateAutoVis();
		//return set(properties, option);
	//}
	
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
		//if (option.autoVisible == null) option.autoVisible = false;
		if (option.autoVisObject == null) option.autoVisObject = target;
	}
	
	public function set(_properties:Dynamic=null, _option:TransitionSettings=null):ITransitionObject 
	{
		if (_option != null) option = _option;
		setDefault(option);
		if (_properties != null) properties = _properties;
		
		//if (_properties == null) {
			//option.autoVisible = true;
		//}
		
		var propertiesToAddfields = Reflect.fields (_properties);
		for (property in propertiesToAddfields)
		{	
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
			//var plugin:Plugin = TransitionPlugins.getPlugin(property);
			if (_hasSetter){
				var innerSetter:Float->Void = untyped target["set_" + property];
				setter = getSetter(target, property, innerSetter, option);
			}else{
				setter = getProp(target, property, option);
			}
			transitionPropsMap.set(property, { value:value, setter:setter } );
			
		}
		
		UpdateAutoVis();
		
		return cast this;
	}
	
	function UpdateAutoVis() 
	{
		var _hasSetter = hasSetter(option.autoVisObject, "visible");
		if (_hasSetter){
			var innerSetter:Bool->Void = untyped target["set_visible"];
			visSetter = getSetter(target, "visible", innerSetter, option);
		}else {
			var hasProp:Bool = hasSetter(option.autoVisObject, "visible", "");
			if (hasProp){
				visSetter = getProp(target, "visible", option);
			}
		}
	}
	
	function hasSetter(obj:Dynamic, value:String, prefix:String="set_"):Bool
	{
		#if flash
		return Reflect.hasField(obj, prefix + value);
		#else
		try {
			untyped obj[prefix + value];
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
				if (uProp.value[2] == null) continue;
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
			
			#if flash
				uProp.setter(value);
			#else
				Reflect.setProperty(target, key, value);
			#end
			
			if (visSetter != null && key == "alpha") {
				if (value == 0) {
					visSetter(false);
				}
				else {
					visSetter(true);
				}
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
	
	
	
	
	
	
	
	
	public function getProp(target:Dynamic, prop:String, option:TransitionSettings) : Dynamic->Void
	{
		return applyProp.bind(target, prop, _);
	}
	public function getSetter(target:Dynamic, prop:String, innerSetter:Dynamic->Void, option:TransitionSettings) : Dynamic->Void
	{
		return applySetter.bind(target, innerSetter, _);
	}
	
	public function applyProp(target:Dynamic, prop:String, value:Dynamic) 
	{
		untyped target[prop] = value;
	}
	
	public function applySetter(target:Dynamic, innerSetter:Dynamic->Void, value:Dynamic) 
	{
		#if !js
			innerSetter(value);
		#else
			untyped innerSetter.call(target, Math.round(value));
		#end
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