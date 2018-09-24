package mantle.definitions;
import mantle.util.app.App;
import mantle.filesystem.File;

/**
 * ...
 * @author P.J.Shand
 */
class Storage
{
	@:isVar public static var configSeedDirectory(get, null):File;
	@:isVar public static var storageRootDir(get, null):File;
	@:isVar public static var appStorageDir(get, null):File;
	@:isVar public static var configDirectory(get, null):File;
	@:isVar public static var logDirectory(get, null):File;
	@:isVar public static var errorLogDirectory(get, null):File;
	static var appId:String;

	static function get_configSeedDirectory():File { init(); return configSeedDirectory; }
	static function get_storageRootDir():File { init(); return storageRootDir; }
	static function get_appStorageDir():File { init(); return appStorageDir; }
	static function get_configDirectory():File { init(); return configDirectory; }
	static function get_logDirectory():File { init(); return logDirectory; }
	static function get_errorLogDirectory():File { init(); return errorLogDirectory; }
	
	static function init():Void
	{
		if (appId != null) return;
		appId = App.getAppId();

		//#if air
		trace("app id = " + App.getAppId());
			configSeedDirectory = File.applicationDirectory.resolvePath("config");
			
			storageRootDir = File.documentsDirectory.resolvePath(".appStorage");
			if (!storageRootDir.exists) storageRootDir.createDirectory();
			
			appStorageDir = storageRootDir.resolvePath(appId);
			if (!appStorageDir.exists) appStorageDir.createDirectory();
			
			configDirectory = appStorageDir.resolvePath("config");
			if (!configDirectory.exists) configDirectory.createDirectory();
			
			logDirectory = appStorageDir.resolvePath("log");
			if (!logDirectory.exists) logDirectory.createDirectory();
			
			errorLogDirectory = appStorageDir.resolvePath("errorLog");
			if (!errorLogDirectory.exists) errorLogDirectory.createDirectory();
		//#end
	}
}