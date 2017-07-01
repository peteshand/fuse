package net.peteshand.keaOpenFL.view.kea.old.imageDemo;

import kea.display.Image;
import kha.graphics2.Graphics;

class DemoImage extends Image
{
	var v:Float = 1;
	var rotationDelta:Float = 5;
	var rotate:Bool;

	public function new(base:kha.Image)
	{
		super(base);
		this.rotation = 45;
		rotate = true;// Math.floor(Math.random() * 2) == 0;
	}

	override public function update():Void
	{
		if (rotate && rotationDelta > 0) {
			this.rotation = this.rotation + rotationDelta;
		}
		if (rotationDelta > 0.1) {
			rotationDelta *= 0.99;
		}
		else {
			rotationDelta -= 0.0032;
		}
		
		if (rotationDelta < -1) {
			rotationDelta = 5;
		}
		
		
		
		//this.color.R = this.color.G = this.color.B = v;
	}
}
