package net.peteshand.keaOpenFL.view.starling.overlay.close;

import com.imagination.core.managers.touch.TouchManager;
import com.imagination.kea.model.overlay.OverlayModel;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import starling.events.Touch;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
class CloseButtonViewMediator extends Mediator
{
	@inject public var view:CloseButtonView;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var overlayModel:OverlayModel;
	
	public function new() { }
	
	override public function initialize():Void
	{
		//mediatorMap.map(ChildView).toMediator(ChildViewMediator);
		view.initialize();
		
		TouchManager.add(view).setBegin(OnBegin);
	}
	
	function OnBegin(touch:Touch)
	{
		overlayModel.show.value = false;
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