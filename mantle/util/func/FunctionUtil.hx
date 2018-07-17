package mantle.util.func;

import haxe.Constraints.Function;
/**
 * ...
 * @author P.J.Shand
 */
class FunctionUtil
{

	public function new() 
	{
		
	}
	
	public static function dispatch(callback:Function, params:Array<Dynamic>=null) 
	{
		if (params == null) {
			callback();
			return;
		}
		switch (params.length) 
		{
			case 0 : callback();
			case 1 : callback(params[0]);
			case 2 : callback(params[0], params[1]);
			case 3 : callback(params[0], params[1], params[2]);
			case 4 : callback(params[0], params[1], params[2], params[3]);
			case 5 : callback(params[0], params[1], params[2], params[3], params[4]);
			case 6 : callback(params[0], params[1], params[2], params[3], params[4], params[5]);
			case 7 : callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
			case 8 : callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
			case 9 : callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
			case 10 : callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
			default:
		}
	}
}