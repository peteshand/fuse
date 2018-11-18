package fuse.core.utils;

import fuse.core.backend.Core;

/**
 * ...
 * @author P.J.Shand
 */
class Calc
{

	public function new() 
	{
		
	}
	
	public static inline function pixelToScreenX(pixelValue:Float):Float
	{
		return ((pixelValue / Core.STAGE_WIDTH) - 0.5) * 2;
		//return ((pixelValue / Fuse.current.stage.stageWidth) - 0.5) * 2;
	}
	
	public static inline function pixelToScreenY(pixelValue:Float):Float
	{
		return ((pixelValue / Core.STAGE_HEIGHT) - 0.5) * -2;
		//return ((pixelValue / Fuse.current.stage.stageHeight) - 0.5) * -2;
	}
}