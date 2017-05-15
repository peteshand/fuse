package net.peteshand.keaOpenFL;

import kea.Kea;
import kea.model.config.KeaConfig;
import net.peteshand.keaOpenFL.view.kea.MainLayer;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
		
		var keaConfig:KeaConfig = { frameRate:60 };
		keaConfig.useCacheLayers = true;
		keaConfig.debugTextureAtlas = false;
		keaConfig.debugSkipRender = false;
		
		Kea.init(MainLayer, keaConfig);
	}

}
