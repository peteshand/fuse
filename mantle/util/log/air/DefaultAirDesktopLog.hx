package mantle.util.log.air;
import mantle.util.log.Log;
import mantle.delay.Delay;
import mantle.util.app.App;
import mantle.util.fs.Files;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.customTrace.CustomTrace;
import flash.display.DisplayObject;
import flash.errors.Error;
import flash.events.UncaughtErrorEvent;
import flash.system.Capabilities;
import mantle.util.log.LogFormatImpl;
import mantle.util.log.MassErrorQuitLogger;
import mantle.util.log.MethodCallLogger;
import mantle.util.log.TraceLogger;

/**
 * ...
 * @author Thomas Byrne
 */
class DefaultAirDesktopLog
{
	private static var installed:Bool;
	public static var criticalErrorCodes:Array<Int> = [
					3691 // Resource limit exceeded
					];
					
	private static var restartRequested:Bool;
	
	public static function install(root:DisplayObject, ?restartApp:Void->Void):Void
	{
		if (installed) return;
		installed = true;
		
		var docsDir:String  = Files.appDocsDir();
		
		// Must be runtime conditional because of SWC packaging
		//if(Capabilities.isDebugger){
			Log.mapHandler(new TraceLogger(LogFormatImpl.fdFormat), Log.ALL_LEVELS);
		//}
		
		Log.mapHandler(new HtmlFileLogger(docsDir + "log" + Files.slash(), true), Log.ALL_LEVELS);
		
		Log.mapHandler(new HtmlFileLogger(docsDir + "errorLog" + Files.slash(), false), [LogLevel.UNCAUGHT_ERROR, LogLevel.ERROR, LogLevel.CRITICAL_ERROR]);
		
		Log.mapHandler(new HtmlFileLogger(docsDir + "errorLog" + Files.slash(), false), [LogLevel.CRITICAL_ERROR]);
		
		Log.mapHandler(new MassErrorQuitLogger(), [LogLevel.UNCAUGHT_ERROR, LogLevel.CRITICAL_ERROR]);
		
		if(restartApp != null) Log.mapHandler(new MethodCallLogger(restartApp), [LogLevel.CRITICAL_ERROR]);
		
		root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError.bind(_, restartApp));
		
		CustomTrace.install();
	}
	
	public static function installIdmLog():Void
	{
		var docsDir:String  = Files.appDocsDir();
		var jsonLogger:SimpleJsonLogger = new SimpleJsonLogger(docsDir + "idm/log", false);
		Log.mapHandler(jsonLogger, [LogLevel.UNCAUGHT_ERROR, LogLevel.ERROR, LogLevel.CRITICAL_ERROR]);
	}
	
	private static function onUncaughtError(e:UncaughtErrorEvent, ?restartApp:Void->Void):Void 
	{
		var message:String;
		if (Reflect.hasField(e.error, "message"))
		{
			message = Reflect.field(e.error, "message");
		}
		else if (Reflect.hasField(e.error, "text"))
		{
			message = Reflect.field(e.error, "text");
		}
		else
		{
			message = Std.string(e.error);
		}
		var err:Error = cast(e.error);
		if (err != null) {
			Log.log(e.target, LogLevel.UNCAUGHT_ERROR, [criticalErrorCodes.indexOf(err.errorID), "\n"+err.getStackTrace()]);
			
			if (!restartRequested && restartApp!=null && criticalErrorCodes.indexOf(err.errorID) != -1){
				Logger.error(e.target, "Critical error "+err.errorID+" caught, attempting restart");
				Delay.byFrames(1, restartApp);
				restartRequested = true;
			}
		}else {
			Logger.error(e.target, message);
		}
		e.preventDefault();
		
	}
	
}