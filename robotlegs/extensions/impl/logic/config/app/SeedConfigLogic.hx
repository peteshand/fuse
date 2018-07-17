package robotlegs.extensions.impl.logic.config.app;
import mantle.definitions.Storage;

#if (air && !mobile && !test_flash)
import mantle.util.fs.File;
import mantle.util.fs.FileMode;
import mantle.util.fs.FileStream;
#end

import openfl.Assets;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.services.config.ConfigLoadService;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class SeedConfigLogic
{
	var seedJson:String;
	@inject public var configModel:IConfigModel;
	@inject public var configLoadService:ConfigLoadService;
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		seedJson = Assets.getText("config/" + ConfigSettings.FILE_NAME_LOCAL_SEED + ".json");
		
		#if (air && !mobile)
		copySeedToAppConfigfile();
		#end
		
		loadConfigSeed();
	}
	
	#if (air && !mobile && !test_flash)
	function copySeedToAppConfigfile() 
	{
		// for reference only
		
		var seedReference:File = Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_SEED_REF + ".json");
		var fileStream:FileStream = new FileStream();
		fileStream.open(seedReference, FileMode.WRITE);
		fileStream.writeUTFBytes(seedJson);
		fileStream.close();
	}
	#end
	
	function loadConfigSeed() 
	{
		configLoadService.parseConfigData(seedJson);
	}
}