package net.peteshand.keaOpenFL.view.kea;

import fuse.display.containers.Sprite;
import net.peteshand.keaOpenFL.view.kea.newRenderer.AtlasGenTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.LayerCacheTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.RenderTextureTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.StressTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.NewRendererTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.NonPowerOfTwo;
import net.peteshand.keaOpenFL.view.kea.newRenderer.TwoTextures;
import fuse.Kea;

class MainLayer extends Sprite
{	
	//var test1:Test1;
	

	public function new()
	{
		super();
		this.name = "MainLayer";
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		stage.color = 0xFF112211;
		
		/*test1 = new Test1();
		addChild(test1);*/
		
		/*var layerTest:LayerTest = new LayerTest();
		addChild(layerTest);*/
		
		/*var bunnyMark:BunnyMark = new BunnyMark();
		addChild(bunnyMark);*/
		
		/*var atlasTest:AtlasTest = new AtlasTest();
		addChild(atlasTest);*/
		
		/*var atlasTest2:AtlasTest2 = new AtlasTest2();
		addChild(atlasTest2);*/
		
		/*var textureUploadTest:TextureUploadTest = new TextureUploadTest();
		addChild(textureUploadTest);*/
		
		/*var bgColourTest:BgColourTest = new BgColourTest();
		addChild(bgColourTest);*/
		
		/*var layerTest2:LayerTest2 = new LayerTest2();
		addChild(layerTest2);*/
		
		/*var newRendererTest:NewRendererTest = new NewRendererTest();
		addChild(newRendererTest);
		newRendererTest.init();*/
		
		/*var twoTextures:TwoTextures = new TwoTextures();
		addChild(twoTextures);
		twoTextures.init();*/
		
		/*var nonPowerOfTwo:NonPowerOfTwo = new NonPowerOfTwo();
		addChild(nonPowerOfTwo);
		nonPowerOfTwo.init();*/
		
		/*var renderTextureTest:RenderTextureTest = new RenderTextureTest();
		addChild(renderTextureTest);
		renderTextureTest.init();*/
		
		/*var atlasGenTest:AtlasGenTest = new AtlasGenTest();
		addChild(atlasGenTest);
		atlasGenTest.init();*/
		
		var stressTest:StressTest = new StressTest();
		addChild(stressTest);
		stressTest.init();
		
		/*var layerCacheTest:LayerCacheTest = new LayerCacheTest();
		addChild(layerCacheTest);
		layerCacheTest.init();*/
	}
	
	/*override function update(): Void {
		
	}*/
}
