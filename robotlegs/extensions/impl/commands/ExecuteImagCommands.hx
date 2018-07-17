package robotlegs.extensions.impl.commands;

import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.CoreModelExtension;
//import robotlegs.extensions.impl.commands.assets.SetupAssetsCommand;
//import robotlegs.extensions.impl.commands.assets.SetupS3ResourceSyncCommand;
import robotlegs.extensions.impl.commands.config.ConfigCommand;
import robotlegs.extensions.impl.commands.keyboard.BaseKeyCommand;
//import robotlegs.extensions.impl.commands.layout.SetupLayoutCommand;
import robotlegs.extensions.impl.commands.logging.SetupLoggingCommand;
import robotlegs.extensions.impl.commands.stageSetup.StageSetupCommand;
import robotlegs.extensions.impl.commands.viewportResize.FullStageViewportCommand;
//import robotlegs.extensions.impl.signals.LoadConfigSignal;
//import robotlegs.extensions.impl.signals.ModifyConfigSignal;
//import robotlegs.extensions.impl.signals.assets.S3ResourceSyncComplete;
//import robotlegs.extensions.impl.signals.startup.AssetsReadySignal;
//import robotlegs.extensions.impl.signals.startup.ConfigReadySignal;
import robotlegs.extensions.impl.signals.startup.InitializeAppSignal;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ExecuteImagCommands implements IConfig 
{
	@inject public var commandMap:ISignalCommandMap;
	@inject public var injector:IInjector;
	@inject public var configModel:IConfigModel;
	
	@inject public var initializeAppSignal:InitializeAppSignal;
	//@inject public var loadConfigSignal:LoadConfigSignal;
	//@inject public var assetsReadySig:AssetsReadySignal;
	
	
	public function new() 
	{
		
	}
	
	public function configure():Void
	{
		//assetsReadySig.add(onAssetsReady);
		
		//trace("configModel = " + configModel);
		
		commandMap.map(InitializeAppSignal).toCommand(StageSetupCommand).once();
		//commandMap.map(InitializeAppSignal).toCommand(SetupAssetsCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(SetupLoggingCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(BaseKeyCommand).once();
		
		//commandMap.map(ConfigReadySignal).toCommand(SetupLayoutCommand).once();
		commandMap.map(InitializeAppSignal).toCommand(FullStageViewportCommand).once();
		
		//commandMap.map(ConfigReadySignal).toCommand(SetupS3ResourceSyncCommand).once();
		//injector.map(S3ResourceSyncComplete).asSingleton();
		
		setupSwfCommands();
		
		injector.map(CoreModelExtension.ConfigClass).toValue(configModel);
		
		//commandMap.map(LoadConfigSignal).toCommand(ConfigCommand);
		//loadConfigSignal.dispatch();
		
		initializeAppSignal.dispatch();
	}
	
	function onAssetsReady() 
	{
		
	}
	
	private function setupSwfCommands():Void 
	{
		
	}
}