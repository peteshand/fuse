package robotlegs.extensions.impl.commands.alwaysOnTop;

import flash.display.NativeWindow;
import openfl.events.Event;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;

/**
 * ...
 * @author P.J.Shand
 */
class AlwaysOnTopCommand extends Command 
{
	private var window:NativeWindow;
	@inject public var contextView:ContextView;
	@inject("optional=true") public var configModel:IConfigModel;
	
	public function new() { }
	
	override public function execute():Void
	{
		if (configModel==null) return;
		if (configModel.alwaysOnTop) {
			window = contextView.view.stage.nativeWindow;
			if (window == null) return;
			contextView.view.stage.addEventListener(Event.ENTER_FRAME, Update);
		}
	}
	
	private function Update(e:Event):Void 
	{
		BringToFront();
	}
	
	function BringToFront() 
	{
		if (window == null) return;
		if (window.closed || window.active == false) return;
		window.alwaysInFront = false;
		window.alwaysInFront = true;
	}
}