package fuse.utils;

import fuse.filesystem.File;
import fuse.info.AppInfo;

/**
 * ...
 * @author P.J.Shand
 */
class Storage
{
	@:isVar public static var configSeedDirectory(default, null):File;
	
	@:isVar public static var fuseDirectory(default, null):File;
	@:isVar public static var globalDirectory(default, null):File;
	@:isVar public static var globalConfigDirectory(default, null):File;
	
	@:isVar public static var appDirectory(default, null):File;
	@:isVar public static var configDirectory(default, null):File;
	@:isVar public static var logDirectory(default, null):File;
	@:isVar public static var errorLogDirectory(default, null):File;
	
	public function new() 
	{
		
	}
	
	public static function __init__():Void
	{
		#if air
			configSeedDirectory = File.applicationDirectory.resolvePath("config");
			
			fuseDirectory = File.documentsDirectory.resolvePath("fuse");
			if (!fuseDirectory.exists) fuseDirectory.createDirectory();
			
			globalDirectory = fuseDirectory.resolvePath("global");
			if (!globalDirectory.exists) globalDirectory.createDirectory();
			
			globalConfigDirectory = globalDirectory.resolvePath("config");
			if (!globalConfigDirectory.exists) globalConfigDirectory.createDirectory();
			
			appDirectory = fuseDirectory.resolvePath(AppInfo.appId);
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