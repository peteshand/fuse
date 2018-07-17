package robotlegs.extensions.impl;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.UID;

#if flash
	import robotlegs.extensions.impl.commands.ExecuteFlashImagCommands;
#elseif js
	import robotlegs.extensions.impl.commands.ExecuteJSImagCommands;
#end
/**
 * ...
 * @author P.J.Shand
 * 
 */
@:keepSub
class CoreCommandExtension implements IExtension
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	
	private var _uid:String;
	private var context:IContext;
	private var injector:IInjector;
	
	public function new() { }
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function extend(context:IContext):Void
	{
		_uid = UID.create(CoreCommandExtension);
		
		this.context = context;
		injector = context.injector;
		
		#if flash
			context.configure([ExecuteFlashImagCommands]);
		#elseif js
			context.configure([ExecuteJSImagCommands]);
		#end
		
	}
	
	public function toString():String
	{
		return _uid;
	}
}