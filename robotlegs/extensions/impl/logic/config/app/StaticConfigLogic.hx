package robotlegs.extensions.impl.logic.config.app;

#if (air && !mobile)
import mantle.definitions.Storage;
import openfl.filesystem.File;
import openfl.filesystem.FileMode;
import openfl.filesystem.FileStream;
import haxe.Json;
import robotlegs.bender.extensions.config.IConfigModel;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.services.config.ConfigLoadService;
import robotlegs.extensions.impl.utils.json.JsonFormatter;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class StaticConfigLogic implements DescribedType {
	@inject public var configModel:IConfigModel;
	@inject public var configLoadService:ConfigLoadService;

	public function new() {}

	public function init() {
		#if (air && !mobile)
		var file:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_STATIC + ".json");
		if (!file.exists) {
			createEmptyConfigOverride(file);
		}
		configLoadService.loadDynamicData(file);
		#end
	}

	function createEmptyConfigOverride(file:File) {
		var emptyConfig:EmptyConfig = {props: {exampleProp: "test"}};
		var emptyConfigStr:String = JsonFormatter.formatJsonString(Json.stringify(emptyConfig));
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(emptyConfigStr);
		fileStream.close();
	}
}

typedef EmptyConfig = {
	props:Dynamic
}
#end
