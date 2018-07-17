package robotlegs.extensions.impl.commands.viewportResize;

import mantle.managers.resize.Resize;
import openfl.display.Stage;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.IViewport;
import robotlegs.extensions.api.model.config.IConfigModel;


/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class FullStageViewportCommand extends Command 
{
	@inject public var viewport:IViewport;
	@inject public var contextView:ContextView;
	@inject public var configModel:IConfigModel;
	
	private var stage:Stage;
	
	public function new() 
	{
		
	}
	
	override public function execute():Void
	{
		//if (configModel.fullWindowResize){
			stage = contextView.view.stage;
			Resize.add(OnStageResize);
		//}
	}
	
	private function OnStageResize():Void 
	{
		viewport.setTo(0, 0, stage.stageWidth, stage.stageHeight);
	}
}