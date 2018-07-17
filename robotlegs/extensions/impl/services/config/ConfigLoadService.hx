package robotlegs.extensions.impl.services.config;
import mantle.util.fs.File;
import mantle.util.fs.FileMode;
import mantle.util.fs.FileStream;
import haxe.Json;
import openfl.errors.Error;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.model.flags.FlagsModel;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class ConfigLoadService 
{
	@inject public var configModel:IConfigModel;
	@inject public var flagsModel:FlagsModel;
	
	public function new()
	{
		
	}
	
	#if (air && !mobile)
	public function loadDynamicData(file:File) 
	{
		if (!file.exists) return;
		
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		var dataStr:String = fileStream.readUTFBytes(file.size);
		fileStream.close();
		parseConfigData(dataStr);
	}
	#end
	
	public function parseConfigData(dataStr:String):Void
	{
		var data:Dynamic = null;
		try {
			data = Json.parse(dataStr);
			
		}
		catch (e:Error) {
			trace("e = " + e);
			trace("dataStr = " + dataStr);
		}
		
		if (data != null){
			var props:Dynamic = Reflect.getProperty(data, "props");
			if (props != null) {
				for (key in Reflect.fields(props)){
					var property:Dynamic = Reflect.field(data.props, key);
					var hasDefault:Bool = false;
					if (property != null) {
						hasDefault = Reflect.hasField(property, "default");
					}
					var defaultValue:Dynamic = Reflect.getProperty(property, "default");
					if (hasDefault == false) {
						//trace(key + " = " + property);
						setProp(key, property);
					}
					else {
						//trace(key + " defaultValue = " + defaultValue);
						
						var match:Bool = false;
						for (flag in Reflect.fields(property)) {
							var exists = flagsModel.match(flag);
							//trace(key + " key: flagsModel.match(" + flag + ") = " + exists);
							if (exists) {
								var value:Dynamic = untyped property[flag];
								//trace(key + " - " + flag + " = " + value);
								setProp(key, value);
								match = true;
								break;
							}
						}
						if (!match){
							var value:Dynamic = untyped property["default"];
							//trace("value = " + value);
							setProp(key, value);
						}
					}
				}
			}
		}
	}
	
	function setProp(key:String, value:Dynamic) 
	{
		try {
			Reflect.setProperty(configModel, key, value);
			//trace("config property '" + key + "' set to '" + value + "'");
		}
		catch (e:Error) {
			trace("config does not have '" + key + "' property");
		}
	}
}