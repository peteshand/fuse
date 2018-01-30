package fuse.robotlegs.scene.view;
import fuse.utilsSort.state.State;
import fuse.utils.delay.Delay;
import fuse.robotlegs.scene.view.ISceneView;
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * ...
 * @author P.J.Shand
 */
class SceneViewMediator extends Mediator 
{
	@inject public var view:ISceneView;
	@inject public var mediatorMap:IMediatorMap;
	private var state:State;
	
	public function new() { }	
	
	override public function initialize():Void
	{
		addState();
	}
	
	function addState() 
	{
		if (view.transition == null) Delay.nextFrame(addState);
		else {
			state = view.state;
			state.attachTransition(view.transition);
			var active:Bool = state.check();
			if (active) {
				view.transition.value = -1;
				view.transition.Show();
			}
		}
	}
	
	override public function destroy():Void
	{
		//if (state != null){
		//	state.removeTransition(view.transition);
		//	state.dispose();
		//}
	}
}