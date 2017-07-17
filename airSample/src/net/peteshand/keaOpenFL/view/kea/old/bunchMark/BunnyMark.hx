package net.peteshand.keaOpenFL.view.kea.old.bunchMark;

import fuse.display.containers.Sprite;
import kea.display.text.TextField;
import kha.Assets;
import kha.graphics2.Graphics;
import kha.Key;
import kha.input.Keyboard;
/**
 * ...
 * @author P.J.Shand
 */
class BunnyMark extends Sprite
{
	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;
	//private var fps:FPS;
	private var gravity:Float;
	private var minX:Int;
	private var minY:Int;
	private var maxX:Int;
	private var maxY:Int;
	var textfield:TextField;
	var container:Sprite;
	//private var tilemap:Tilemap;
	//private var tileset:Tileset;
	
	public function new() 
	{
		super();
		
		onAdd.add(OnAdd);
		
		
	}
	
	function OnAdd() 
	{
		container = new Sprite();
		addChild(container);
		
		bunnies = new Array ();
		
		minX = 0;
		maxX = stage.stageWidth;
		minY = 0;
		maxY = stage.stageHeight;
		gravity = 0.5;
		
		//tileset = new Tileset (bitmapData);
		//tileset.addRect (bitmapData.rect);
		
		//tilemap = new Tilemap (stage.stageWidth, stage.stageHeight, tileset);
		//addChild (tilemap);
		
		//fps = new FPS ();
		//addChild (fps);
		
		//stage.addEventListener (MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		//stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		//stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
		textfield = new TextField();
		addChild(textfield);
		textfield.text = "THIS IS A TEST";
		
		for (i in 0...100) {
			addBunny();
		}
		
		Keyboard.get().notify(OnDown, OnUp);
	}
	
	function OnDown(key:Key, char:String) 
	{
		switch(key) {
			case UP:trace("the UP key is pressed");
			case DOWN:trace("the DOWN key is pressed");
			case CHAR: if (char == 't') {
				addingBunnies = true;
			}
			default: return;
		}
	}
	
	function OnUp(key:Key, char:String) 
	{
		switch(key) {
			case UP:trace("the UP key is pressed");
			case DOWN:trace("the DOWN key is pressed");
			case CHAR: if (char == 't') {
				addingBunnies = false;
			}
			default: return;
		}
	}
	
	/*override public function calcTransform(graphics:Graphics) 
	{
		super.calcTransform(graphics);
		stage_onEnterFrame();
	}*/
	
	private function addBunny ():Void {
		
		var bunny = new Bunny(Assets.images.wabbit);
		bunny.x = 0;
		bunny.y = 0;
		bunny.speedX = Math.random () * 5;
		bunny.speedY = (Math.random () * 5) - 2.5;
		container.addChild(bunny);
		bunnies.push(bunny);
		
		textfield.text = bunnies.length + " Bunnies";
		//tilemap.addTile (bunny);
		
	}
	//
	//
	//
	//
	//// Event Handlers
	//
	//
	//
	//
	private function stage_onEnterFrame ():Void {
		
		var start:Int = 0;
		var end:Int = bunnies.length;
		if (bunnies.length > 4000) start = end - 4000;
		
		for (i in start...end) {
			
			var bunny:Bunny = bunnies[i];
			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;
			
			if (bunny.x > maxX) {
				
				bunny.speedX *= -1;
				bunny.x = maxX;
				
			} else if (bunny.x < minX) {
				
				bunny.speedX *= -1;
				bunny.x = minX;
				
			}
			
			if (bunny.y > maxY) {
				
				bunny.speedY *= -0.8;
				bunny.y = maxY;
				
				if (Math.random () > 0.5) {
					
					bunny.speedY -= 3 + Math.random () * 4;
					
				}
				
			} else if (bunny.y < minY) {
				
				bunny.speedY = 0;
				bunny.y = minY;
				
			}
			
		}
		
		if (addingBunnies) {
			
			for (i in 0...100) {
				
				addBunny ();
				
			}
			
		}
		
	}
	//
	//
	//private function stage_onMouseDown (event:MouseEvent):Void {
		//
		//addingBunnies = true;
		//
	//}
	//
	//
	//private function stage_onMouseUp (event:MouseEvent):Void {
		//
		//addingBunnies = false;
		//trace (bunnies.length + " bunnies");
	//}
	
}