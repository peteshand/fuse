package net.peteshand.keaOpenFL.view.kea;
import net.peteshand.keaOpenFL.view.kea.atlas.AtlasTest;
import net.peteshand.keaOpenFL.view.kea.atlas.AtlasTest2;
import net.peteshand.keaOpenFL.view.kea.bgColour.BgColourTest;
import net.peteshand.keaOpenFL.view.kea.bunchMark.BunnyMark;
import net.peteshand.keaOpenFL.view.kea.layerTest.LayerTest;
import net.peteshand.keaOpenFL.view.kea.layerTest.LayerTest2;
import net.peteshand.keaOpenFL.view.kea.newRenderer.NewRendererTest;
import net.peteshand.keaOpenFL.view.kea.newRenderer.TwoTextures;
import net.peteshand.keaOpenFL.view.kea.test1.Test1;
import net.peteshand.keaOpenFL.view.kea.textureUpload.TextureUploadTest;
import kea2.Kea;
import kea.display.Sprite;

class MainLayer extends Sprite
{	
	var test1:Test1;
	

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
		
		var twoTextures:TwoTextures = new TwoTextures();
		addChild(twoTextures);
		twoTextures.init();
		
		
	}
	
	override function update(): Void {
		
	}
}
