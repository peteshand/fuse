package net.peteshand.keaOpenFL.view.starling;

import com.imagination.core.managers.initialize.InitializeManager;
import com.imagination.kea.definitions.state.State;
import net.peteshand.keaOpenFL.view.starling.display.ExampleStarlingView;
import net.peteshand.keaOpenFL.view.starling.display.ExampleStarlingViewMediator;
import net.peteshand.keaOpenFL.view.starling.overlay.OverlayView;
import net.peteshand.keaOpenFL.view.starling.overlay.OverlayViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author P.J.Shand
 */

class MainStarlingLayerMediator extends Mediator 
{
	@inject public var view:MainStarlingLayer;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
		
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(ExampleStarlingView).toMediator(ExampleStarlingViewMediator);
		mediatorMap.map(OverlayView).toMediator(OverlayViewMediator);
		
		view.initialize();
		
		InitializeManager.define(view.container, ExampleStarlingView, State.STATE_2);
		InitializeManager.define(view.overlay, OverlayView, State.OVERLAY_STATE);
	}
}