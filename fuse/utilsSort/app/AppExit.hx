package fuse.utilsSort.app;
import fuse.utilsSort.window.AppWindows;
import fuse.utilsSort.app.App;
import fuse.utils.delay.Delay;
import fuse.utilsSort.window.AppWindows.AppWindow;

#if openfl
import openfl.Lib;
import openfl.display.Stage;
#end

#if air
import flash.desktop.NativeApplication;
import flash.events.Event;

#elseif js
import js.html.Event;

#end


/**
 * ...
 * @author P.J.Shand
 */
@:allow(fuse.utilsSort.app.App)
@:allow(fuse.utilsSort.window.AppWindows)
class AppExit
{
	static private var exitConfirmers:Array<ExitConfirmer> = [];
	static private var exitCleanups:Array<ExitCleanup> = [];
	static private var ignoreExit:Bool;
	static private var callingExit:Bool;
	static private var exitingExitCode:Null<Int>;
	static private var isSetup:Bool;
	static private var awaitingCleanups:Int;
	static private var stillCallingNativeExit:Bool;
	
	public function new() 
	{
		
	}
	
	static public function setup() 
	{
		if (isSetup) return;
		isSetup = true;
		App.windows.lastWindowClosing.add(onLastWindowClosing);
	}
	
	static private function onLastWindowClosing(cancel:Void->Void) : Void
	{
		var exitCode:Int;
		#if js
			exitCode = 0;
		#else
			if (exitingExitCode == null){
				exitCode = 1; // This exit wasn't triggered by App.exit, so we'll assume it's an error.
			}else{
				exitCode = exitingExitCode;
			}
		#end
		//trace("onBeginExit: "+exitCode+" "+exitingexitCode);
		stillCallingNativeExit = true;
		handleExitEvent(exitCode, cancel);
		stillCallingNativeExit = false;
		
		#if !js
		if (!callingExit){
			finaliseExit(exitCode);
		}
		#end
	}
	
	static public function exit(exitCode:Int = 0) 
	{
		if (exitingExitCode != null || ignoreExit || callingExit){
			return;
		}
		exitingExitCode = exitCode;
		handleExitEvent(exitCode, function(){});
		exitingExitCode = null;
	}
	
	static public function addExitConfirmer(handler:Int -> ExitContinue -> Void) 
	{
		setup();
		exitConfirmers.push(handler);
		
	}
	static public function removeExitConfirmer(handler:Int -> ExitContinue -> Void) 
	{
		exitConfirmers.remove(handler);
	}
	
	static public function addExitCleanup(handler:Int -> (Void -> Void) -> Void) 
	{
		setup();
		exitCleanups.push(handler);
		
	}
	static public function removeExitCleanup(handler:Int -> (Void -> Void) -> Void) 
	{
		exitCleanups.remove(handler);
	}
	
	static private function handleExitEvent(exitCode:Int, cancel:Void->Void) :Bool
	{
		if (ignoreExit || callingExit) return false;
		if (exitConfirmers.length > 0 || exitCleanups.length > 0) {
			callingExit = true;
			callExitConfirmer(exitCode, 0);
			if (callingExit){
				cancel();
			}
			trace("callingExit: " + callingExit);
			return !callingExit;
		}else{
			finaliseExit(exitCode);
			return true;
		}
	}
	
	static private function callExitConfirmer(exitCode:Int, ind:Int) 
	{
		if (ind >= exitConfirmers.length) {
			if (exitCleanups.length == 0){
				finaliseExit(exitCode);
			}else{
				if(App.windows.hideSupported) App.windows.hideAll();
				awaitingCleanups = exitCleanups.length;
				for (cleanup in exitCleanups){
					try{
						cleanup(exitCode, onCleanupDone.bind(exitCode));
					}catch (e:Dynamic){
						onCleanupDone(exitCode);
					}
				}
				if(callingExit) Delay.byTime(10, finaliseExit.bind(exitCode)); // Give cleanups a maximum of 10 seconds to run
			}
			
		}else {
			var exitConfirmer:ExitConfirmer = exitConfirmers[ind];
			exitConfirmer(exitCode, doExitContinue.bind(_, exitCode, ind + 1));
		}
	}
	
	static private function onCleanupDone(exitCode:Int) 
	{
		awaitingCleanups--;
		if (awaitingCleanups == 0){
			finaliseExit(exitCode);
		}
	}
	
	static private function doExitContinue(cont:Bool, exitCode:Int, ind:Int) 
	{
		if (!cont){
			return;
		}
		callExitConfirmer(exitCode, ind);
	}
	
	static private function finaliseExit(exitCode:Int) 
	{
		if(!stillCallingNativeExit){
			ignoreExit = true;
			App.windows.closeAll();
			App.windows.exit(exitCode);
			ignoreExit = false;
		}
		callingExit = false;
	}
}

typedef ExitConfirmer = Int -> ExitContinue -> Void;
typedef ExitContinue = Bool -> Void;
typedef ExitCleanup = Int -> (Void -> Void) -> Void;