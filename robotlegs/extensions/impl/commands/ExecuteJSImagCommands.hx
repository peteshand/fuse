package robotlegs.extensions.impl.commands;

import robotlegs.extensions.impl.commands.fullscreen.HTMLFullscreenCommand;
import robotlegs.extensions.impl.commands.ExecuteImagCommands;
import robotlegs.extensions.impl.signals.startup.ConfigReadySignal;
import robotlegs.bender.framework.api.IConfig;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ExecuteJSImagCommands extends ExecuteImagCommands implements IConfig 
{
	public function new() 
	{
		super();
	}
	
	override public function configure():Void
	{
		commandMap.map(ConfigReadySignal).toCommand(HTMLFullscreenCommand).once();
		
		super.configure();
	}
}