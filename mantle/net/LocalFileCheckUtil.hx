package mantle.net;

import mantle.definitions.Storage;
import mantle.filesystem.File;
/**
 * ...
 * @author P.J.Shand
 */
class LocalFileCheckUtil
{
	public static var REMOVE_DOMAIN:Bool = true;

	static public function localURL(url:String):String
	{
		if (url == null) return null;
		
		var _localPath:String = localPath(url);
		if (_localPath == null) {
			trace("url = " + url);
			trace("_localPath = " + _localPath);
			return null;
		}
		
		var localFile:File = new File(_localPath);
		
		if (localFile.exists){
			return localFile.url;
		}
		else {
			return null;
		}
	}
	
	static public function localPath(url:String) 
	{
		var cacheDir:File = new File(Storage.appStorageDir.nativePath + File.separator + "cache" + File.separator);
		if (!cacheDir.exists) cacheDir.createDirectory();

		var split:Array<String> = url.split("://");
		if (split.length <= 1) return null;
		if (split[0] == "file") {
			return url; // already local
		}
		
		var url2:String = File.separator;
		var dirs:Array<String> = split[1].split("/");
		var startIndex:Int = 0;
		if (REMOVE_DOMAIN) startIndex = 1;
		for (i in startIndex...dirs.length-1) 
		{
			url2 += dirs[i] + File.separator;
			var localDir:File = new File(cacheDir.nativePath + url2);
			if (!localDir.exists) localDir.createDirectory();
		}
		
		var path:String = cacheDir.nativePath + url2;
		return path + File.separator + dirs[dirs.length - 1];
	}
}