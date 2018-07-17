package mantle.util.log;
import mantle.util.log.Log.LogLevel;

/**
 * @author Thomas Byrne
 */

interface ILogHandler 
{
	function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void;
}