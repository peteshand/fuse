package mantle.view;

import condition.IState;
import transition.Transition;

/**
 * @author P.J.Shand
 */
interface ISceneView
{
	var transition:Transition;
	var state:IState;
}