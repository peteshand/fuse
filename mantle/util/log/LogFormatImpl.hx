package mantle.util.log;
import mantle.util.log.Log.LogLevel;

/**
 * ...
 * @author Thomas Byrne
 */
class LogFormatImpl
{
	static private var padList:Array<String> = [];

	
	public static function cleanFormat(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):String
	{
		return getType(source)+" " + rest.join(" ");
	}

	
	public static function format(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):String
	{
		var msg:String;
		switch(level) {
			case LogLevel.INFO:
				msg = "INF: ";
				
			case LogLevel.WARN:
				msg = "WRN: ";
				
			case LogLevel.ERROR:
				msg = "ERR: ";
				
			case LogLevel.CRITICAL_ERROR:
				msg = "CRT: ";
				
			case LogLevel.UNCAUGHT_ERROR:
				msg = "UNC: ";
				
			default: // | LogLevel.LOG:
				msg = "LOG: ";
		}
		return msg + getType(source)+" " + rest.join(" ");
	}
	
	public static function htmlFormat(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):String
	{
		var color:String;
		switch(level) {
			case LogLevel.INFO:
				color = "444";
				
			case LogLevel.WARN:
				color = "e59400";
				
			case LogLevel.ERROR:
				color = "f00";
				
			case LogLevel.CRITICAL_ERROR:
				color = "f00";
				
			case LogLevel.UNCAUGHT_ERROR:
				color = "d00";
				
			default: // | LogLevel.LOG:
				color = "000";
		}
		var timestamp:String = padNum(time.getHours(), 2) + ":" + padNum(time.getMinutes(), 2) + ":" + padNum(time.getSeconds(), 2);
		var content = StringTools.htmlEscape(rest.join(" "));
		var msg:String = '<div style="color:#fff;background:#'+color+';min-width: 350px;display:inline-block;">'+timestamp+" "+getType(source)+"</div> " + content;
		msg = msg.split("\n").join("<br/>");
		msg = msg.split("\t").join("&nbsp;&nbsp;&nbsp;&nbsp;");
		return "<div><code style='font-size:12px;white-space:pre;color:#"+color+"'>" + msg + "</code></div>";
	}
	
	public static function flashHtmlFormat(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):String
	{
		var color:String;
		switch(level) {
			case LogLevel.INFO:
				color = "777777";
				
			case LogLevel.WARN:
				color = "e59400";
				
			case LogLevel.ERROR:
				color = "ff0000";
				
			case LogLevel.CRITICAL_ERROR:
				color = "ff0000";
				
			case LogLevel.UNCAUGHT_ERROR:
				color = "dd0000";
				
			default: // | LogLevel.LOG:
				color = "000000";
		}
		var timestamp:String = padNum(time.getHours(), 2) + ":" + padNum(time.getMinutes(), 2) + ":" + padNum(time.getSeconds(), 2);
		var msg:String = '<font color="#555555">'+timestamp+" "+getType(source)+"</font> " + StringTools.htmlEscape(rest.join(" "));
		msg = msg.split("\n").join("<br/>");
		msg = msg.split("\t").join("&nbsp;&nbsp;&nbsp;&nbsp;");
		return "<font color='#"+color+"'>" + msg + "</font>";
	}
	
	static private function padNum(num:Int, length:Int):String 
	{
		var ret:String = Std.string(num);
		while (ret.length < length) ret = "0" + ret;
		return ret;
	}
	static private function padStr(str:String, length:Int):String 
	{
		// This is optimised because string appending loop triggers garbage collection, better to cache the amount of spaces needed.
		var short = length - str.length;
		if (short <= 0) return str;
		
		short--;
		if (padList[short] == null){
			var pad:String = " ";
			var count = short;
			while (count > 0){
				pad = pad + " ";
				count--;
			}
			padList[short] = pad;
		}
		return str + padList[short];
	}
	
	public static function fdFormat(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):String
	{
		var colorCode:String;
		switch(level) {
			case LogLevel.INFO:
				colorCode = "0:";
				
			case LogLevel.WARN:
				colorCode = "2:";
				
			case LogLevel.ERROR:
				colorCode = "3:";
				
			case LogLevel.CRITICAL_ERROR:
				colorCode = "3";
				
			case LogLevel.UNCAUGHT_ERROR:
				colorCode = "4:";
				
			default: // | LogLevel.LOG:
				colorCode = "1:";
		}
		
		var msg = rest.join(" ");
		msg = msg.split("\n").join("\n"+colorCode);
		return colorCode + padStr(getType(source), 35)+" " + msg;
	}
	
	public static function getType(source:Dynamic):String
	{
		if (Std.is(source, String)) {
			return source;
		}else if (Std.is(source, Class)) {
			return getClassName(Type.getClassName(source));
		}else{
			var type = Type.getClass(source);
			if (type != null) {
				return getClassName(Type.getClassName(type));
			}else {
				return source.toString();
			}
		}
	}
	
	static private function getClassName(classPath:String) : String
	{
		var lastDot:Int = classPath.lastIndexOf(".");
		if (lastDot == -1) return classPath;
		
		return classPath.substr(lastDot + 1);
	}
		
	
}