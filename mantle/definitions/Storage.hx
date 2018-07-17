package mantle.definitions;
import mantle.util.app.App;
import mantle.util.fs.File;

/**
 * ...
 * @author P.J.Shand
 */
class Storage
{
	@:isVar public static var configSeedDirectory(default, null):File;
	
	@:isVar public static var appStorageDir(default, null):File;
	
	@:isVar public static var appDirectory(default, null):File;
	@:isVar public static var configDirectory(default, null):File;
	@:isVar public static var logDirectory(default, null):File;
	@:isVar public static var errorLogDirectory(default, null):File;
	
	public function new() 
	{
		
	}
	
	public static function __init__():Void
	{
		#if flash
			configSeedDirectory = File.applicationDirectory.resolvePath("config");
			
			appStorageDir = File.documentsDirectory.resolvePath(".appStorage");
			if (!appStorageDir.exists) appStorageDir.createDirectory();
			
			appDirectory = appStorageDir.resolvePath(App.getAppId());
			if (!appDirectory.exists) appDirectory.createDirectory();
			
			configDirectory = appDirectory.resolvePath("config");
			if (!configDirectory.exists) configDirectory.createDirectory();
			
			logDirectory = appDirectory.resolvePath("log");
			if (!logDirectory.exists) logDirectory.createDirectory();
			
			errorLogDirectory = appDirectory.resolvePath("errorLog");
			if (!errorLogDirectory.exists) errorLogDirectory.createDirectory();
		#end
	}
}