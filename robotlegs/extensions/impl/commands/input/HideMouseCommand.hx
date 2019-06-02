package robotlegs.extensions.impl.commands.input;

import delay.Delay;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.config.IConfigModel;

/**
 * Trigger this command on startup to hide the mouse
 * when it is idle.
 *
 * @author Thomas Byrne
 */
class HideMouseCommand extends Command {
	private static inline var DELAY:Int = 4;

	@inject public var contextView:ContextView;
	@inject public var configModel:IConfigModel;

	public function new() {}

	override public function execute():Void {
		contextView.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		#if !debug
		Mouse.hide();
		#end
	}

	private function onMouseMove(e:MouseEvent):Void {
		if (!configModel.hideMouse) {
			Mouse.show();
		}
		Delay.killDelay(hide);
		Delay.byTime(DELAY, hide);
	}

	function hide() {
		#if !debug
		Mouse.hide();
		#end
	}
}
