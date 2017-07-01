package kea.logic.profiling;

import haxe.Timer;
import kea2.Kea;
import kea2.utils.Notifier;

class ProfileMonitor
{
	var frameCount:Int = 0;
	var preTime:Float = 0;
	var postTime:Float = 0;
	var renderTime:Float = 0;
	var frameBudgets:Array<Float> = [];

	public function new()
	{
		var timer:Timer = new Timer(1000);
		timer.run = OnTick;
	}

	function OnTick():Void
	{
		Kea.current.model.performance.fps.value = frameCount;
		//trace("fps.value = " + fps.value);
		frameCount = 0;
		var frameBudget:Float = 0;
		for (i in 0...frameBudgets.length){
			frameBudget += frameBudgets[i];
		}
		frameBudget /= frameBudgets.length;
		Kea.current.model.performance.frameBudget.value = frameBudget;
		frameBudgets.splice(0, frameBudgets.length);
		//trace("frameBudget = " + frameBudget);
		
	}

	public function prerender():Void
	{
		preTime = Date.now().getTime();
		frameCount++;
	}

	public function postrender():Void
	{
		postTime = Date.now().getTime();

		renderTime = postTime - preTime;
		//trace("renderTime = " + renderTime);
		frameBudgets.push(renderTime / (1000 / Kea.current.model.performance.fps.value));
	}
}
