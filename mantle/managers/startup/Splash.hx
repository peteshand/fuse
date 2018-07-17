package mantle.managers.startup;

import mantle.delay.Delay;
import mantle.managers.resize.Resize;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageDisplayState;

/**
 * ...
 * @author P.J.Shand
 */
class Splash
{
	static private var stage:Stage;
	static private var root:Sprite;
	static private var bmd:BitmapData;
	static private var container:Sprite;
	static private var bitmap:Bitmap;

	public function new() 
	{
		
	}
	
	static public function create(root:Sprite, imageURL:String, fullscreen:Bool) 
	{
		Splash.root = root;
		Splash.stage = root.stage;
		
		if (fullscreen) {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		container = new Sprite();
		root.addChild(container);
		
		bmd = Assets.getBitmapData(imageURL);
		bitmap = new Bitmap(bmd);
		bitmap.smoothing = true;
		container.addChild(bitmap);
		bitmap.x = bitmap.width / -2;
		bitmap.y = bitmap.height / -2;
		
		new Resize(stage);
		Resize.add(OnResize);
		OnResize();
		
		Delay.byFrames(60, Clear);
	}
	
	static private function Clear() 
	{
		root.graphics.clear();
		if (container.parent != null) container.parent.removeChild(container);
		if (bitmap.parent != null) bitmap.parent.removeChild(bitmap);
		bmd.dispose();
		Resize.remove(OnResize);
	}
	
	static private function OnResize() 
	{
		root.graphics.clear();
		root.graphics.beginFill(0x000000);
		root.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		root.graphics.endFill();
		
		var scale:Float = stage.stageHeight / 1080;
		container.scaleX = container.scaleY = scale;
		
		container.x = stage.stageWidth / 2;
		container.y = stage.stageHeight / 2;
	}
}