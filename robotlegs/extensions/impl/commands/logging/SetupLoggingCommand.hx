package robotlegs.extensions.impl.commands.logging;

#if flash
	import mantle.util.log.air.DefaultAirDesktopLog;
#elseif html5
	import mantle.util.log.js.DefaultJsLog;
#end
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;

/**
 * ...
 * @author Thomas Byrne
 */
class SetupLoggingCommand extends Command
{
	@inject public var contextView:ContextView;
	@inject("optional=true") public var configModel:IConfigModel;
	
	public function new() 
	{
		
	}
		
	override public function execute():Void
	{
		if (configModel==null) return;
		if (configModel.logErrors) {
			#if (flash&&!mobile)
				DefaultAirDesktopLog.install(contextView.view, null);
			#elseif html5
				DefaultJsLog.install();
			#end
		}
	}
}