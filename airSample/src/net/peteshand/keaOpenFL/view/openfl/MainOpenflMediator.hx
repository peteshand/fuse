package net.peteshand.keaOpenFL.view.openfl;

import com.imagination.core.managers.initialize.InitializeManager;
import com.imagination.kea.definitions.state.State;
import net.peteshand.keaOpenFL.view.openfl.display.ExampleOpenflView;
import net.peteshand.keaOpenFL.view.openfl.display.ExampleOpenflViewMediator;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class MainOpenflMediator extends Mediator
{
	@inject public var view:MainOpenflLayer;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
		
	}
	
	override public function initialize():Void
	{
		mediatorMap.map(ExampleOpenflView).toMediator(ExampleOpenflViewMediator);
		
		view.initialize();
		
		InitializeManager.define(view.container, ExampleOpenflView, State.STATE_3);
	}
}