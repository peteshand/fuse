package robotlegs.extensions.impl.commands;

import robotlegs.extensions.impl.commands.alwaysOnTop.AlwaysOnTopCommand;
import robotlegs.extensions.impl.commands.fullscreen.AirFullscreenCommand;
import robotlegs.extensions.impl.commands.screenPosition.ScreenPositionCommand;
import robotlegs.extensions.impl.commands.ExecuteImagCommands;
import robotlegs.extensions.impl.signals.startup.InitializeAppSignal;
//import robotlegs.extensions.impl.signals.startup.ConfigReadySignal;
import robotlegs.bender.framework.api.IConfig;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ExecuteFlashImagCommands extends ExecuteImagCommands implements IConfig 
{
	public function new() 
	{
		super();
	}
	
	override public function configure():Void
	{
		//commandMap.map(InitializeAppSignal).toCommand(ReplayCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(AirFullscreenCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(ScreenPositionCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(AlwaysOnTopCommand).once();
		
		super.configure();
	}
}