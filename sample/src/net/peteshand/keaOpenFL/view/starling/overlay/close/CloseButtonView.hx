package net.peteshand.keaOpenFL.view.starling.overlay.close;

import starling.display.Quad;
import starling.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */

class CloseButtonView extends Sprite
{

	public function new()
	{
		super();
	}
	
	public function initialize():Void
	{
		var background = new Quad(20, 20, 0xFF000000);
		addChild(background);
		
		var cross = new Sprite();
		addChild(cross);
		cross.x = 10;
		cross.y = 10;
		cross.rotation = 45 * Math.PI / 180;
		
		var line1 = new Quad(15, 3, 0xFFFFFFFF);
		line1.pivotX = line1.width / 2;
		line1.pivotY = line1.height / 2;
		cross.addChild(line1);
		
		var line2 = new Quad(3, 15, 0xFFFFFFFF);
		line2.pivotX = line2.width / 2;
		line2.pivotY = line2.height / 2;
		cross.addChild(line2);
	}
	
	override public function dispose():Void
	{
		super.dispose();
	}
}