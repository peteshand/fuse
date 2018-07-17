package mantle.util.log.cli;
import mantle.util.log.Log;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.customTrace.CustomTrace;

/**
 * ...
 * @author Thomas Byrne
 */
class DefaultCliLog
{
	private static var installed:Bool;
	
	public static function install():Void
	{
		if (installed) return;
		installed = true;
		
		Log.mapHandler(new EchoLogger(), Log.ALL_LEVELS);
		
		//CustomTrace.install();
	}
	
}