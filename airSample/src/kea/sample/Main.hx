package kea.sample;

import flash.Lib;
import flash.display.Sprite;
import kea2.Kea;

/**
 * ...
 * @author P.J.Shand
 */
class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		var keaConfig:KeaConfig = { frameRate:60, atlasBuffers:5 };
		keaConfig.useCacheLayers = true;
		keaConfig.debugTextureAtlas = false;
		keaConfig.debugSkipRender = false;
		Kea.init(MainLayer, keaConfig);
	}

	static function main() 
	{
		Lib.current.addChild(new Main());
	}

}