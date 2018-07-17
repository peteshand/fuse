package mantle.managers.scroll;

import mantle.managers.touch.TouchManager;
import mantle.notifier.Notifier;
import msignal.Signal.Signal0;
import openfl.geom.Point;
import starling.display.DisplayObject;
import starling.events.Touch;

/**
 * ...
 * @author P.J.Shand
 */
class ScrollManager
{
	public var fraction = new Notifier<Float>(0.1);
	public var position = new Notifier<Float>(0);
	var scrollTouchArea:DisplayObject;
	var scrollContainer:DisplayObject;
	
	var scrollModel:ScrollModel = new ScrollModel();
	
	
	var initPosition:Point = new Point();
	var difference:Point = new Point();
	var displayStart:Point = new Point();
	var touchStart:Point = new Point();
	var touchModelValues:Point = new Point();
	
	var target:Point = new Point();
	
	@:isVar var scrollLength(get, null):Float;
	
	public function new() 
	{
		
	}
	
	public function addTouchArea(scrollTouchArea:DisplayObject) 
	{
		if (this.scrollTouchArea != null) {
			TouchManager.remove(this.scrollTouchArea);
		}
		this.scrollTouchArea = scrollTouchArea;
		
		TouchManager.add(scrollTouchArea)
			.setBegin(OnBegin)
			.setMove(OnMove)
			.setEnd(OnRelease);
		
		position.change.add(OnPositionChange);
	}
	
	function OnBegin(touch:Touch) 
	{
		displayStart.setTo(scrollContainer.x, scrollContainer.y);
		touchStart.setTo(touch.globalX, touch.globalY);
		
		trace(displayStart.y);
		//touchModelValues.setTo(scrollModel.positionX.value, scrollModel.positionY.value);
		
		OnMove(touch);
	}
	
	function OnMove(touch:Touch) 
	{
		if (scrollContainer.height < scrollTouchArea.height) {
			target.y = displayStart.y;
			position.value = 0;
			return;
		}
		
		difference.setTo(touchStart.x - touch.globalX, touchStart.y - touch.globalY);
		target.y = displayStart.y - difference.y;
		
		if (target.y > initPosition.y) target.y = initPosition.y;
		if (target.y < initPosition.y - scrollLength) target.y = initPosition.y - scrollLength;
		
		updatePosition();
	}
	
	public function updatePosition() 
	{
		position.value = (target.y - initPosition.y) / -scrollLength;
	}
	
	function OnPositionChange() 
	{
		trace("scrollContainer.height = " + scrollContainer.height);
		trace("scrollTouchArea.height = " + scrollTouchArea.height);
		
		if (scrollContainer.height < scrollTouchArea.height) {
			scrollContainer.y = initPosition.y;
		}
		else {
			scrollContainer.y = initPosition.y + (position.value * -scrollLength);
		}
	}
	
	function OnRelease(touch:Touch) 
	{
		
	}
	
	public function addScrollContainer(scrollContainer:DisplayObject) 
	{
		initPosition.setTo(scrollContainer.x, scrollContainer.y);
		target.setTo(scrollContainer.x, scrollContainer.y);
		this.scrollContainer = scrollContainer;
		
	}
	
	function get_scrollLength():Float 
	{
		return scrollContainer.height - scrollTouchArea.height;
	}
}

class ScrollModel
{
	public var positionX = new Notifier<Float>(0);
	public var positionY = new Notifier<Float>(0);
	
	public function new() { }
}