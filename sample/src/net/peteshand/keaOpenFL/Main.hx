package net.peteshand.keaOpenFL;

import fuse.Kea;
import fuse.core.KeaConfig;
import net.peteshand.keaOpenFL.view.kea.MainLayer;
import openfl.display.Sprite;

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
		
		/*var a:Int = 1;
		var b:Int = 0;
		
		trace(a);
		trace(b);
		
		var x:Int = a << 16 | b;
		
		trace(x);
		
		a = x >> 16;
		b = x & 0x0000FFFF;
		
		trace(a);
		trace(b);*/
		
		//Split
		//a = x >> 16;
		//b = x & 0x0000FFFF;
		 
		//Reconstruction
		//x = (uint32_t)a << 16 | (uint32_t)b
		 
		
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
