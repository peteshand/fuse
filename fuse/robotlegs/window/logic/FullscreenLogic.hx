package fuse.robotlegs.window.logic;

import mantle.keyboard.Key;
import mantle.keyboard.Keyboard;
import openfl.Lib;
import openfl.display.StageDisplayState;

import fuse.robotlegs.window.model.WindowPositionModel;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
class FullscreenLogic 
{
	@inject public var windowPositionModel:WindowPositionModel;
	
	public function new() { }
	
	public function initialize():Void
	{
		Keyboard.onPress(Key.F, GoFullscreen).ctrl(true);
		Keyboard.onPress(Key.ESCAPE, ExitFullscreen);
		
		windowPositionModel.fullscreen.add(OnFullscreenChange);
	}
	
	function GoFullscreen() 
	{
		windowPositionModel.fullscreen.value = true;
	}
	
	function ExitFullscreen() 
	{
		windowPositionModel.fullscreen.value = false;
	}
	
	function OnFullscreenChange() 
	{
		if (windowPositionModel.fullscreen.value) {
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		else {
			Lib.current.stage.displayState = StageDisplayState.NORMAL;
		}
	}
}