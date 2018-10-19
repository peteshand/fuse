package robotlegs.extensions.impl.model;

import mantle.model.scene.SceneModel;
import robotlegs.extensions.impl.services.activity.ActivityMonitorService;
import robotlegs.bender.framework.api.IConfig;
import org.swiftsuspenders.utils.DescribedType;
/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class ExecuteImagModels implements DescribedType implements IConfig 
{
	@inject public var sceneModel:SceneModel;
	@inject public var activityMonitorService:ActivityMonitorService;
	
	public function new() 
	{
		
	}
	
	public function configure():Void
	{
		activityMonitorService.start();
	}
}