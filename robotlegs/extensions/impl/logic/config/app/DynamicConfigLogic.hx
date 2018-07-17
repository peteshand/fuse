package robotlegs.extensions.impl.logic.config.app;

#if (air && !mobile)
import robotlegs.extensions.impl.logic.config.app.StaticConfigLogic;
import mantle.definitions.Storage;
import mantle.util.fs.File;
import mantle.util.fs.FileMode;
import mantle.util.fs.FileStream;
import haxe.Json;
import openfl.errors.Error;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.logic.config.app.StaticConfigLogic.EmptyConfig;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.services.config.ConfigSaveService;
import robotlegs.extensions.impl.utils.json.JsonFormatter;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class DynamicConfigLogic
{
	@inject public var configModel:IConfigModel;
	@inject public var configSaveService:ConfigSaveService;
	
	public function new() 
	{
		
	}
	
	public function init() 
	{
		#if (air && !mobile)
		var file:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_DYNAMIC + ".json");
		if (!file.exists) {
			createEmptyDynamic(file);
		}
		loadDynamicData(file);
		configModel.onLocalDynamicSet.add(OnLocalDynamicSet);
		#end
	}
	
	function createEmptyDynamic(file:File) 
	{
		var emptyConfig:EmptyConfig = { props: { exampleProp:"test" } };
		var emptyConfigStr:String = JsonFormatter.formatJsonString(Json.stringify(emptyConfig));
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(emptyConfigStr);
		fileStream.close();
	}
	
	#if (air && !mobile)
	function loadDynamicData(file:File) 
	{
		if (!file.exists) return;
		
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		var dataStr:String = fileStream.readUTFBytes(file.size);
		fileStream.close();
		try {
			var data:PropsData = Json.parse(dataStr);
			if (data.props != null) {
				for (key in Reflect.fields(data.props)){
					configModel.set(key, Reflect.field(data.props, key));
				}
			}
		}
		catch (e:Error) {
			
		}
	}
	
	function OnLocalDynamicSet() 
	{
		saveDynamicData(configModel.localDynamicData, Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_DYNAMIC + ".json"));
	}
	
	function saveDynamicData(dynamicData:Map<String, Dynamic>, saveLocation:File) 
	{
		var data:Dynamic = { };
		var count:Int = 0;
		for (key in dynamicData.keys()) 
		{
			//trace([key, dynamicData.get(key)]);
			Reflect.setProperty(data, key, dynamicData.get(key));
			count++;
		}
		if (count == 0) return;
		var dynamicConfig:Dynamic = { "props":data };
		configSaveService.saveConfigData(dynamicConfig, saveLocation);
	}
	#end
}

typedef PropsData =
{
	props:{}
}
#end