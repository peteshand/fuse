package mantle.net;

import mantle.definitions.Storage;
import mantle.filesystem.File;
/**
 * ...
 * @author P.J.Shand
 */
class LocalFileCheckUtil
{
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
		var cacheDir:File = new File(Storage.appStorageDir.nativePath + "/cache/");
		if (!cacheDir.exists) cacheDir.createDirectory();

		var split:Array<String> = url.split("://");
		if (split.length <= 1) return null;
		if (split[0] == "file") {
			return url; // already local
		}
		
		var url2:String = "";
		var dirs:Array<String> = split[1].split("/");
		for (i in 0...dirs.length-1) 
		{
			url2 += dirs[i] + "/";
			var localDir:File = new File(cacheDir.nativePath + url2);
			if (!localDir.exists) localDir.createDirectory();
		}
		
		var path:String = cacheDir.nativePath + url2;
		return path + "/" + dirs[dirs.length - 1];
	}
}