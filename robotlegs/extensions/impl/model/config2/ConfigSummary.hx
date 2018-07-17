package robotlegs.extensions.impl.model.config2;

import robotlegs.extensions.impl.model.config2.ConfigData.ConfigProp;
import robotlegs.extensions.impl.model.config2.ConfigSettings;
import robotlegs.extensions.impl.model.config2.ConfigData;

/**
 * ...
 * @author P.J.Shand
 */
class ConfigSummary
{
	public var seedConfigData:ConfigData;
	public var localConfigData:ConfigData;
	public var combinedConfigData:ConfigData;
	
	public function new(seedConfigData:ConfigData=null, localConfigData:ConfigData=null) 
	{
		this.seedConfigData = seedConfigData;
		this.localConfigData = localConfigData;
		
		combinedConfigData = { _filename:null, _name:null, _location:null, props:null, flags:null };
		
		createCombinedLocal();
	}
	
	/*function stripLocation(configData:ConfigData) 
	{
		if (configData == null) return;
		for (j in 0...configData.props.length) 
		{
			var configProp:ConfigProp = configData.props[j];
			Reflect.deleteField(configProp, "_activeLocation");
		}
	}*/
	
	function createCombinedLocal() 
	{
		if (localConfigData != null) copyFromTo(localConfigData, combinedConfigData, true);
		if (seedConfigData != null) copyFromTo(seedConfigData, combinedConfigData);
		//if (remoteConfigData != null) copyFromTo(remoteConfigData, combinedConfigData);
	}
	
	function copyFromTo(fromConfigData:ConfigData, toConfigData:ConfigData, copyFlags:Bool=false) 
	{
		if (toConfigData._filename == null) toConfigData._filename = fromConfigData._filename;
		if (toConfigData._location == null) toConfigData._location = fromConfigData._location;
		if (toConfigData._name == null) toConfigData._name = fromConfigData._name;
		
		if (copyFlags && fromConfigData.flags != null) {
			for (i in 0...fromConfigData.flags.length) 
			{
				if (toConfigData.flags == null) toConfigData.flags = [];
				toConfigData.flags.push(fromConfigData.flags[i]);
			}
		}
		
		if (fromConfigData.props != null){
			for (i in 0...fromConfigData.props.length) 
			{
				var alreadyAdded:Int = -1;
				
				if (toConfigData.props == null) {
					toConfigData.props = [fromConfigData.props[i]];
				}
				else {
					for (j in 0...toConfigData.props.length) 
					{
						var toID:String = toConfigData.props[j]._name;
						var fromID:String = fromConfigData.props[i]._name;
						
						//if (toConfigData.props[j]._if != null) toID += toConfigData.props[j]._if;
						//if (toConfigData.props[j]._if != null) fromID += fromConfigData.props[i]._if;
						
						if (toID == fromID) {
							alreadyAdded = j;
							break;
						}
					}
					if (alreadyAdded != -1) {
						var overrideProp:Bool = toConfigData.props[alreadyAdded]._activeLocation == fromConfigData._location;
						if (overrideProp) toConfigData.props[alreadyAdded] = fromConfigData.props[i];
					}
					else {
						toConfigData.props.push(fromConfigData.props[i]);
					}
				}
			}
		}
	}
}