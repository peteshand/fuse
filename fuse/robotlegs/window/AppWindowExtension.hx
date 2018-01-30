package fuse.robotlegs.window;

import fuse.robotlegs.window.logic.FullscreenLogic;
import fuse.robotlegs.window.logic.WindowPositionLogic;
import fuse.robotlegs.window.model.WindowPositionModel;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
class AppWindowExtension implements IExtension
{
	var injector:IInjector;
	
	public function new() 
	{
		
	}
	
	/* INTERFACE robotlegs.bender.framework.api.IExtension */
	
	public function extend(context:IContext):Void 
	{
		injector = context.injector;
		injector.map(WindowPositionModel).asSingleton();
		
		injector.map(WindowPositionLogic).asSingleton();
		var windowPositionLogic:WindowPositionLogic = injector.getInstance(WindowPositionLogic);
		windowPositionLogic.initialize();
		
		injector.map(FullscreenLogic).asSingleton();
		var fullscreenLogic:FullscreenLogic = injector.getInstance(FullscreenLogic);
		fullscreenLogic.initialize();
		
		
	}
	
}