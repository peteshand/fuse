package mantle.delay;

import haxe.Constraints.Function;
/**
 * @author P.J.Shand
 */
interface IDelayObject 
{
	var callback:Function;
	private var params:Array<Dynamic>;
	var complete(get, never):Bool;
	function dispatch():Void;
}