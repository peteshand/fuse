package fuse.robotlegs.scene;

import fuse.robotlegs.scene.model.SceneModel;
import fuse.robotlegs.scene.view.ISceneView;
import fuse.robotlegs.scene.view.SceneViewMediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
class SceneExtension implements IExtension
{
	var injector:IInjector;
	var mediatorMap:IMediatorMap;
	
	public function new() { }
	
	public function extend(context:IContext):Void 
	{
		injector = context.injector;
		injector.map(SceneModel).toValue(SceneModel.instance);
		
		mediatorMap = injector.getInstance(IMediatorMap);
		mediatorMap.map(ISceneView).toMediator(SceneViewMediator);
	}
	
}