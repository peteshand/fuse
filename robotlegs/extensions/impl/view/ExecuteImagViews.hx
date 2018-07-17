package robotlegs.extensions.impl.view;

import mantle.view.ISceneView;
import mantle.view.SceneViewMediator;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ExecuteImagViews implements IConfig 
{
	@inject public var injector:IInjector;
	@inject public var configModel:IConfigModel;
	@inject public var mediatorMap:IMediatorMap;
	
	public function new() 
	{
		
	}
	
	public function configure():Void
	{
		mediatorMap.map(ISceneView).toMediator(SceneViewMediator);
	}
}