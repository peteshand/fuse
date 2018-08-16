package robotlegs.extensions.impl.commands.stageSetup;


import mantle.managers.resize.Resize;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import org.swiftsuspenders.utils.DescribedType;
#if starling
	import mantle.managers.layout2.LayoutManager;
#end
/**
 * ...
 * @author P.J.Shand
 */

@:keepSub
class StageSetupCommand extends Command
{
	@inject public var contextView:ContextView;
	
	public function new() 
	{
		
	}
	
	override public function execute():Void
	{
		var stage:Stage = contextView.view.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		#if starling
		mantle.managers.layout2.LayoutManager.stage = stage;
		//mantle.managers.layout.anchor.AnchorManager.stage = stage;
		//mantle.managers.layout.scale.ScaleManager.stage = stage;
		#end
		
		new Resize(stage);
	}
}