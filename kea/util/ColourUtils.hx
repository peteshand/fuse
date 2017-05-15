package kea.util;

/**
 * ...
 * @author P.J.Shand
 */
class ColourUtils
{

	public function new() 
	{
		
	}
	
	public static inline function addMissingAlpha(rgb:UInt, newAlpha:UInt):UInt
	{
		if (rgb <= 0xFFFFFF) {
			// No alpha set
			var red = rgb >> 16 & 0xFF;
			var green = rgb >> 8 & 0xFF;
			var blue = rgb & 0xFF;
			
			var argb:UInt = 0;
			argb += (newAlpha<<24);
			argb += (red<<16);
			argb += (green<<8);
			argb += (blue);
			
			return argb;
		}
		else {
			// Already has alpha set
			return rgb;
		}
	}
}