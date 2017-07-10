package net.peteshand.keaOpenFL.view.openfl.display;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * ...
 * @author P.J.Shand
 */

class ExampleOpenflViewMediator extends Mediator 
{
	@inject public var view:ExampleOpenflView;
	
	public function new()
	{
		
	}
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
		
		view.initialize();
	}
}
