package mantle.view;

import mantle.managers.state.IState;
import mantle.managers.transition.Transition;

/**
 * @author P.J.Shand
 */
interface ISceneView
{
	var transition:Transition;
	var state:IState;
}