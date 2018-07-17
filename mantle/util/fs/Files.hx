package mantle.util.fs;
import mantle.util.app.App;
import mantle.util.app.Platform;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas Byrne
 */

#if !html5
class Files
{
	static var tempFile:File = new File();
	
	public static inline function slash():String 
	{
		if (Platform.isWindows()) {
			return "\\";
		}else {
			return "/";
		}
	}
	public static inline function ensure(path:String):String 
	{
		if (Platform.isWindows()) {
			return path.split("/").join("\\");
		}else {
			return path;
		}
	}
	
	public static function documentsDir():String 
	{
		return File.documentsDirectory.nativePath + slash();
	}
	
	public static function imagDocsDir():String 
	{
		return documentsDir() + "imagination" + slash();
	}
	
	public static function applicationDir():String 
	{
		return File.applicationDirectory.nativePath + slash();
	}

	public static function appDocsDir(?appId:String):String 
	{
		
		#if sys
		
		var path:String = Sys.executablePath();
		var ind = path.lastIndexOf(slash());
		return path.substr(0, ind + 1);
		
		#elseif air
		
		if (appId == null) appId = App.getAppId();
		return imagDocsDir() + appId + slash();
		
		#end
	}
	
	static var resourcePath:String;
	static var resourcePathSuffix:String;
	public static function setResourceSuffix(value:String):Void 
	{
		resourcePathSuffix = value;
		resourcePath = null;
	}
	public static function resourcesDir(?appId:String):String 
	{
		if (resourcePath != null) return resourcePath;
		if (appId == null) appId = App.getAppId();
		resourcePath = imagDocsDir() + appId + (resourcePathSuffix==null ? "" : resourcePathSuffix) + "+resources" + slash();
		return resourcePath;
	}
	public static function resourceUri(resource:String):String 
	{
		return resourcesDir() + resource;
	}

	public static function getTempFilePath():String 
	{
		#if sys
		var ret:String = null;
		while (ret==null || sys.FileSystem.exists(ret)) {
			ret = appDocsDir() + "temp_" + (Math.random() * 10000000) + ".tmp";
		}
		return ret;
		
		#elseif air
		
		return File.createTempFile().nativePath;
		
		#end
	}

	public static function getSelfExePath():String 
	{
		#if sys
		return Sys.executablePath();
		#elseif air
		if(Platform.isWindows()){
			return File.applicationDirectory.nativePath + slash() + App.getAppFilename() + ".exe";
		}else {
			return File.applicationDirectory.nativePath + slash() + App.getAppFilename();
		}
		#end
	}
	
	public static function getUserDir():String 
	{
		#if air
		return File.userDirectory.nativePath;
		#end
	}
	
	public static function findInstalled(appPath:String) : String
	{
		if(Platform.isWindows()){
			tempFile.nativePath = ("C:\\Program Files (x86)\\" + appPath);
			if (!tempFile.exists) {
				tempFile.nativePath = ("C:\\Program Files\\" + appPath);
			}
		}else{
			tempFile.nativePath = ("/Applications/"+appPath);
		}
		return tempFile.nativePath;
	}
	
	static public function getFileName(path:String) : String
	{
		return path.substr(path.lastIndexOf(slash()) + 1);
	}
	
	static public function pathToUri(path:String) : String
	{
		tempFile.nativePath = path;
		return tempFile.url;
	}
	
	static public function getIcon(value:String) : Null<BitmapData>
	{
		#if air
		var file = new File(value);
		return file.icon == null ? null : file.icon.bitmaps[0];
		#else
		return null;
		#end
	}
	
}
#else
class Files
{
	public static inline function slash():String 
	{
		if (Platform.isWindows()) {
			return "\\";
		}else {
			return "/";
		}
	}
	public static inline function ensure(path:String):String 
	{
		if (Platform.isWindows()) {
			return path.split("/").join("\\");
		}else {
			return path;
		}
	}
	
	static var resourceLocation:String;
	public static function setResourceLocation(uri:String):Void 
	{
		if (uri.charAt(uri.length - 1) != "/") uri += "/";
		resourceLocation = uri;
	}
	public static function resourceUri(resource:String):String 
	{
		return resourceLocation + resource;
	}
	
	static public function getFileName(path:String) : String
	{
		return path.substr(path.lastIndexOf(slash()) + 1);
	}
}
#end