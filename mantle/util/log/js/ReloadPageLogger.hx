package mantle.util.log.js;
import mantle.util.log.Log;

import mantle.util.log.ILogHandler;
import mantle.util.log.Log.LogLevel;

/**
 * Reloads the page when a certain log level happens.
 * 
 * @author Thomas Byrne
 */
class ReloadPageLogger implements ILogHandler
{

	public function new() 
	{
		
	}
	
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void 
	{
		js.Browser.location.reload();
	}
	
}