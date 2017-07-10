package net.peteshand.keaOpenFL.view.away3d;

import away3d.containers.ObjectContainer3D;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayLayer;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class MainAwayLayer extends AwayLayer 
{
	public var container:ObjectContainer3D;
	
	public function new(profile:String) 
	{
		super(profile);
	}
	
	public function initialize():Void 
	{
		container = new ObjectContainer3D();
		scene.addChild(container);
	}
}