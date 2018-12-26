package mantle.managers.transition;

import haxe.Timer;
//import mantle.managers.transition.plugins.TransitionPlugins;
import notifier.Notifier;
import condition.IState;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import notifier.Signal;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
class Transition
{
	public var showTime:Float = 1;
	public var showDelay:Float = 0;
	
	public var hideTime:Float = 1;
	public var hideDelay:Float = 0;
	
	public var showing:Null<Bool>;
	
	private var transitionObjects = new Array<TransitionObject>();
	private var queuedFunction:Void->Void;
	
	private var transitioningIn = new Notifier<Bool>(false);
	private var transitioningOut = new Notifier<Bool>(false);
	
	private static var tweenCountReg = new Map<Transition, Bool>();
	public static var globalTweenCount = new Notifier<Int>(0);
	public static var globalTransitioning = new Notifier<Bool>(false);
	
	private static var linearEaseNone:motion.easing.Linear.LinearEaseNone;
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////
	public var onShowStart = new Signal();														////
	public var onShowUpdate = new Signal();													////
	public var onShowComplete = new Signal();													////
																								////
	public var onHideStart = new Signal();														////
	public var onHideUpdate = new Signal();													////
	public var onHideComplete = new Signal();													////
	////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	public var isTweening = new Notifier<Bool>(false);
	public var totalTransTime(get, null):Float;
	
	public var sceneTransition:Bool = false;
	public var queueTransitions:Bool = true;
	
	//private var _value:Null<Float>;
	//public var value(get, set):Float;
	
	var progress:Notifier<Null<Float>>;
	var target:Dynamic;
	var tween:GenericActuator<Transition>;
	@:isVar public var value(get, set):Float = 0;
	
	public var startHidden:Bool = true;
	
	static public inline var SHOW:String = "show";
	static public inline var HIDE:String = "hide";
	// --------------------------------------------------- //
	
	var showDelayTimer:Timer;
	var hideDelayTimer:Timer;

	@isVar public var state(default, set):IState;

	public function new(showTime:Float = 1, hideTime:Float = 1, showDelay:Float = 0, hideDelay:Float = 0, startHidden:Bool = true) 
	{
		this.showTime = showTime;
		this.hideTime = hideTime;
		this.showDelay = showDelay;
		this.hideDelay = hideDelay;
		this.startHidden = startHidden;
		
		if (linearEaseNone == null) linearEaseNone = new LinearEaseNone();
		//onShowUpdate.add(ActivityModel.animating);
		//onHideUpdate.add(ActivityModel.animating);
		
		globalTweenCount.add(OnTweenCountChange);
		isTweening.add(OnIsTweeningChange);
		
		progress = new Notifier<Null<Float>>(0);
		progress.add(OnProgressChange);
		if (startHidden) progress.value = -1;
		else progress.value = 0;
	}
	
	function OnProgressChange() 
	{
		if (value == 0) this.showing = true;
		else if (value <= -1 || value >= 1) {
			this.showing = false;
			
		}
		
		if (value < -1) value = -1;
		else if (value > 1) value = 1;
		
		if (transitionObjects == null) {
			throw new Error("this transition object has been disposed and should not be referenced");
		}
		for (i in 0...transitionObjects.length)
		{	
			transitionObjects[i].update(value);
		}
	}
	
	function OnIsTweeningChange() 
	{
		if (sceneTransition) {
			if (isTweening.value) {
				tweenCountReg.set(this, true);
				globalTweenCount.value = countReg(tweenCountReg);
			}
			else {
				tweenCountReg.remove(this);
				globalTweenCount.value = countReg(tweenCountReg);
			}
		}
	}
	
	function OnTweenCountChange() 
	{
		if (globalTweenCount.value == 0) globalTransitioning.value = false;
		else globalTransitioning.value = true;
	}
	
	// --------------------------------------------------- //
	/* @param target Target object whose properties this tween affects. 
	*  @param tweenObject, dynamic object containing properties to tweet, with a [hide, show] value, or [hide, show, hide] value. 
	*  @param options, TransitionSettings typedef object containing tween options. Options are as follows: 
	* "ease", "showEase", "hideEase", "autoVisible", "autoVisObject", "start", "end", "startHidden",
	*  @return Void */
	
	public function add(target:Dynamic, properties:Dynamic=null, options:TransitionSettings=null):ITransitionObject 
	{
		this.target = target;
		
		if (!target) throw new Error("target must not be null");
		var transitionObject = getTransitionObject(target);
		transitionObject.onSet.add(UpdateStartValues);
		transitionObject.set(properties, options);
		transitionObject.update(value);
		
		return transitionObject;
	}
	
	private function UpdateStartValues() 
	{
		
	}
	
	public function remove(target:Dynamic, vars:Dynamic=null):Void 
	{
		if (vars != null) {
			getTransitionObject(target).remove(vars);
		}
		else {
			for (transitionObject in transitionObjects) 
			{
				if (transitionObject.target == target) {
					transitionObject.dispose();
					transitionObjects.remove(transitionObject);
				}
			}
		}
	}
	
	
	/*#if swc @:protected #end*/
	private function getTransitionObject(target:Dynamic):TransitionObject 
	{
		var transitionObject = new TransitionObject(target);
		transitionObject.target = target;
		transitionObjects.push(transitionObject);
		return transitionObject;
	}
	
	private function queue(func:Void->Void):Void 
	{
		queuedFunction = func;
	}
	
	// --------------------------------------------------- //
	
