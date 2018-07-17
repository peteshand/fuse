package robotlegs.extensions.impl.logic.config.app;

#if (air && !mobile)
import mantle.definitions.Storage;
import mantle.util.fs.File;
import mantle.util.fs.FileMode;
import mantle.util.fs.FileStream;
import haxe.Json;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.services.config.ConfigLoadService;
import robotlegs.extensions.impl.utils.json.JsonFormatter;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class StaticConfigLogic
{
	@inject public var configModel:IConfigModel;
	@inject public var configLoadService:ConfigLoadService;
	
	public function new() 
	{
		
	}
	
	public function init() 
	{
		#if (air && !mobile)
		var file:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_STATIC + ".json");
		if (!file.exists) {
			createEmptyConfigOverride(file);
		}
		configLoadService.loadDynamicData(file);
		#end
	}
	
	function createEmptyConfigOverride(file:File) 
	{
		var emptyConfig:EmptyConfig = { props: { exampleProp:"test" } };
		var emptyConfigStr:String = JsonFormatter.formatJsonString(Json.stringify(emptyConfig));
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(emptyConfigStr);
		fileStream.close();
	}
}

typedef EmptyConfig = 
{
	props:Dynamic
}

#end