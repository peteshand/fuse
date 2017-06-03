package net.peteshand.keaOpenFL.view.kea.test1;

import net.peteshand.keaOpenFL.view.kea.imageDemo.DemoImage;
import net.peteshand.keaOpenFL.view.kea.imageDemo.DemoVideo;
import kea2.Kea;
import kea.display.Quad;
import kea.display.Sprite;
import kea.display.stats.Stats;
import kea.display.text.TextField;
import kea.texture.Texture;
import kha.Assets;

/**
 * ...
 * @author P.J.Shand
 */
class Test1 extends Sprite
{
	var container:Sprite;
	var image:DemoImage;
	var images:Array<DemoImage> = [];
	var quad:Quad;
	var textfield:TextField;

	var baseMotion:Sprite;
	var count:Int = 0;
	var numImages:Int = 40;
	var stats:Stats;
	var khaImages:Array<Texture> = [];
	
	public function new() 
	{
		super();		
		this.name = "Test1";
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		Assets.loadEverything(OnLoadComplete);
	}

	function OnLoadComplete(): Void
	{
		stage.color = 0xFF8833EE;
		khaImages.push(Assets.images.kea);
		khaImages.push(Assets.images.kea2);
		
		//Timer.delay(AddItems, 1000);
		AddItems();
	}
	
	function AddItems(): Void
	{
		/*baseMotion = Sprite();
		baseMotion.x = 300;
		baseMotion.y = 300;
		addChild(baseMotion);

		image = DemoImage(Assets.images.kea);
		baseMotion.addChild(image);

		image.x = 150;
		image.pivotX = 100;
		image.pivotY = 141;
		image.scaleX = image.scaleY = 0.25;
		image.color = 0xFFFFFFFF;*/


		//container = new Sprite();
		//container.name = "container";
		//container.x.value = 100;
		//container.y.value = 120;
		//container.alpha.value = 0.25;
		//addChild(container);

		/*var colors:Array<UInt> = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];
		for (j in 0...4){
			for (i in 0...4){
				image = Image(Assets.images.kea);
				image.x = Math.floor(800 * Math.random());
				image.y = Math.floor(600 * Math.random());
				//image.x = 100 + (i * 100);
				//image.y = 100;
				image.pivotX = 100;
				image.pivotY = 141;
				image.scaleX = image.scaleY = 0.5;// + (Math.random() * 0.2);
				image.alpha = 0.75;
				image.name = "image"+i;

				//image.rotation.value = 360 * Math.random();
				addChild(image);
			}

			for (i in 0...4){
				quad = new Quad(32, 32, 0xFF00FF00);
				quad.x = Math.floor(800 * Math.random());
				quad.y = Math.floor(600 * Math.random());

				quad.pivotX = 16;
				quad.pivotY = 16;
				quad.scaleX = 0.5;
				quad.scaleY = 0.5;
				quad.rotation = 45;
				addChild(quad);
			}
		}*/
		
		var numQuads:Int = 500;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{
			quad = new Quad(4, 4, 0xFF00FF00);
			quad.x = 500 + Math.floor((stage.stageWidth - 500) * Math.random());
			quad.y = Math.floor(stage.stageHeight * Math.random());
			addChild(quad);
		}
		
		for (i in 0...numImages) {
			
			
			
			
			addImage();
		}
		//
		//textfield = new TextField();
		////textfield.name = "textfield";
		//addChild(textfield);
		////textfield.x = 20;
		////textfield.y = 20;
		//textfield.text = "THIS IS A TEST";
		
		//renderList.length + " images"
		//stats = new Stats();
		//addChild(stats);
		//stats.init();
		
		/*var demoVideo:DemoVideo = new DemoVideo();
		addChild(demoVideo);*/

		//Kea.current.onRender.add(update);
	}

	override function update(): Void {
		
		var len:Int = 1;
		
		count++;
		var max:Int = 250;
		if (max > images.length) max = images.length;
		
		var start:Int = 0;
		var end:Int = images.length;
		
		for (i in start...end){
			
			var j:Int = i % numImages;
			images[j].update();
		}
	}

	function addImage(): Void {
		
		//trace("addImage");
		
		var imageIndex:Int = Math.floor(Math.random() * 2);
		image = new DemoImage(khaImages[imageIndex]);
		image.name = "image" + images.length;
		addChild(image);
		
		image.x = 500 + 50 + Math.floor((stage.stageWidth - 500 - 100) * Math.random());
		image.y = 50 + Math.floor((stage.stageHeight - 100) * Math.random());
		//image.x = 100 + (images.length * 100);
		//image.y = 100;
		image.pivotX = 100;
		image.pivotY = 141;
		image.scaleX = image.scaleY = 0.5;// + (Math.random() * 0.2);
		image.alpha = 1;
		
		image.color = 0xFFFFFFFF;
		
		
		//image.rotation.value = 360 * Math.random();
		

		images.push(image);
	}
}