package net.peteshand.keaOpenFL.view;

import com.imagination.kea.definitions.colorPalette.ColorPalette;
import net.peteshand.keaOpenFL.view.away3d.MainAwayLayer;
import net.peteshand.keaOpenFL.view.away3d.MainAwayLayerMediator;
import net.peteshand.keaOpenFL.view.openfl.MainOpenflLayer;
import net.peteshand.keaOpenFL.view.openfl.MainOpenflMediator;
import net.peteshand.keaOpenFL.view.starling.MainStarlingLayer;
import net.peteshand.keaOpenFL.view.starling.MainStarlingLayerMediator;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.IViewport;
import robotlegs.bender.extensions.imag.impl.signals.AppSetupCompleteSignal;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import robotlegs.bender.extensions.display.base.api.IStack;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;
import openfl.display3D.Context3DProfile;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class ViewConfig implements IConfig 
{
	@inject public var context:IContext;
	@inject public var commandMap:ISignalCommandMap;
	@inject public var mediatorMap:IMediatorMap;
	@inject public var stack:IStack;
	@inject public var viewport:IViewport;
	@inject public var renderer:IRenderer;
	@inject public var renderContext:IRenderContext;
	@inject public var contextView:ContextView;
	@inject public var appSetupComplete:AppSetupCompleteSignal;
	
	var setupComplete:Bool;
	var rendererReady:Bool;
	
	public function new()
	{
		
	}
	
	public function configure():Void 
	{
		context.afterInitializing(init);
	}
	
	private function init():Void 
	{
		renderContext.onReady.addOnce(OnContext3DReady);
		renderContext.setup( { profile:Context3DProfile.BASELINE_EXTENDED, antiAlias:2 } );
		renderer.start();
		
		appSetupComplete.add(onSetupComplete);
	}
	
	function onSetupComplete() 
	{
		setupComplete = true;
		checkReady();
	}
	
	private function OnContext3DReady():Void 
	{
		mapMediators();
		rendererReady = true;
		checkReady();
	}
	
	function checkReady() 
	{
		if (setupComplete && rendererReady) {
			initView();
			renderer.start();
		}
	}
	
	private function mapMediators():Void 
	{
		mediatorMap.map(MainOpenflLayer).toMediator(MainOpenflMediator);
		mediatorMap.map(MainAwayLayer).toMediator(MainAwayLayerMediator);
		mediatorMap.map(MainStarlingLayer).toMediator(MainStarlingLayerMediator);
	}
	
	private function initView():Void 
	{
		viewport.colour = ColorPalette.COLOUR1;
		
		contextView.view.addChild(new MainOpenflLayer());
		
		stack.addLayer(MainAwayLayer);
		stack.addLayer(MainStarlingLayer);
	}
}