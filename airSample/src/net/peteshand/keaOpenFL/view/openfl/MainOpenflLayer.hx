package net.peteshand.keaOpenFL.view.openfl;

import openfl.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class MainOpenflLayer extends Sprite
{
	public var container:Sprite;
	
	public function new() 
	{
		super();
	}
	
	public function initialize() 
	{
		container = new Sprite();
		addChild(container);
	}
}