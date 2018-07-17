package mantle.managers.layout2.items;
import mantle.managers.layout2.settings.LayoutSettings;

import mantle.managers.layout2.settings.LayoutScale;
import mantle.managers.layout2.settings.LayoutSettings.RectDef;

/**
 * @author P.J.Shand
 */
interface ITransformObject 
{
	/** Defines the "frame" in which the display object should be aligned, if frame is not set the stage will be used */
	function frame(value:Dynamic):ITransformObject;
	/** Defines fraction and/or pixel frame align values. This values will not scale with the LayoutScale mode */
	function align(fractionX:Float = 0, fractionY:Float = 0, pixelX:Float = 0, pixelY:Float = 0):ITransformObject;
	/** Defines fraction and/or pixel anchor points within the display object. This values will scale with the LayoutScale mode */
	function anchor(fractionX:Float = 0, fractionY:Float = 0, pixelX:Float = 0, pixelY:Float = 0):ITransformObject;
	/** overrides the bounds of the display object. bounds are using when dealing with LayoutScale */
	function bounds(rectDef:RectDef):ITransformObject;
	
	/** defines if the bounds value should update after it is initially set, 
	 * setting this to false is sometimes useful if you are manually tweening an internal display object */
	function updateBounds(value:Bool):ITransformObject;
	
	/** Defines the LayoutScale mode to apply. Default is LayoutScale.None */
	function scale(value:LayoutScale, scaleRounding:Float=-1):ITransformObject;
	/** Defines the vertical LayoutScale mode to apply. if vScale is not set, the scale value will be used instead */
	function vScale(value:String):ITransformObject;
	/** Defines the horizontal LayoutScale mode to apply. if vScale is not set, the scale value will be used instead */
	function hScale(value:String):ITransformObject;
	/** Defines if the diplay object which is being transferred should be nested within a "transform" parent.
	 * This is useful if you want the LayoutManager to manipulate the scale and placement of a display object while
	 * still being able to independently effect it's transform externally*/
	function nest(value:Bool):ITransformObject;
	
	function resize():ITransformObject;
} 