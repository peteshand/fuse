package robotlegs.extensions.impl.model;

import mantle.model.scene.SceneModel;
import robotlegs.extensions.impl.services.activity.ActivityMonitorService;
import robotlegs.bender.framework.api.IConfig;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ExecuteImagModels implements IConfig 
{
	@inject public var sceneModel:SceneModel;
	@inject public var activityMonitorService:ActivityMonitorService;
	
	public function new() 
	{
		
	}
	
	public function configure():Void
	{
		if (SceneModel.instance == null) SceneModel.instance = sceneModel;
		activityMonitorService.start();
	}
}