	public function Show():Void
	{
		if (isTweening.value && queueTransitions) {
			queue(Show);
			return;
		}
		
		if (showing == true) return;
		if (showing == null) {
			ShowJump();
			showing = true;
			return;
		}
		
		if(progress.value == 1) {
			this.value = -1;
		}
		KillDelays();
		isTweening.value = true;
		if (showTime == 0) {
			if (showDelay == 0) ShowJump();
			else {
				showDelayTimer = Timer.delay(ShowJump, Math.floor(showDelay * 1000));
				showDelayTimer.run();
			}
		}
		else {
			
			
			if (showDelay == 0) ShowTween();
			else {
				showDelayTimer = Timer.delay(ShowTween, Math.floor(showDelay * 1000));
				showDelayTimer.run();
			}
		}
	}
	
	function KillDelays() 
	{
		if (showDelayTimer != null){
			showDelayTimer.stop();
			showDelayTimer = null;
		}
		if (hideDelayTimer != null){
			hideDelayTimer.stop();
			hideDelayTimer = null;
		}
	}
	
	private function ShowTween():Void 
	{
		Actuate.stop(this);
		if (tween != null) {
			Actuate.unload(tween);
		}
		
		tween = Actuate.tween(this, showTime, { value:0 } ).onUpdate(PrivateShowOnUpdate).onComplete(PrivateShowOnComplete).ease(linearEaseNone);
		PrivateShowOnStart();
	}
	
	private function ShowJump():Void 
	{
		progress.value = 0;
		PrivateShowOnStart();
		PrivateShowOnUpdate();
		PrivateShowOnComplete();
	}
	
	public function Hide():Void
	{
		if (isTweening.value && queueTransitions) {
			queue(Hide);
			return;
		}
		if (showing == false) return;
		if (showing == null) {
			HideJump();
			showing = false;
			return;
		}
		showing = false;
		
		KillDelays();
		isTweening.value = true;
		if (hideTime == 0) {
			if (hideDelay == 0) HideJump();
			else {
				hideDelayTimer = Timer.delay(HideJump, Math.floor(hideDelay * 1000));
				hideDelayTimer.run();
			}
		}
		else {
			if (hideDelay == 0) HideTween();
			else {
				hideDelayTimer = Timer.delay(HideTween, Math.floor(hideDelay * 1000));
				hideDelayTimer.run();
			}
		}
	}
	
	public function dispose() 
	{
		if (transitionObjects == null) return;
		
		Actuate.stop(this);
		
		var i:Int = transitionObjects.length - 1;
		while (i >= 0) 
		{
			transitionObjects[i].dispose();
			transitionObjects.splice(i, 1);
			i--;
		}
		queuedFunction = null;
		progress.removeAll();
		onShowStart.removeAll();
		onShowUpdate.removeAll();
		onShowComplete.removeAll();
		onHideStart.removeAll();
		onHideUpdate.removeAll();
		onHideComplete.removeAll();
		target = null;
		
		if (tween != null) Actuate.unload(tween);
		
		tween = null;
	}
	
	private function HideTween():Void
	{
		Actuate.stop(this);
		if (tween != null){
			Actuate.unload(tween);
		}
		tween = Actuate.tween(this, hideTime, { value:1 } ).onUpdate(PrivateHideOnUpdate).onComplete(PrivateHideOnComplete).ease(linearEaseNone);
		PrivateHideOnStart();
	}
	
	private function HideJump():Void 
	{
		progress.value = 1;
		PrivateHideOnStart();
		PrivateHideOnUpdate();
		PrivateHideOnComplete();
	}
	
	// --------------------------------------------------- //
	
	private function PrivateShowOnStart():Void 
	{
		showing = true;
		transitioningIn.value = true;
		for (i in 0...transitionObjects.length) transitionObjects[i].showBegin();
		onShowStart.dispatch();
	}
	
	private function PrivateShowOnUpdate():Void 
	{
		onShowUpdate.dispatch();
	}
	
	private function PrivateShowOnComplete():Void 
	{
		isTweening.value = false;
		transitioningIn.value = false;
		for (i in 0...transitionObjects.length) transitionObjects[i].showEnd();
		onShowComplete.dispatch();
		checkQueue();
	}
	
	// --------------------------------------------------- //
	
	private function PrivateHideOnStart():Void 
	{
		transitioningOut.value = true;
		for (i in 0...transitionObjects.length) transitionObjects[i].hideBegin();
		onHideStart.dispatch();
	}
	
	private function PrivateHideOnUpdate():Void 
	{
		onHideUpdate.dispatch();
	}
	
	private function PrivateHideOnComplete():Void 
	{
		isTweening.value = false;
		transitioningOut.value = false;
		for (i in 0...transitionObjects.length) transitionObjects[i].hideEnd();
		onHideComplete.dispatch();
		checkQueue();
	}
	
	function countReg(tweenCountReg:Map<Transition, Bool>):Int
	{
		var count:Int = 0;
		for (key in tweenCountReg.keys()) 
		{
			count++;
		}
		return count;
	}
	
	private function checkQueue():Void 
	{
		if (queuedFunction != null) {
			queuedFunction();
			queuedFunction = null;
		}
	}
	
	function get_totalTransTime():Float 
	{
		return showDelay + showTime + hideDelay + hideTime;
	}
	
	function get_value():Float 
	{
		return progress.value;
	}
	
	function set_value(value:Float):Float 
	{
		return progress.value = value;
	}

	function set_state(value:IState):IState
	{
		if (state != null){
			state.onActive.remove(Show);
			state.onInactive.remove(Hide);
		}
		state = value;
		if (state != null){
			state.onActive.add(Show);
			state.onInactive.add(Hide);
			if (state.value) Show();
			else Hide();
		}
		return state;
	}
}
