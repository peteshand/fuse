package mantle.util.log.cli;
import mantle.util.log.Log;
import mantle.cli.utils.CmdTools;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.ILogHandler;
import mantle.util.log.LogFormatImpl;
import mantle.util.log.LogFormatter;

/**
 * ...
 * @author Thomas Byrne
 */
@:access(mantle.util.log.LogFormatImpl)
class EchoLogger implements ILogHandler
{
	static private var checked:Bool;
	static private var hasColorCmd:Bool;
	static function setup() 
	{
		if (checked) return;
		checked = true;
		#if cpp
		hasColorCmd = CmdTools.hasCmd("cmdcolor");
		#else
		hasColorCmd = false;
		#end
	}
	
	static function defaultEchoFormatter(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date) 
	{
		var content = rest.join(" ");
		var sourceStr = LogFormatImpl.padStr(LogFormatImpl.getType(source), 25);
		var msg = rest.join(" ");
		msg = msg.split("&").join("^&");
		if(hasColorCmd){
			var textColor:TextColor;
			var bgColor:BgColor;
			switch(level) {
				case LogLevel.INFO:
					textColor = LightGray;
					bgColor = DarkGray;
					
				case LogLevel.WARN:
					textColor = LightYellow;
					bgColor = Yellow;
					
				case LogLevel.ERROR:
					textColor = LightRed;
					bgColor = Red;
					
				case LogLevel.UNCAUGHT_ERROR:
					textColor = LightRed;
					bgColor = Black;
					
				default: // | LogLevel.LOG:
					textColor = White;
					bgColor = Black;
			}
			return "echo \\033[" + textColor + ";" + bgColor + "m " + sourceStr + " \\033[0m " + msg + " | cmdcolor";
		}else{
			return "echo " + sourceStr+" "+ msg;
		}
	}
	
	public var formatter:LogFormatter;
	
	public function new(formatter:LogFormatter=null):Void
	{
		setup();
		this.formatter = (formatter == null ? defaultEchoFormatter : formatter);
	}
	
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void 
	{
		Sys.command(formatter(source, level, rest, time));
	}
}

@:enum
abstract TextColor(String) to String {
	public var Default = "39";
	public var Black = "30";
	public var Red = "31";
	public var Green = "32";
	public var Yellow = "33";
	public var Blue = "34";
	public var Magenta = "35";
	public var Cyan = "36";
	public var LightGray = "37";
	public var DarkGray = "90";
	public var LightRed = "91";
	public var LightGreen = "92";
	public var LightYellow = "93";
	public var LightBlue = "94";
	public var LightMagenta = "95";
	public var LightCyan = "96";
	public var White = "97";
}
@:enum
abstract BgColor(String) to String {
	public var Default = "49";
	public var Black = "40";
	public var Red = "41";
	public var Green = "42";
	public var Yellow = "43";
	public var Blue = "44";
	public var Magenta = "45";
	public var Cyan = "46";
	public var LightGray = "47";
	public var DarkGray = "100";
	public var LightRed = "101";
	public var LightGreen = "102";
	public var LightYellow = "103";
	public var LightBlue = "104";
	public var LightMagenta = "105";
	public var LightCyan = "106";
	public var White = "107";
}