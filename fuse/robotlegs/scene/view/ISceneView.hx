package fuse.robotlegs.scene.view;
import fuse.utilsSort.state.State;
import fuse.utilsSort.transition.Transition;

/**
 * @author P.J.Shand
 */
interface ISceneView 
{
	var transition:Transition;
	var state:State;
}