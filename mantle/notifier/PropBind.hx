package mantle.notifier;
import msignal.Signal.Signal0;

using Logger;
/**
 * ...
 * @author Thomas Byrne
 */
class PropBind
{
	
	@:isVar public var source(default, set):Dynamic;
	function set_source(value:Dynamic):Dynamic 
	{
		if (source == value) return value;
		unbindSource();
		source = value;
		bindSource();
		return value;
	}
	
	@:isVar public var sourceProp(default, set):String;
	function set_sourceProp(value:String):String 
	{
		if (sourceProp == value) return value;
		unbindSource();
		sourceProp = value;
		bindSource();
		return value;
	}
	
	@:isVar public var sourceSignal(default, set):Signal0;
	function set_sourceSignal(value:Signal0):Signal0 
	{
		if (sourceSignal == value) return value;
		unbindSource();
		sourceSignal = value;
		bindSource();
		return value;
	}
	
	var sourceBound:Bool;
	var boundSignal:Signal0;
	var targets:Map<String, Array<Dynamic>>;

	public function new(?source:Dynamic, ?sourceProp:String, ?sourceSignal:Signal0) 
	{
		targets = new Map();
		this.source = source;
		this.sourceProp = sourceProp;
		this.sourceSignal = sourceSignal;
	}
	
	public function add(target:Dynamic, targetProp:String) : PropBind
	{
		var list = targets.get(targetProp);
		if (list == null){
			list = [target];
			targets.set(targetProp, list);
		}else if (list.indexOf(target) !=-1){
			return this;
		}else{
			list.push(target);
		}
		return this;
	}
	
	public function remove(target:Dynamic, targetProp:String)  : PropBind
	{
		var list = targets.get(targetProp);
		if (list != null){
			list.remove(target);
			if (list.length == 0){
				targets.remove(targetProp);
			}
		}
		return this;
	}
	
	
	function unbindSource() 
	{
		if (!sourceBound) return;
		
		sourceBound = false;
		boundSignal.remove(onSourceChange);
		boundSignal = null;
	}
	
	
	function bindSource() 
	{
		if (sourceBound) return;
		if (source == null || sourceProp == null || sourceSignal == null) return;
		
		sourceBound = true;
		boundSignal = sourceSignal;
		boundSignal.add(onSourceChange);
		onSourceChange();
	}
	
	function onSourceChange() 
	{
		var value:Dynamic;
		try{
			value = Reflect.getProperty(source, sourceProp);
		}catch (e:Dynamic){
			warn("Error thrown in getter for binding " + sourceProp + " on object " + source);
			return;
		}
		for (prop in targets.keys()){
			var list = targets.get(prop);
			for(target in list){
				try{
					Reflect.setProperty(target, prop, value);
				}catch (e:Dynamic){
					warn("Error thrown in setter for binding " + prop + " on object " + target);
				}
			}
		}
	}
	
}
