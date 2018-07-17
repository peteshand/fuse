package robotlegs.extensions.impl.utils.config;

import robotlegs.extensions.impl.model.config2.ConfigData;
import robotlegs.extensions.impl.model.config2.ConfigData.ConfigProp;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.model.config2.Locations;

/**
 * ...
 * @author P.J.Shand
 */
class ConfigUtil
{

	public function new() { }
	
	public static function getConfigProp(key:String, configData:ConfigData):ConfigProp
	{
		if (configData != null) {
			if (configData.props == null) configData.props = [];
			for (j in 0...configData.props.length) 
			{
				if (configData.props[j]._name == key) {
					return configData.props[j];
				}
			}
		}
		var configProp:ConfigProp = { _name:key, _activeLocation:Locations.LOCATION_LOCAL, value:null }
		configData.props.push(configProp);
		return configProp;
	}
	
	public static function setConfigDataValue(key:String, configData:ConfigData, _value:Dynamic) 
	{
		if (configData == null) return;
		var configProp:ConfigProp = getConfigProp(key, configData);
		configProp.value = _value;
	}
	
	public static function setConfigDataLocation(key:String, configData:ConfigData, location:Locations) 
	{
		if (configData == null) return;
		var configProp:ConfigProp = getConfigProp(key, configData);
		configProp._activeLocation = location;
	}
}