package robotlegs.bundles;

import robotlegs.bender.bundles.mvcs.MVCSBundle;
import robotlegs.bender.extensions.display.stage3D.Stage3DStackExtension;
import robotlegs.extensions.impl.CoreCommandExtension;
import robotlegs.extensions.impl.CoreLogicExtension;
import robotlegs.extensions.impl.CoreModelExtension;
import robotlegs.extensions.impl.CoreServiceExtension;
import robotlegs.extensions.impl.CoreSignalExtension;
import robotlegs.extensions.impl.CoreViewExtension;
import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.LogLevel;

/**
 * The <code>CoreBundle</code> class will include all extensions
 * which are required to create basic sytle applications.
 */

@:keepSub
class CoreBundle implements IBundle
{
	public static var VERSION:String = "1.2";
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install([MVCSBundle]);
		
		context.logLevel = LogLevel.INFO;
		
		context.install([
			ManualStageObserverExtension, 
			SignalCommandMapExtension, 
			CoreLogicExtension,
			CoreViewExtension,
			CoreSignalExtension,
			CoreModelExtension,
			CoreServiceExtension,
			CoreCommandExtension,
			Stage3DStackExtension
		]);
	}
}