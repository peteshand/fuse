package robotlegs.extensions.impl;

//import robotlegs.extensions.impl.signals.AppSetupCompleteSignal;
//import robotlegs.extensions.impl.signals.startup.AssetsReadySignal;
//import robotlegs.extensions.impl.signals.startup.ConfigReadySignal;
import robotlegs.extensions.impl.signals.startup.InitializeAppSignal;
//import robotlegs.extensions.impl.signals.LoadConfigSignal;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.UID;

/**
 * ...
 * @author P.J.Shand
 * 
 */
@:keepSub
class CoreSignalExtension implements IExtension
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	
	private var _uid:String = UID.create(CoreSignalExtension);
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
		
		context.injector.map(InitializeAppSignal).asSingleton();
		//context.injector.map(LoadConfigSignal).asSingleton();
		//context.injector.map(AssetsReadySignal).asSingleton();
		//context.injector.map(ConfigReadySignal).asSingleton();
		//context.injector.map(AppSetupCompleteSignal).asSingleton();
	}
	
	public function toString():String
	{
		return _uid;
	}
}