package net.peteshand.keaOpenFL.view.starling.overlay;

import net.peteshand.keaOpenFL.view.starling.overlay.close.CloseButtonView;
import net.peteshand.keaOpenFL.view.starling.overlay.close.CloseButtonViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author P.J.Shand
 */

class OverlayViewMediator extends Mediator 
{
	@inject public var view:OverlayView;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new()
	{
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(CloseButtonView).toMediator(CloseButtonViewMediator);
		
		view.initialize();
	}
	
	override public function destroy():Void
	{
		view.dispose();
	}
	
	override public function postDestroy():Void
	{
		super.postDestroy();
	}
}