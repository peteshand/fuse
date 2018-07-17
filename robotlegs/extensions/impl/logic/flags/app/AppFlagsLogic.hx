package robotlegs.extensions.impl.logic.flags.app;

#if (air && !mobile)
import mantle.definitions.Storage;
import mantle.util.fs.File;
import mantle.util.fs.FileMode;
import mantle.util.fs.FileStream;
import haxe.Json;
import openfl.errors.Error;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.model.flags.FlagsModel;
import robotlegs.extensions.impl.utils.json.JsonFormatter;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class AppFlagsLogic
{
	@inject public var flagsModel:FlagsModel;
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		var flagsFile:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_FLAGS + ".json");
		if (!flagsFile.exists) {
			createEmptyFlagsFile(flagsFile);
		}
		loadData(flagsFile);
	}
	
	function createEmptyFlagsFile(flagsFile:File) 
	{
		var emptyFlags:FlagsData = { flags:{ exampleFlag:"test" } };
		var emptyFlagsStr:String = JsonFormatter.formatJsonString(Json.stringify(emptyFlags));
		var fileStream:FileStream = new FileStream();
		fileStream.open(flagsFile, FileMode.WRITE);
		fileStream.writeUTFBytes(emptyFlagsStr);
		fileStream.close();
	}
	
	function loadData(file:File) 
	{
		if (!file.exists) return;
		
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		var dataStr:String = fileStream.readUTFBytes(file.size);
		fileStream.close();
		try {
			var data:FlagsData = Json.parse(dataStr);
			if (data.flags != null) {
				for (key in Reflect.fields(data.flags)) {
					//trace(Reflect.field(data.flags, key) + " = " + key);
					flagsModel.add(key, Reflect.field(data.flags, key));
				}
			}
		}
		catch (e:Error) {
			
		}
	}
}

typedef FlagsData =
{
	flags:Dynamic
}

#end