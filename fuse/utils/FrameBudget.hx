package fuse.utils;

import openfl.Lib;

/**
	This class is used to determine how much compute time is available at the time of executing code.

	@author P.J.Shand
**/
class FrameBudget {
	static var startTime:Float;
	static var difference:Float;

	/**
		@return Float between 0-1 specifying how much of the time budget has been spent.
		Technically a value greater than 1 can be returned, in this case it would indicate that the framerate has dropped between the target framerate.
	**/
	public static var progress(get, null):Float;

	public static var averageProgress(get, null):Float;
	static public var fps(get, null):Float;
	// static var millisecondsPerFrame:Float = 1000 / 60;
	static var averageLen:Int = 60;
	static var averageCount:Int = 0;
	static var averageProgresses:Array<Float> = [];
	static var _average:Float;
	static var frameDuration:Float;

	static function startFrame() {
		var now:Int = Lib.getTimer();
		frameDuration = now - startTime;
		startTime = now;
	}

	static function get_progress():Float {
		difference = Lib.getTimer() - startTime;
		// trace("difference = " + difference);
		return difference; // TODO: replace with FPS ref
	}

	static function get_averageProgress():Float {
		return _average;
	}

	static function get_fps():Float {
		return Math.round(1000 / frameDuration);
	}

	static public function endFrame() {
		// trace("progress = " + progress);
		averageProgresses[(averageCount++) % averageLen] = Lib.getTimer() - startTime;

		if (averageCount % averageLen == 0) {
			_average = 0;
			var max:Float = 0;
			var min:Float = Math.POSITIVE_INFINITY;
			for (i in 0...averageProgresses.length) {
				// trace("averageProgresses[i] = " + averageProgresses[i]);
				if (max < averageProgresses[i])
					max = averageProgresses[i];
				if (min > averageProgresses[i])
					min = averageProgresses[i];
				_average += averageProgresses[i];
			}
			_average /= averageProgresses.length;

			// _average = toMilli(_average);
			// min = toMilli(min);
			// max = toMilli(max);
			// trace([_average, min, max, fps]);
		}
	}

	static private inline function toMilli(value:Float):Float {
		return Math.round(value * fps * 100) / 100;
	}
}
