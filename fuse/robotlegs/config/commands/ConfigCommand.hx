package fuse.robotlegs.config.commands;


import robotlegs.bender.bundles.mvcs.Command;
import fuse.utilsSort.FilePermissions;

import fuse.utils.delay.Delay;
import fuse.robotlegs.config.IConfigModel;
import fuse.robotlegs.config.logic.app.SeedConfigLogic;
import fuse.robotlegs.config.logic.flags.compile.CompileDefineFlagsLogic;
import fuse.robotlegs.config.signals.ConfigReadySignal;
import fuse.robotlegs.config.signals.AppSetupCompleteSignal;

#if air
	import fuse.robotlegs.config.logic.flags.app.AppFlagsLogic;
	import fuse.robotlegs.config.logic.app.DynamicConfigLogic;
	import fuse.robotlegs.config.logic.app.SaveActiveConfigLogic;
	import fuse.robotlegs.config.logic.app.StaticConfigLogic;
	import fuse.robotlegs.config.logic.app.CommandLineArgsConfigLogic;
#elseif html5
	import fuse.robotlegs.config.logic.flags.html.HtmlFlagsLogic;
	import fuse.robotlegs.config.logic.html.HtmlDynamicConfigLogic;
	import fuse.robotlegs.config.logic.html.AttributeConfigLogic;
	import fuse.robotlegs.config.logic.html.QueryConfigLogic;
#end

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ConfigCommand extends Command 
{
	@inject public var configModel:IConfigModel;
	@inject public var configReadySignal:ConfigReadySignal;
	@inject public var appReady:AppSetupCompleteSignal;
	@inject public var seedConfigLogic:SeedConfigLogic;
	
	@inject public var compileDefineFlagsLogic:CompileDefineFlagsLogic;
	#if air
		@inject public var appFlagsLogic:AppFlagsLogic;
		@inject public var dynamicConfigLogic:DynamicConfigLogic;
		@inject public var staticConfigLogic:StaticConfigLogic;
		@inject public var saveActiveConfigLogic:SaveActiveConfigLogic;
		@inject public var commandLineArgsConfigLogic:CommandLineArgsConfigLogic;
	#elseif html5
		@inject public var htmlFlagsLogic:HtmlFlagsLogic;
		@inject public var htmlDynamicConfigLogic:HtmlDynamicConfigLogic;
		@inject public var attributeConfigLogic:AttributeConfigLogic;
		@inject public var queryConfigLogic:QueryConfigLogic;
	#end
	
	public function new() { }
	
	override public function execute():Void
	{
		FilePermissions.request(OnComplete);
	}
	
	function OnComplete(accessGranted:Bool) 
	{
		if (!accessGranted) {
			trace("File access denied!");
			return;
		}
		
		/*#if (flash && !test_flash)
			configSaveService.copyGlobalSeed();
		#end*/
		
		compileDefineFlagsLogic.init();
		
		#if air
			appFlagsLogic.init();
		#elseif html5
			htmlFlagsLogic.init();
		#end
		
		seedConfigLogic.init();
		
		#if air
			staticConfigLogic.init();
			dynamicConfigLogic.init();
			commandLineArgsConfigLogic.init();
			// for reference only
			saveActiveConfigLogic.init();
		#elseif html5
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
		configReadySignal.dispatch();
		appReady.dispatch();
	}
}