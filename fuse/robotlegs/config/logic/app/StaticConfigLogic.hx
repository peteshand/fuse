package fuse.robotlegs.config.logic.app;

import haxe.Json;

import fuse.filesystem.File;
import fuse.filesystem.FileMode;
import fuse.filesystem.FileStream;

import fuse.utils.Storage;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.model.ConfigSettings;
import fuse.robotlegs.config.services.ConfigLoadService;
import fuse.robotlegs.config.utils.JsonFormatter;

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
		#if (flash && !test_flash)
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