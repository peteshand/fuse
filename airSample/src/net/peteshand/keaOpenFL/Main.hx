package net.peteshand.keaOpenFL;

import haxe.Json;
import fuse.Kea;
import fuse.core.KeaConfig;
import net.peteshand.keaOpenFL.view.kea.MainLayer;
import openfl.Memory;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.utils.ByteArray;

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
		
		/*var transparentTest:TransparentTest = new TransparentTest();
		addChild(transparentTest);
		
		transparentTest.init();*/
		
		/*var ba:ByteArray = new ByteArray();
		ba.length = 10000;
		Memory.select(ba);
		var i:Int = 16;
		Memory.setI16(0, i);
		var o:Int = Memory.getUI16(0);
		
		trace([i, o]);*/
	}

}
