package robotlegs.extensions.impl;


import robotlegs.extensions.impl.logic.config.app.SeedConfigLogic;
import robotlegs.extensions.impl.logic.flags.compile.CompileDefineFlagsLogic;
#if (air && !mobile)
	import robotlegs.extensions.impl.logic.config.app.DynamicConfigLogic;
	import robotlegs.extensions.impl.logic.config.app.SaveActiveConfigLogic;
	import robotlegs.extensions.impl.logic.config.app.StaticConfigLogic;
	import robotlegs.extensions.impl.logic.flags.app.AppFlagsLogic;
	import robotlegs.extensions.impl.logic.config.app.CommandLineArgsConfigLogic;
#elseif html5
	import robotlegs.extensions.impl.logic.flags.html.HtmlFlagsLogic;
	import robotlegs.extensions.impl.logic.config.html.AttributeConfigLogic;
	import robotlegs.extensions.impl.logic.config.html.QueryConfigLogic;
	import robotlegs.extensions.impl.logic.config.html.HtmlDynamicConfigLogic;
#end
import robotlegs.extensions.impl.logic.network.NetworkStatusLogic;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 * 
 */
@:keepSub
class CoreLogicExtension implements IExtension
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var context:IContext;
	private var injector:IInjector;
	
	public function new() { }
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function extend(context:IContext):Void
	{
		this.context = context;
		injector = context.injector;
		
		injector.map(SeedConfigLogic).asSingleton();
		injector.map(CompileDefineFlagsLogic).asSingleton();
		
		#if (air && !mobile)
			injector.map(AppFlagsLogic).asSingleton();
			injector.map(StaticConfigLogic).asSingleton();
			injector.map(DynamicConfigLogic).asSingleton();
			injector.map(SaveActiveConfigLogic).asSingleton();
			injector.map(CommandLineArgsConfigLogic).asSingleton();
			injector.map(NetworkStatusLogic).asSingleton();
			
		#elseif (html5 && !electron)
			injector.map(HtmlFlagsLogic).asSingleton();
			injector.map(HtmlDynamicConfigLogic).asSingleton();
			injector.map(QueryConfigLogic).asSingleton();
			injector.map(AttributeConfigLogic).asSingleton();
		#end
	}
}