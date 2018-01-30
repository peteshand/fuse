/*The MIT License (MIT)

Copyright (c) 2015 P.J.Shand

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

package fuse.utils.delay;
import haxe.Constraints.Function;

/**
 * ...
 * @author P.J.Shand
 */

class Delay 
{
	private static var delayObjects:Array<DelayObject>;
	
	public static var TIME_UNIT_MILLISECONDS:Int = 0;
	public static var TIME_UNIT_SECONDS:Int = 1;
	public static var TIME_UNIT_MINUTES:Int = 2;
	public static var TIME_UNIT_HOURS:Int = 3;
	public static var TIME_UNIT_DAYS:Int = 4;
	
	static function __init__() { 
       delayObjects = new Array<DelayObject>();
    }
	
	public function new() { }
	
	public static function nextFrame(callback:Function, params:Array<Dynamic>=null):Void
	{
		Delay.byFrames(1, callback, params);
	}
	
	public static function byFrames(frames:Int, callback:Function, params:Array<Dynamic>=null):Void 
	{
		var delayObject:DelayObject = new DelayObject();
		delayObjects.push(delayObject);
		delayObject.by(frames, clearObject, callback, params);
	}
	
	public static function byTime(time:Float, callback:Function, params:Array<Dynamic>=null, units:Int=1, precision:Bool=false):Void 
	{
		var delayObject:DelayObject = new DelayObject();
		delayObjects.push(delayObject);
		delayObject.byTime(time, clearObject, callback, params, units, precision);
	}
	
	public static function block(time:Float, callback:Function, params:Array<Dynamic>=null):Void 
	{
		var delayObject:DelayObject = new DelayObject();
		delayObjects.push(delayObject);
		delayObject.block(time, clearObject, callback, params);
	}
	
	private static function clearObject(delayObject:DelayObject):Void 
	{
		var i:Int = delayObjects.length - 1;
		while (i >= 0) 
		{
			if (delayObjects[i] == delayObject) {
				delayObject.dispose();
				delayObject = null;
				delayObjects.splice(i, 1);
			}
			i--;
		}
	}
	
	public static function killDelay(callback:Function):Void 
	{
		if (delayObjects == null) return;
		var i = 0;
		while (i < delayObjects.length){
			var delayObject = delayObjects[i];
			if (delayObject.callback == callback) {
				delayObject.dispose();
				delayObjects.splice(i, 1);
			}else{
				i++;
			}
		}
	}
}