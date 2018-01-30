package fuse.robotlegs.config.logic.app;
import fuse.utils.Storage;

#if (flash && !test_flash)
import fuse.filesystem.File;
import fuse.filesystem.FileMode;
import fuse.filesystem.FileStream;
#end

import openfl.Assets;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.model.ConfigSettings;
import fuse.robotlegs.config.services.ConfigLoadService;

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
		
		#if (flash && !test_flash)
		copySeedToAppConfigfile();
		#end
		
		loadConfigSeed();
	}
	
	#if (flash && !test_flash)
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