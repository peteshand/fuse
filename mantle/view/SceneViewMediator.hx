package mantle.view;
import condition.IState;
import condition.State;
import delay.Delay;
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
	private var state:IState;
	
	public function new() { }	
	
	override public function initialize():Void
	{
		Delay.nextFrame(addState);
	}
	
	function addState() 
	{
		if (view.transition == null) Delay.nextFrame(addState);
		else {
			view.transition.state = state = view.state;
			var active:Bool = state.check();
			if (active) {
				view.transition.value = -1;
				view.transition.Show();
			}
		}
	}
	
	override public function destroy():Void
	{
		if (state != null){
			view.transition.state = null;
		}
	}
}