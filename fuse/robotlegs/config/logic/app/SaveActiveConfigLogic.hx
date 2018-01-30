package fuse.robotlegs.config.logic.app;

import fuse.utils.Storage;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.model.ConfigSettings;
import fuse.robotlegs.config.services.ConfigSaveService;
import fuse.signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class SaveActiveConfigLogic
{
	@inject public var configModel:IConfigModel;
	@inject public var configSaveService:ConfigSaveService;
	
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		var props:Dynamic = { };
		var fields:Array<String> = Type.getInstanceFields(Type.getClass(configModel));
		
		var count:Int = 0;
		for (i in 0...fields.length) 
		{
			var field:String = fields[i];
			
			if (field == "localDynamicData") continue;
			if (field == "globalDynamicData") continue;
			
			var fieldValue:Dynamic = Reflect.getProperty(configModel, field);
			
			if (!Reflect.isFunction(fieldValue) && !Std.is(fieldValue, Signal0)) {
				var value:Dynamic = Reflect.getProperty(configModel, fieldValue);
				
				if (fieldValue != null){
					Reflect.setProperty(props, field, fieldValue);
					//trace(field + " = " + fieldValue);
					count++;
				}
			}
		}
		
		if (count > 0){
			configSaveService.saveConfigData(props, Storage.configDirectory.resolvePath(ConfigSettings.FILE_NAME_COMBINED_REF + ".json"));
		}
	}
}