package robotlegs.extensions.impl.commands.fullscreen;

import mantle.keyboard.Key;
import mantle.keyboard.Keyboard;
import mantle.delay.Delay;
import flash.display.DisplayObject;
import flash.display.StageDisplayState;
import flash.events.MouseEvent;
import openfl.errors.Error;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;
	
/**
 * ...
 * @author Thomas Byrne
 */
@:rtti
@:keepSub
class AirFullscreenCommand extends Command 
{
	@inject public var contextView:ContextView;
	@inject("optional=true") public var configModel:IConfigModel;
	
	private var coolingDown:Bool = false;
	private var coolDownCount:Int = 150;
	private var enterFullscreenOnStartup:Bool = true;
	
	public function FullscreenCommand() { }
	
	override public function execute():Void
	{
		if (configModel.fullscreenOnInit) {
			GoFullScreen();
		}
		attachTo(contextView.view.stage);
		Keyboard.onPress(Key.F, ToggleFullscreen).ctrl(true);
		Keyboard.onPress(Key.ENTER, ToggleFullscreen).ctrl(true);
	}
	
	private function attachTo(displayObject:DisplayObject):Void
	{
		if (configModel==null) {
			displayObject.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClickToggle);
		}
		else if (configModel.fullscreenOnInit) {
			GoFullScreen();
			displayObject.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClickFullscreen);
		}
		else {
			displayObject.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClickToggle);
		}
	}
	
	private function ToggleFullscreen():Void 
	{
		//if (!configModel.fullscreenOnInit) return;
		
		if (contextView.view.stage.displayState == StageDisplayState.NORMAL) {
			GoFullScreen();
		}
		else {
			ExitFullScreen();
		}
	}
	
	private function GoFullScreen():Void 
	{
		#if air3
			try {
				contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			catch (e:Error) {
				contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			if (contextView.view.stage.nativeWindow != null) {	//seems to be null on the tablet		
				contextView.view.stage.nativeWindow.activate();
			}
		#else
			contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN;
		#end
	}
	
	/*function checkNativeWindow() 
	{
		if (contextView.view.stage.nativeWindow != null)			
			contextView.view.stage.nativeWindow.activate();
		else
			Delay.nextFrame( checkNativeWindow );
	}*/
	
	private function ExitFullScreen():Void 
	{
		contextView.view.stage.displayState = StageDisplayState.NORMAL;
	}
	
	private function OnDoubleClickFullscreen(e:MouseEvent):Void 
	{
		var exit:Bool = true;
		if (!e.shiftKey) return;
		if (e.type == MouseEvent.DOUBLE_CLICK) exit = false;
		if (exit) return;
		
		GoFullScreen();
	}
	
	private function OnDoubleClickToggle(e:MouseEvent):Void 
	{
		if (!e.shiftKey) return;
		
		if (!coolingDown){
			if (contextView.view.stage.displayState == StageDisplayState.NORMAL) GoFullScreen();
			else ExitFullScreen();
			coolingDown = true;
			Delay.byTime(0.5, OnCooldownComplete);
		}
	}
	
	private function OnCooldownComplete():Void 
	{
		coolingDown = false;
	}
}