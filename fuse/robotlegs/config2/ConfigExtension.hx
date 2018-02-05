package fuse.robotlegs.config2;

import fuse.robotlegs.config.signals.LoadConfigSignal;
import fuse.robotlegs.config2.model.IConfigModel;
import fuse.robotlegs.signalMap.api.ISignalCommandMap;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
class ConfigExtension implements IExtension
{
	public static var ConfigClass:Class<Dynamic>;
	
	var context:IContext;
	var injector:IInjector;
	
	var commandMap:ISignalCommandMap;
	
	public function new() { }
	
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
		
		//injector.map(SeedConfigLogic).asSingleton();
		//injector.map(CompileDefineFlagsLogic).asSingleton();
		
		//#if air
			//injector.map(AppFlagsLogic).asSingleton();
			//injector.map(StaticConfigLogic).asSingleton();
			//injector.map(DynamicConfigLogic).asSingleton();
			//injector.map(SaveActiveConfigLogic).asSingleton();
			//injector.map(CommandLineArgsConfigLogic).asSingleton();
			////injector.map(NetworkStatusLogic).asSingleton();
			//
		//#elseif html5
			//injector.map(HtmlFlagsLogic).asSingleton();
			//injector.map(HtmlDynamicConfigLogic).asSingleton();
			//injector.map(QueryConfigLogic).asSingleton();
			//injector.map(AttributeConfigLogic).asSingleton();
		//#end
		
		injector.map(IConfigModel).toSingleton(ConfigExtension.ConfigClass);
		injector.map(ConfigExtension.ConfigClass).toValue(injector.getInstance(IConfigModel));
		
		//injector.map(FlagsModel).asSingleton();
		//
		//injector.map(ConfigSaveService).asSingleton();
		//injector.map(ConfigLoadService).asSingleton();
		//injector.map(ConfigReadySignal).asSingleton();
		//injector.map(AppSetupCompleteSignal).asSingleton();
		
		injector.map(LoadConfigSignal).asSingleton();
		var loadConfigSignal:LoadConfigSignal = injector.getInstance(LoadConfigSignal);
		
		commandMap = injector.getInstance(ISignalCommandMap);
		//commandMap.map(LoadConfigSignal).toCommand(ConfigCommand);
		
		loadConfigSignal.dispatch();
	}
	
}