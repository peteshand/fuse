package fuse.utils;

class PowerOfTwo
{
	public function new() { }
	
	public static function getNextPowerOfTwo(vlaue:Int):Int
	{
		if (vlaue > 0 && (vlaue & (vlaue - 1)) == 0) 
			return vlaue;
		else
		{
			var result:Int = 1;
			while (result < vlaue) result <<= 1;
			return result;
		}
	}
}