package kea.model;
import kea.model.config.KeaConfig;
import kea.model.performance.Performance;

/**
 * ...
 * @author P.J.Shand
 */
class Model
{
	public var performance:Performance;
	public var keaConfig:KeaConfig;
	
	public function new() 
	{
		performance = new Performance();
		
		keaConfig = { frameRate:60, atlasBuffers:5 };
		keaConfig.useCacheLayers = true;
	
	}
	
	public function init(keaConfig:KeaConfig) 
	{
		if (keaConfig.useCacheLayers == false) this.keaConfig.useCacheLayers = false;
		if (keaConfig.debugTextureAtlas == true) this.keaConfig.debugTextureAtlas = true;
		if (keaConfig.debugSkipRender == true) this.keaConfig.debugSkipRender = true;
	}
	
}