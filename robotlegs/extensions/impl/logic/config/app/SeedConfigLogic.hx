package robotlegs.extensions.impl.logic.config.app;

import fuse.filesystem.Storage;
#if (air && !mobile && !test_flash)
import openfl.filesystem.File;
import openfl.filesystem.FileMode;
import openfl.filesystem.FileStream;
#end
import openfl.Assets;
import robotlegs.bender.extensions.config.IConfigModel;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.services.config.ConfigLoadService;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class SeedConfigLogic implements DescribedType {
	var seedJson:String;

	@inject public var configModel:IConfigModel;
	@inject public var configLoadService:ConfigLoadService;

	public function new() {}

	public function init():Void {
		seedJson = Assets.getText("config/" + ConfigSettings.FILE_NAME_LOCAL_SEED + ".json");

		#if (air && !mobile)
		copySeedToAppConfigfile();
		#end

		loadConfigSeed();
	}

	#if (air && !mobile && !test_flash)
	function copySeedToAppConfigfile() {
		// for reference only

		var seedReference:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_SEED_REF + ".json");
		var fileStream:FileStream = new FileStream();
		fileStream.open(seedReference, FileMode.WRITE);
		fileStream.writeUTFBytes(seedJson);
		fileStream.close();
	}
	#end

	function loadConfigSeed() {
		configLoadService.parseConfigData(seedJson);
	}
}
