package mantle.filesystem;

#if ((air||electron)&&!mobile)
import mantle.definitions.Storage;
import openfl.filesystem.File;
import openfl.filesystem.FileMode;
import openfl.filesystem.FileStream;
import haxe.Json;

/**
 * ...
 * @author P.J.Shand
 */
class DocStore
{
	public var data:Dynamic = {};
	var id:String;
	var file:File;
	var fileStream:FileStream;

	function new(id:String) 
	{
		this.id = id;

		var docStoreDir:File = Storage.appStorageDir.resolvePath("DocStore");
		if (!docStoreDir.exists) docStoreDir.createDirectory();

		var split:Array<String> = id.split("/");
		if (split.length > 1){
			for (i in 0...split.length-1){
				docStoreDir = docStoreDir.resolvePath(split[i]);
				if (!docStoreDir.exists) docStoreDir.createDirectory();
			}
			id = split[split.length - 1];
		}

		file = docStoreDir.resolvePath(id + ".json");
		if (file.exists){
			fileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readUTFBytes(Math.floor(file.size));
			fileStream.close();
			try{
				data = Json.parse(str);
			} catch (e:Dynamic){
				trace('error parsing data: ' + str);
			}
		}
	}
	
	static public function getLocal(id:String) 
	{
		return new DocStore(id);
	}
	
	public function setProperty(key:String, value:Dynamic) 
	{
		Reflect.setProperty(data, key, value);
	}
	
	public function flush() 
	{
		var str:String = Json.stringify(data);
		fileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(str);
		fileStream.close();
	}
	
	public function clear() 
	{
		data = { };
		if (file.exists) file.deleteFile();
	}
}

#else
	import openfl.net.SharedObject;
	typedef DocStore = SharedObject;
#end