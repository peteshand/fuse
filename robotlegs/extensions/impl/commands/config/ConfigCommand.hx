package robotlegs.extensions.impl.commands.config;


import mantle.delay.Delay;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.logic.config.app.SeedConfigLogic;
import robotlegs.extensions.impl.logic.flags.compile.CompileDefineFlagsLogic;

#if (air && !mobile)
	import robotlegs.extensions.impl.logic.flags.app.AppFlagsLogic;
	import robotlegs.extensions.impl.logic.config.app.DynamicConfigLogic;
	import robotlegs.extensions.impl.logic.config.app.SaveActiveConfigLogic;
	import robotlegs.extensions.impl.logic.config.app.StaticConfigLogic;
	import robotlegs.extensions.impl.logic.config.app.CommandLineArgsConfigLogic;
#elseif (html5 && !electron)
	import robotlegs.extensions.impl.logic.flags.html.HtmlFlagsLogic;
	import robotlegs.extensions.impl.logic.config.html.HtmlDynamicConfigLogic;
	import robotlegs.extensions.impl.logic.config.html.AttributeConfigLogic;
	import robotlegs.extensions.impl.logic.config.html.QueryConfigLogic;
#end

//import robotlegs.extensions.impl.signals.startup.ConfigReadySignal;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ConfigCommand extends Command 
{
	@inject public var configModel:IConfigModel;
	//@inject public var configReadySignal:ConfigReadySignal;
	@inject public var seedConfigLogic:SeedConfigLogic;
	
	@inject public var compileDefineFlagsLogic:CompileDefineFlagsLogic;
	#if (air && !mobile)
		@inject public var appFlagsLogic:AppFlagsLogic;
		@inject public var dynamicConfigLogic:DynamicConfigLogic;
		@inject public var staticConfigLogic:StaticConfigLogic;
		@inject public var saveActiveConfigLogic:SaveActiveConfigLogic;
		@inject public var commandLineArgsConfigLogic:CommandLineArgsConfigLogic;
	#elseif (html5 && !electron)
		@inject public var htmlFlagsLogic:HtmlFlagsLogic;
		@inject public var htmlDynamicConfigLogic:HtmlDynamicConfigLogic;
		@inject public var attributeConfigLogic:AttributeConfigLogic;
		@inject public var queryConfigLogic:QueryConfigLogic;
	#end
	
	public function new() { }
	
	override public function execute():Void
	{
		/*#if (air && !mobile)
			configSaveService.copyGlobalSeed();
		#end*/
		
		compileDefineFlagsLogic.init();
		
		#if (air && !mobile)
			appFlagsLogic.init();
		#end
		
		seedConfigLogic.init();
		
		#if (air && !mobile)
			staticConfigLogic.init();
			dynamicConfigLogic.init();
			commandLineArgsConfigLogic.init();
			// for reference only
			saveActiveConfigLogic.init();
		#elseif (html5 && !electron)
			htmlFlagsLogic.init();
			attributeConfigLogic.init();
			queryConfigLogic.init();
		#end
		
		
		
		//configLoadService.onLoadComplete.add(OnLoadComplete);
		//configLoadService.init();
		
		OnLoadComplete();
	}
	
	function OnLoadComplete() 
	{
		// Wait for file to be closed
		Delay.nextFrame(Proceed);
	}
	
	function Proceed() 
	{
		//configReadySignal.dispatch();
	}
}