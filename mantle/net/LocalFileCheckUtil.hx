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
		var split:Array<String> = url.split("://");
		if (split.length <= 1) return null;
		if (split[0] == "file") {
			return url; // already local
		}
		
		var url2:String = "";
		var split2:Array<String> = split[1].split("/");
		for (i in 0...split2.length-1) 
		{
			url2 += split2[i] + "/";
		}
		var path:String = Storage.appStorageDir.nativePath + "/cache/" + url2;
		var localDir:File = new File(path);
		if (!localDir.exists) {
			localDir.createDirectory();
		}
		
		return path + "/" + split2[split2.length - 1];
	}
}