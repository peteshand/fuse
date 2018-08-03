package;
import mantle.util.log.Log;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;

/**
 * Use the Log functions by adding:
 * 
 * using Logger;
 * 
 * to the top of your class.
 * 
 * Then these should work:
 * 
 * log("message");
 * warn("message");
 * error("message");
 * 
 * @author Thomas Byrne
 */
class Logger
{
	public static function info(source:Dynamic, rest1:Dynamic, ?rest2:Dynamic, ?rest3:Dynamic, ?rest4:Dynamic, ?rest5:Dynamic, ?rest6:Dynamic, ?rest7:Dynamic, ?rest8:Dynamic, ?pos:PosInfos):Void
	{
		Log.log(source, LogLevel.INFO, getArgs(rest1, rest2, rest3, rest4, rest5, rest6, rest7, rest8), pos);
	}
	public static function log(source:Dynamic, rest1:Dynamic, ?rest2:Dynamic, ?rest3:Dynamic, ?rest4:Dynamic, ?rest5:Dynamic, ?rest6:Dynamic, ?rest7:Dynamic, ?rest8:Dynamic, ?pos:PosInfos):Void
	{
		Log.log(source, LogLevel.LOG, getArgs(rest1, rest2, rest3, rest4, rest5, rest6, rest7, rest8), pos);
	}
	public static function warn(source:Dynamic, rest1:Dynamic, ?rest2:Dynamic, ?rest3:Dynamic, ?rest4:Dynamic, ?rest5:Dynamic, ?rest6:Dynamic, ?rest7:Dynamic, ?rest8:Dynamic, ?pos:PosInfos):Void
	{
		Log.log(source, LogLevel.WARN, getArgs(rest1, rest2, rest3, rest4, rest5, rest6, rest7, rest8), pos);
	}
	public static function error(source:Dynamic, rest1:Dynamic, ?rest2:Dynamic, ?rest3:Dynamic, ?rest4:Dynamic, ?rest5:Dynamic, ?rest6:Dynamic, ?rest7:Dynamic, ?rest8:Dynamic, ?pos:PosInfos):Void
	{
		Log.log(source, LogLevel.ERROR, getArgs(rest1, rest2, rest3, rest4, rest5, rest6, rest7, rest8), pos);
	}
	public static function criticalError(source:Dynamic, rest1:Dynamic, ?rest2:Dynamic, ?rest3:Dynamic, ?rest4:Dynamic, ?rest5:Dynamic, ?rest6:Dynamic, ?rest7:Dynamic, ?rest8:Dynamic, ?pos:PosInfos):Void
	{
		Log.log(source, LogLevel.CRITICAL_ERROR, getArgs(rest1, rest2, rest3, rest4, rest5, rest6, rest7, rest8), pos);
	}
	
	@:inline
	static private function getArgs(rest1:Dynamic, rest2:Dynamic, rest3:Dynamic, rest4:Dynamic, rest5:Dynamic, rest6:Dynamic, rest7:Dynamic, rest8:Dynamic) :Array<Dynamic>
	{
		var args:Array<Dynamic> = [rest1];
		if (rest2 != null) {
			args.push(rest2);
			if (rest3 != null) {
				args.push(rest3);
				if (rest4 != null) {
					args.push(rest4);
					if (rest5 != null) {
						args.push(rest5);
						if (rest6 != null) {
							args.push(rest6);
							if (rest7 != null) {
								args.push(rest7);
								if (rest8 != null) {
									args.push(rest8);
								}
							}
						}
					}
				}
			}
		}
		return args;
	}
	
}