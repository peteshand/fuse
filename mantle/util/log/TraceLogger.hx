package mantle.util.log;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.LogFormatter;

/**
 * ...
 * @author Thomas Byrne
 */
class TraceLogger implements ILogHandler 
{
	public var formatter:LogFormatter;
	
	public function new(formatter:LogFormatter=null) 
	{
		if (formatter == null) {
			this.formatter = LogFormatImpl.format;
		}else {
			this.formatter = formatter;
		}
	}
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void {
		#if flash
			// Avoids TextField overlay
			flash.Lib.trace(formatter(source, level, rest, time));
			
		#elseif html5
			switch(level) {
				case LogLevel.INFO:
					js.Browser.window.console.info(formatter(source, level, rest, time));
					
				case LogLevel.LOG:
					js.Browser.window.console.log(formatter(source, level, rest, time));
					
				case LogLevel.WARN:
					js.Browser.window.console.warn(formatter(source, level, rest, time));
					
				case LogLevel.UNCAUGHT_ERROR | LogLevel.ERROR | LogLevel.CRITICAL_ERROR:
					js.Browser.window.console.error(formatter(source, level, rest, time));
			}
		#else
			trace(formatter(source, level, rest, time));
		#end
	}

}