package robotlegs.extensions.impl.services.activity;

import mantle.time.GlobalTime;
import mantle.notifier.Notifier;
import mantle.time.EnterFrame;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.impl.model.activity.ActivityModel;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
@:rtti
class ActivityMonitorService 
{
	@inject public var contextView:ContextView;
	@inject public var activityModel:ActivityModel;
	
	var interactionCount = new Notifier<Int>(0);
	var delta:Int = 0;
	var currentTime:Float = 0;
	var lastTime:Float = 0;
	
	var interactiveEvents:Array<String> = 
	[
		MouseEvent.MOUSE_DOWN,
		MouseEvent.MOUSE_MOVE,
		MouseEvent.MOUSE_UP,
		MouseEvent.MOUSE_WHEEL,
		TouchEvent.TOUCH_BEGIN,
		TouchEvent.TOUCH_MOVE,
		TouchEvent.TOUCH_END,
	];
	
	#if air
	private var windowEvents:Array<String> = 
	[
		flash.events.NativeWindowBoundsEvent.RESIZE,
		flash.events.NativeWindowBoundsEvent.MOVE,
		flash.events.NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE
	];
	#end
	
	public function new() { }
	
	public function start():Void
	{
		currentTime = lastTime = GlobalTime.nowTime();
		
		for (i in 0...interactiveEvents.length) 
			contextView.view.stage.addEventListener(interactiveEvents[i], OnInteraction);
		EnterFrame.add(OnTick);
		
		#if air
		var app = flash.desktop.NativeApplication.nativeApplication;
		for(window in app.openedWindows){
			for (eventType in windowEvents) 
				window.addEventListener(eventType, OnInteraction);
		}
		#end
	}
	
	public function stop():Void
	{
		for (i in 0...interactiveEvents.length) 
			contextView.view.stage.removeEventListener(interactiveEvents[i], OnInteraction);
		EnterFrame.remove(OnTick);
		
		#if air
		var app = flash.desktop.NativeApplication.nativeApplication;
		for(window in app.openedWindows){
			for (eventType in windowEvents) 
				window.removeEventListener(eventType, OnInteraction);
		}
		#end
	}
	
	function OnTick() 
	{
		currentTime = GlobalTime.nowTime();
		delta = Math.floor(currentTime - lastTime);
		activityModel.inactiveTime.value += delta;
		activityModel.animationTime.value += delta;
		lastTime = currentTime;
	}
	
	private function OnInteraction(e:Event):Void 
	{
		activityModel.inactiveTime.value = activityModel.animationTime.value = 0;
	}
}