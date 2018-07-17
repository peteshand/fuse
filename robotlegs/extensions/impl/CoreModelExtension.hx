package robotlegs.extensions.impl;

import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.model.activity.ActivityModel;
import robotlegs.extensions.impl.model.ExecuteImagModels;
import mantle.model.scene.SceneModel;
import robotlegs.extensions.impl.model.flags.FlagsModel;
import robotlegs.extensions.impl.model.fps.FPSThrottleModel;

#if (air && !mobile)
import robotlegs.extensions.impl.model.network.NetworkStatusModel;
#end

import robotlegs.extensions.impl.model.timeout.TimeoutModel;
import robotlegs.bender.extensions.matching.InstanceOfType;
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
class CoreModelExtension implements IExtension
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	public static var ConfigClass:Class<Dynamic>;
	private var _uid = UID.create(CoreModelExtension);
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
		
		
		context.addConfigHandler(InstanceOfType.call(IConfigModel), handleConfigModel);
		injector.map(ActivityModel).asSingleton();
		injector.map(TimeoutModel).asSingleton();
		injector.map(FPSThrottleModel).asSingleton();
		injector.map(SceneModel).asSingleton();
		injector.map(FlagsModel).asSingleton();
		
		
		
		#if (air && !mobile)
			injector.map(NetworkStatusModel).asSingleton();
		#end
		
		context.configure(ExecuteImagModels);
	}
	
	private function handleConfigModel(configModel:IConfigModel):Void
	{
		//ImagModelExtension.ConfigClass = configModel.constructor;
		#if cpp
			CoreModelExtension.ConfigClass = Type.getClass(configModel);
		#else
			CoreModelExtension.ConfigClass = Reflect.getProperty(configModel, "constructor");
		#end
		injector.map(IConfigModel).toSingleton(CoreModelExtension.ConfigClass);
	}
	
	public function toString():String
	{
		return _uid;
	}
}