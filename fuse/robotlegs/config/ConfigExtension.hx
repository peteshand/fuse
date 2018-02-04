package fuse.robotlegs.config;

import fuse.robotlegs.config.commands.ConfigCommand;
import fuse.robotlegs.config.logic.app.SeedConfigLogic;
import fuse.robotlegs.config.logic.flags.compile.CompileDefineFlagsLogic;
import fuse.robotlegs.config.model.FlagsModel;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.services.ConfigLoadService;
import fuse.robotlegs.config.services.ConfigSaveService;
import fuse.robotlegs.config.signals.AppSetupCompleteSignal;
import fuse.robotlegs.config.signals.ConfigReadySignal;
import fuse.robotlegs.config.signals.LoadConfigSignal;
import fuse.robotlegs.signalMap.api.ISignalCommandMap;

import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

#if air
	
import fuse.robotlegs.config.logic.flags.app.AppFlagsLogic;
import fuse.robotlegs.config.logic.app.StaticConfigLogic;
import fuse.robotlegs.config.logic.app.DynamicConfigLogic;
import fuse.robotlegs.config.logic.app.SaveActiveConfigLogic;
import fuse.robotlegs.config.logic.app.CommandLineArgsConfigLogic;

#elseif html5
	
import fuse.robotlegs.config.logic.flags.html.HtmlFlagsLogic;
import fuse.robotlegs.config.logic.html.AttributeConfigLogic;
import fuse.robotlegs.config.logic.html.HtmlDynamicConfigLogic;
import fuse.robotlegs.config.logic.html.QueryConfigLogic;

#end

/**
 * ...
 * @author P.J.Shand
 */
class ConfigExtension implements IExtension
{
	var context:IContext;
	var injector:IInjector;
	
	public static var ConfigClass:Class<Dynamic>;
	var commandMap:ISignalCommandMap;
	
	public function new() 
	{
		
	}
	
	/* INTERFACE robotlegs.bender.framework.api.IExtension */
	
	public function extend(context:IContext):Void 
	{
		injector = context.injector;
		this.context = context;
		
		context.addConfigHandler(InstanceOfType.call(IConfigModel), handleConfigModel);
	}
	
	private function handleConfigModel(configModel:IConfigModel):Void
	{
		#if cpp
			ConfigExtension.ConfigClass = Type.getClass(configModel);
		#else
			ConfigExtension.ConfigClass = Reflect.getProperty(configModel, "constructor");
		#end
		
		injector.map(SeedConfigLogic).asSingleton();
		injector.map(CompileDefineFlagsLogic).asSingleton();
		
		#if air
			injector.map(AppFlagsLogic).asSingleton();
			injector.map(StaticConfigLogic).asSingleton();
			injector.map(DynamicConfigLogic).asSingleton();
			injector.map(SaveActiveConfigLogic).asSingleton();
			injector.map(CommandLineArgsConfigLogic).asSingleton();
			//injector.map(NetworkStatusLogic).asSingleton();
			
		#elseif html5
			injector.map(HtmlFlagsLogic).asSingleton();
			injector.map(HtmlDynamicConfigLogic).asSingleton();
			injector.map(QueryConfigLogic).asSingleton();
			injector.map(AttributeConfigLogic).asSingleton();
		#end
		
		injector.map(IConfigModel).toSingleton(ConfigExtension.ConfigClass);
		injector.map(ConfigExtension.ConfigClass).toValue(injector.getInstance(IConfigModel));
		injector.map(FlagsModel).asSingleton();
		
		injector.map(ConfigSaveService).asSingleton();
		injector.map(ConfigLoadService).asSingleton();
		injector.map(ConfigReadySignal).asSingleton();
		injector.map(AppSetupCompleteSignal).asSingleton();
		
		injector.map(LoadConfigSignal).asSingleton();
		var loadConfigSignal:LoadConfigSignal = injector.getInstance(LoadConfigSignal);
		
		commandMap = injector.getInstance(ISignalCommandMap);
		commandMap.map(LoadConfigSignal).toCommand(ConfigCommand);
		
		loadConfigSignal.dispatch();
	}
}