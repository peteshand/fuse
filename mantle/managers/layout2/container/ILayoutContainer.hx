package mantle.managers.layout2.container;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * @author P.J.Shand
 */
interface ILayoutContainer 
{
	var bounds(get, null):Rectangle;
	var transform(get, set):Matrix;
	var nested(get, set):Bool;
}