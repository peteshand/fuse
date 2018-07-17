package robotlegs.extensions.impl.commands.input;

import haxe.Timer;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;

/**
 * Trigger this command on startup to hide the mouse
 * when it is idle.
 * 
 * @author Thomas Byrne
 */
class HideMouseCommand extends Command
{
	private static inline var DELAY:Int = 4000;
	
	
	var timer:Timer;
	
	
	@inject public var contextView:ContextView;
	@inject public var configModel:IConfigModel;
	
	public function new() 
	{
		
	}
	
	override public function execute():Void 
	{
		contextView.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		#if !debug
			Mouse.hide();
		#end
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if (!configModel.hideMouse){
			Mouse.show();
		}
		
		if (timer != null) timer.stop();
		timer = Timer.delay(onTimer, DELAY);
	}
	
	function onTimer() 
	{
		timer = null;
		#if !debug
			Mouse.hide();
		#end
	}
}