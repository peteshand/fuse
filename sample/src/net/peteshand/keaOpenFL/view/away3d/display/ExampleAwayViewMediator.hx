package net.peteshand.keaOpenFL.view.away3d.display;

import robotlegs.bender.bundles.mvcs.Mediator;


/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class ExampleAwayViewMediator extends Mediator 
{
	@inject public var view:ExampleAwayView;
	
	public function new() 
	{
		
	}
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
		
		view.initialize();
	}
}
