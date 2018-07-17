package mantle.util.log;
import mantle.util.log.Log.LogLevel;

/**
 * Used to call a method every time a certain log is fired.
 * 
 * @author Thomas Byrne
 */
class MethodCallLogger implements ILogHandler
{
	var method:Void->Void;

	public function new(method:Void->Void) 
	{
		this.method = method;
	}
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void
	{
		method();
	}
}