package net.peteshand.keaOpenFL.view.away3d;

import com.imagination.core.managers.initialize.InitializeManager;
import com.imagination.kea.definitions.state.State;
import net.peteshand.keaOpenFL.view.away3d.display.ExampleAwayView;
import net.peteshand.keaOpenFL.view.away3d.display.ExampleAwayViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class MainAwayLayerMediator extends Mediator 
{
	@inject public var mediatorMap:IMediatorMap;
	@inject public var view:MainAwayLayer;
	
	public function new() 
	{
		
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(ExampleAwayView).toMediator(ExampleAwayViewMediator);
		
		view.initialize();
		
		InitializeManager.define(view.container, ExampleAwayView, State.STATE_1);
	}
}