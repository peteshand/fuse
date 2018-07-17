package mantle.util.log;

#if !macro
	import mantle.time.GlobalTime;
#end

import haxe.PosInfos;

/**
 * ...
 * @author Thomas Byrne
 */
class Log
{
	static public var ALL_LEVELS:Array<String> = [LogLevel.INFO, LogLevel.LOG, LogLevel.WARN, LogLevel.ERROR, LogLevel.CRITICAL_ERROR, LogLevel.UNCAUGHT_ERROR];
	
	private static var handlers:Map<String, Array<ILogHandler>>;

	/**
	 * Set exclusiveSource to an object to ignore any log events from other objects.
	 */
	static public var exclusiveSource:Dynamic;
	
	static private function setup():Void 
	{
		if (handlers!=null) return;
		
		handlers = new Map();
	}
	
	
	public static function log(source:Dynamic, level:String, rest:Array<Dynamic>, ?pos:PosInfos):Void {
		if (handlers==null) return;
		
		if (exclusiveSource != null && exclusiveSource != source) return;
		else if (Reflect.hasField(source, "verbose")) {
			try {
				if (Reflect.field(source, "verbose") == false) {
					return;
				}
			}catch (e:Dynamic) {}
		}
		
		var params:Array<Dynamic> = [source, level];
		params = params.concat(rest);
		
		#if macro
			var time:Date = Date.now();
		#else
			var time:Date = GlobalTime.now();
		#end
		
		var handlerList:Array<ILogHandler> = handlers.get(level);
		for(logger in handlerList) {
			logger.log(source, level, rest, time);
		}
	}
	
	public static function mapHandler(handler:ILogHandler, levels:Array<String>):Void {
		setup();
		
		for(level in levels){
			mapHandlerToLevel(handler, level);
		}
	}
	
	static private function mapHandlerToLevel(handler:ILogHandler, level:String):Void 
	{
		var list:Array<ILogHandler> = handlers.get(level);
		if (list == null){
			list = [handler];
			handlers.set(level, list);
		}else{
			list.push(handler);
		}
	}
	
}

@:enum
abstract LogLevel(String) to String {
	var INFO = "info";
	var LOG = "log";
	var WARN = "warn";
	var ERROR = "error";
	var CRITICAL_ERROR = "criticalError";
	var UNCAUGHT_ERROR = "uncaughtError";
}