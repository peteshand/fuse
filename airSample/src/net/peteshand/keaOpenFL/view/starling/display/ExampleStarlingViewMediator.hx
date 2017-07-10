package net.peteshand.keaOpenFL.view.starling.display;

import net.peteshand.keaOpenFL.view.starling.display.ExampleStarlingView;
import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * ...
 * @author P.J.Shand
 */

class ExampleStarlingViewMediator extends Mediator 
{
	@inject public var view:ExampleStarlingView;
	
	public function new()
	{
		
	}
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
		
		view.initialize();
	}
}
