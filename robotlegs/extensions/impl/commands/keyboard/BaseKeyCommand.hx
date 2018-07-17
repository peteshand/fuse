package robotlegs.extensions.impl.commands.keyboard;
import mantle.keyboard.Key;
import mantle.keyboard.Keyboard;
import mantle.util.app.App;
import mantle.time.GlobalTime;
import openfl.display.StageDisplayState;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
using Logger;

/**
 * ...
 * @author P.J.Shand
 */
class BaseKeyCommand extends Command 
{
	@inject public var contextView:ContextView;
	//@inject public var configModel:CoreConfigModel;
	
	public function new() { }
	
	override public function execute():Void
	{
		Keyboard.onPress(Key.Q, App.exit ).ctrl(true);
		
		// Fullscreen is done on a per platform basis within platform-specific commands
		//Keyboard.onPress(GoFullScreen, Key.F, { ctrl:true } );
		Keyboard.onPress(Key.MINUS, TimeOffset, [-1000] ).shift(true).alt(true);
		Keyboard.onPress(Key.EQUAL, TimeOffset, [1000] ).shift(true).alt(true);
		Keyboard.onPress(Key.NUMBER_8, PausePlayback, [false] ).shift(true).alt(true);
		Keyboard.onPress(Key.NUMBER_9, PausePlayback, [true] ).shift(true).alt(true);
		
		Keyboard.onPress(Key.NUMBER_0, ResetTimeOffset).shift(true).alt(true);
		
		#if (debug && starling)
			Keyboard.onPress(Key.C, RefreshContext).ctrl(true).shift(true).alt(true);
			
			//Keyboard.onPress(Key.S, SaveToConfig).ctrl(true).shift(true).alt(true);
			//Keyboard.onPress(Key.A, SaveLocationToConfig).ctrl(true).shift(true).alt(true);
			
		#end
		
		Keyboard.onPress(Key.Q, TestCriticalError ).ctrl(true).shift(true).alt(true);
	}
	
	function TestCriticalError() 
	{
		criticalError("Critical Error Test");
	}
	
	/*function SaveLocationToConfig() 
	{
		configModel.setLocation("test", "seed");
	}
	
	function SaveToConfig() 
	{
		configModel.set("test", "test");
	}*/
	
	#if starling
	function RefreshContext() 
	{
		starling.core.Starling.current.context.dispose();
	}
	#end
	
	function PausePlayback(value:Bool) 
	{
		GlobalTime.pause = value;
	}
	
	function TimeOffset(offset:Int) 
	{
		GlobalTime.offset += offset;
	}
	
	function ResetTimeOffset() 
	{
		GlobalTime.offset += 0;
	}
	
	/*private function GoFullScreen():Void 
	{
		#if air3
			contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			if (contextView.view.stage.nativeWindow != null) {	//seems to be null on the tablet		
				contextView.view.stage.nativeWindow.activate();
			}
		#else
			contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN;
		#end
	}*/
}