package net.peteshand.keaOpenFL.view.starling;

import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingLayer;
import starling.display.Sprite;
/**
 * ...
 * @author P.J.Shand
 */

class MainStarlingLayer extends StarlingLayer
{
	public var container:Sprite;
	public var overlay:Sprite;
	
	public function new() 
	{
		super();
		
	}
	
	public function initialize() 
	{
		container = new Sprite();
		addChild(container);
		
		overlay = new Sprite();
		addChild(overlay);
	}
}