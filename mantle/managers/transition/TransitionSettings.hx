package mantle.managers.transition;
import motion.easing.Expo;
import motion.easing.IEasing;

/**
 * ...
 * @author P.J.Shand
 */

typedef TransitionSettings =
{
	?showEase:IEasing,
	?hideEase:IEasing,
	//?autoVisible:Bool,
	?autoVisObject:AutoVisObject,
	?ease:IEasing,
	?start:Float,
	?end:Float,
	?startHidden:Bool
	//?relative:Bool/* = false*/
}

typedef AutoVisObject =
{
	visible:Bool
}