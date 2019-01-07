package mantle.view;

import fuse.display.Sprite;
import condition.IState;
import transition.Transition;

class BaseSceneView extends Sprite implements ISceneView
{
    public var transition = new Transition();
	public var state:IState;

    public function new(state:IState)
    {
        this.state = state;
        super();
        transition.add(this);
    }
}