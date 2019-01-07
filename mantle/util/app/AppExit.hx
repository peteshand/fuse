package mantle.util.app;

import delay.Delay;


#if openfl
import openfl.Lib;
import openfl.display.Stage;
#end

#if air
import flash.desktop.NativeApplication;
#elseif js
import js.html.Event;
#end

import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
@:allow(mantle.util.app.App)
class AppExit
{
	static private var exitConfirmers:Array<ExitConfirmer> = [];
	static private var exitCleanups:Array<ExitCleanup> = [];
	static private var ignoreExit:Bool;
	static private var callingExit:Bool;
	static private var exitingexitCode:Null<Int>;
	static private var isSetup:Bool;
	static private var awaitingCleanups:Int;
	
	public function new() 
	{
		
	}
	
	static public function setup() 
	{
		if (isSetup) return;
		isSetup = true;
		#if (js||air)
		App.windows.lastWindowClosing.add(onLastWindowClosing);
		#end
	}
	
	static private function onLastWindowClosing(cancel:Void->Void) : Void
	{
		var exitCode:Int;
		if (exitingexitCode == null){
			exitCode = 1; // This exit wasn't triggered by App.exit, so we'll assume it's an error.
		}else{
			exitCode = exitingexitCode;
		}
		//trace("onBeginExit: "+exitCode+" "+exitingexitCode);
		handleExitEvent(exitCode, cancel);
	}
	
	static public function exit(exitCode:Int = 0) 
	{
		if (exitingexitCode != null || ignoreExit || callingExit){
			return;
		}
		exitingexitCode = exitCode;
		handleExitEvent(exitCode, function(){});
		exitingexitCode = null;
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
			return callingExit;
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
				#if (air||js)
				App.windows.hideAll();
				#end
				awaitingCleanups = exitCleanups.length;
				for (cleanup in exitCleanups){
					cleanup(exitCode, onCleanupDone.bind(exitCode));
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
		ignoreExit = true;
		#if (js||air)
		App.windows.closeAll();
		App.windows.exit(exitCode);
		#end
		ignoreExit = false;
		callingExit = false;
	}
}

typedef ExitConfirmer = Int -> ExitContinue -> Void;
typedef ExitContinue = Bool -> Void;
typedef ExitCleanup = Int -> (Void -> Void) -> Void;