package fuse.core.memory.data.displayData;

import kha.Color;

/**
 * @author P.J.Shand
 */
interface IDisplayData 
{
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var pivotX(get, set):Float;
	public var pivotY(get, set):Float;
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	public var rotation(get, set):Float;
	public var alpha(get, set):Float;
	public var color(get, set):Color;
	public var objectId(get, null):Int;
	public var textureId(get, set):Int;
	
	//public var isStatic(get, set):Int;
	public var applyPosition(get, set):Int;
	public var applyRotation(get, set):Int;
	
}