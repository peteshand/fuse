package mantle.managers.replay;

import flash.display.Sprite;
import flash.events.Event;
import openfl.display.Stage;
/**
 * ...
 * @author P.J.Shand
 */
class InstantReplay 
{
	public static var data:InstantReplayObject;
	private static var _record:Bool = false;
	private static var _playing:Bool = false;
	
	public static var currentFrame:Int = 0;
	
	private static var broadcaster:Sprite = new Sprite();
	
	private static var STATE_PLAY:String = 'play';
	private static var STATE_STOP:String = 'stop';
	private static var STATE_RECORDING:String = 'recording';
	
	private static var _state:String;
	static public var stage:Stage;
	
	public static var playing(get, null):Bool;
	public static var record(get, set):Bool;
	private static var state(get, set):String;
	
	public function new() 
	{
		
	}
	
	private static function init():Void
	{
		if (data == null) {
			data = new InstantReplayObject();
		}
	}
	
	public static function clear():Void 
	{
		InstantReplay.init();
		data.clear();
		currentFrame = 0;
		broadcaster.removeEventListener(Event.ENTER_FRAME, PlaybackUpdate);
		broadcaster.removeEventListener(Event.ENTER_FRAME, RecordUpdate);
	}
	
	public static function play():Void
	{
		if (record) record = false;
		state = InstantReplay.STATE_PLAY;
	}
	
	public static function stop():Void
	{
		if (record) record = false;
		state = InstantReplay.STATE_STOP;
	}
	
	private static function get_record():Bool
	{
		return _record;
	}
	
	private static function set_record(value:Bool):Bool 
	{
		if (_record == value) return value;
		_record = value;
		data.recording = value;
		if (record) {
			state = InstantReplay.STATE_RECORDING;
		}
		else {
			state = InstantReplay.STATE_STOP;
		}
		return value;
	}
	
	private static function get_state():String 
	{
		return _state;
	}
	
	private static function set_state(value:String):String 
	{
		if (_state == value) return value;
		InstantReplay.init();
		_state = value;
		if (state == InstantReplay.STATE_RECORDING) {
			_playing = false;
			broadcaster.removeEventListener(Event.ENTER_FRAME, PlaybackUpdate);
			broadcaster.addEventListener(Event.ENTER_FRAME, RecordUpdate);
		}
		else {
			broadcaster.removeEventListener(Event.ENTER_FRAME, RecordUpdate);
			if (state == InstantReplay.STATE_PLAY) {
				_playing = true;
				broadcaster.addEventListener(Event.ENTER_FRAME, PlaybackUpdate);
			}
			else if (state == InstantReplay.STATE_STOP) {
				_playing = false;
				broadcaster.removeEventListener(Event.ENTER_FRAME, PlaybackUpdate);
			}
		}
		return value;
	}
	
	private static function get_playing():Bool
	{
		return _playing;
	}
	
	private static function RecordUpdate(e:Event):Void 
	{
		data.record(currentFrame);
		currentFrame++;
	}
	
	private static function PlaybackUpdate(e:Event):Void 
	{
		currentFrame++;
		
		if (currentFrame >= data.totalFrames) {
			currentFrame = 0;
		}
		data.play(currentFrame);
	}
	
	public static function register(stage:Stage):Void
	{
		InstantReplay.stage = stage;
		InstantReplay.init();
		data = new InstantReplayObject();
	}
	
	public static function deregister(stage:Stage):Void
	{
		InstantReplay.init();
		data.dispose();
		data = new InstantReplayObject();
	}
}