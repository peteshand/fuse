package mantle.util.log.js;
import mantle.util.log.Log;
import mantle.util.app.App;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.customTrace.CustomTrace;
import mantle.util.log.LogFormatImpl;
import mantle.util.log.TraceLogger;

/**
 * ...
 * @author Thomas Byrne
 */
class DefaultJsLog
{
	public static function install():Void
	{
		
		Log.mapHandler(new TraceLogger(LogFormatImpl.cleanFormat), Log.ALL_LEVELS);
		
		Log.mapHandler(new ReloadPageLogger(), [LogLevel.CRITICAL_ERROR]);
		
		CustomTrace.install();
	}
	
}