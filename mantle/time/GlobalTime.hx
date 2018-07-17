package mantle.time;

/**
 * ...
 * @author P.J.Shand
 */
class GlobalTime
{
	static public var today(get, null):Date;
	
	@:isVar static public var offset(get, set):Float = 0;
	static public var pause:Bool = false;
	static private var _nowDate:Date;
	static private var _nowTime:Null<Float>;
	static private var _nowTimeWithOffset:Null<Float>;
	
	static private var _timezoneOffset:Null<Float>;
	static public var timezoneOffset(get, null):Float;
	
	public function new() { }
	
	static public var inited:Bool = false;
	public static function init():Void
	{
		if (inited) return;
		inited = true;
		EnterFrame.add(OnTick);
	}	
	
	static private function OnTick():Void
	{
		// clear now data
		_nowDate = null;
		if (!pause){
			_nowTime = null;
		}
	}
	
	public static function now():Date
	{
		init();
		if (_nowDate == null) {
			if (!pause || _nowTime == null) _nowTime = Date.now().getTime();
			//_nowTimeWithOffset = _nowTime + timezoneOffset;
			_nowDate = Date.fromTime(_nowTime + offset);
		}
		
		return _nowDate;
	}
	
	public static function nowTime():Float
	{
		init();
		if (!pause || _nowTime == null) {
			_nowTime = Date.now().getTime();
		}
		_nowTime += offset;
		return _nowTime;
	}
	
	static function get_today():Date 
	{
		var _now:Date = now();
		var todayTime:Float = _now.getTime() - (timezoneOffset * 60 * 1000);
		todayTime = Math.floor(todayTime / 1000 / 60 / 60 / 24);
		todayTime = todayTime * 1000 * 60 * 60 * 24;
		var todayDate:Date = Date.fromTime(todayTime + (timezoneOffset * 60 * 1000));
		return todayDate;
	}
	
	static function get_timezoneOffset():Float 
	{
		if (_timezoneOffset == null) {
			var _now:Date = now();
			_timezoneOffset = Reflect.getProperty(_now, "timezoneOffset");
		}
		return _timezoneOffset;
	}
	
	static function get_offset():Float 
	{
		return offset;
	}
	
	static function set_offset(value:Float):Float 
	{
		OnTick();
		return offset = value;
	}
}