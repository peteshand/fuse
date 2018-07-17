package robotlegs.extensions.impl.commands.fullscreen;
#if js
import js.Browser;
import js.Lib;
#end

import openfl.Assets;
import openfl.display.StageDisplayState;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class HTMLFullscreenCommand extends Command 
{
	//@inject public var model:Model;
	@inject public var contextView:ContextView;
	
	public function new() { }
	
	override public function execute():Void
	{
		toggleFullScreen();
		
		//GoFullScreen();
		
		contextView.view.stage.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClickFullscreen);
		contextView.view.stage.addEventListener(TouchEvent.TOUCH_END, OnEndTouchFullscreen);
	}
	
	private function OnEndTouchFullscreen(e:TouchEvent):Void 
	{
		contextView.view.stage.removeEventListener(TouchEvent.TOUCH_END, OnEndTouchFullscreen);
		GoFullScreen();
	}
	
	private function OnDoubleClickFullscreen(e:MouseEvent):Void 
	{
		//trace("e.shiftKey = " + e.shiftKey);
		//var exit:Bool = false;
		//if (!e.shiftKey) return;
		//if (e.type == MouseEvent.DOUBLE_CLICK) exit = false;
		
		//if (exit) return;
		
		GoFullScreen();
	}
	
	private function GoFullScreen():Void 
	{
		
		/*contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		
		contextView.view.stage.nativeWindow.activate();
		contextView.view.stage.nativeWindow.alwaysInFront = true;
		return;*/
		//trace("GoFullScreen");
		
		//Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		
		//contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN;
		
		#if js
			//var js = Assets.getText("js/Fullscreen.js");
			//Lib.eval(js);
		#end
		
		//untyped js;
		
		//var log = untyped __js__("console.log");
		//log("this is a test");
		
	}
	
	function toggleFullScreen():Void
	{
		//var doc = Browser.document;
		//var docEl = doc.documentElement;
		
		//trace("docEl = " + docEl);
		
		/*var requestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
		var cancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

		if(!doc.fullscreenElement && !doc.mozFullScreenElement && !doc.webkitFullscreenElement && !doc.msFullscreenElement) {
			requestFullScreen.call(docEl);
		}
		else {
			cancelFullScreen.call(doc);
		}*/
	}
}


