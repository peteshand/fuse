package kea.texture;

import kea2.display.containers.IDisplay;
import kea.display.Sprite;
import kea.notify.Notifier;
import kea.texture.Texture.FromBitmapData;
import kea.util.Time;
import kea2.Kea;

/**
 * ...
 * @author P.J.Shand
 */
class TextureHelper
{
	public static var processing:Notifier<Bool>;
	public static var que:Map<Texture, FromBitmapData>;
	static var frameTime(get, null):Float;
	static var maxTime(get, null):Float;
	
	// Only process until 90% of frame budget has been used
	static var maxFrameFraction:Float = 0.9;
	
	static var count:Int = 0;
	static var average:Float = 0;
	static var itemsAdded:Int = 0;
	static var addThisFrame:Array<FromBitmapData> = [];
	static private var timeSpent:Float;
	static private var processEndTime:Float;
	
	static function __init__():Void
	{
		que = new Map<Texture, FromBitmapData>();
		processing = new Notifier<Bool>(false);
		processing.add(OnProcessingChange);
		
		processEndTime = Time.getCurrentTime();
		Kea.current.onRender.add(OnUpdate);
	}
	
	static private function OnProcessingChange() 
	{
		//trace("processing = " + processing.value);
	}
	
	static function OnUpdate():Void
	{
		processing.value = que.iterator().hasNext();
		if (processing.value == false) return;
		
		
		var processBeginTime:Float = Time.getCurrentTime();
		//trace("processBeginTime = " + processBeginTime);
		timeSpent = (processBeginTime - processEndTime) - frameTime;
		if (timeSpent < 0) timeSpent = 0;
		
		//timeSpent = 0;
		
		//trace("timeSpent = " + timeSpent);
		itemsAdded = 0;
		//addThisFrame = [];
		
		
		
		//if (que.iterator().hasNext()) {
			//while (timeSpent < maxTime) {
			
			for (item in que) 
			{
				var startTime:Float = Time.getCurrentTime();
				//var item:FromBitmapData = que.iterator().next();// que.shift();
				
				
				if (timeSpent >= maxTime) {
					/*trace("timeSpent = " + timeSpent + " maxTime = " + maxTime);
					trace("maxFrameFraction = " + maxFrameFraction);
					trace("frameTime = " + frameTime);*/
					
					
					//timeSpent = maxTime;
					//trace("itemsAdded = " + itemsAdded);
					
					while (addThisFrame.length > 0) 
					{
						var addItem = addThisFrame.shift();
						for (j in 0...addItem.displays.length) 
						{
							var display = addItem.displays[j];
							if (display.index == -1) display.parent.addChild(display.child);
							else display.parent.addChildAt(display.child, display.index);
						}
						
					}
					/*for (i in 0...addThisFrame.length) 
					{
						var addItem = addThisFrame[i];
						for (j in 0...addItem.displays.length) 
						{
							var display = addItem.displays[j];
							if (display.index == -1) display.parent.addChild(display.child);
							else display.parent.addChildAt(display.child, display.index);
						}
					}*/
					processEndTime = Time.getCurrentTime();
					//trace("processEndTime = " + processEndTime);
					return;
				}
				itemsAdded++;
				item.texture.uploadBitmap(item.bmd, item.readable);
				addThisFrame.push(item);
				
				/*for (i in 0...item.displays.length) 
				{
					if (item.displays[i].index == -1){
						item.displays[i].parent.addChild(item.displays[i].child);
					}
					else {
						item.displays[i].parent.addChildAt(item.displays[i].child, item.displays[i].index);
					}
				}*/
				que.remove(item.texture);
				
				
				var endTime:Float = Time.getCurrentTime();
				
				var itemTime:Float = (endTime - startTime);
				//var estimatedTime:Float = average * item.bmd.width * item.bmd.height;
				
				//trace("itemTime = " + itemTime);
				//var timePerPixel:Float = realTime / (item.bmd.width * item.bmd.height);
				
				//average = ((average * count) + timePerPixel) / (count + 1);
				count++;
				timeSpent += itemTime;
				
				/*if (timeSpent >= maxTime) {
					return;
				}*/
			}
		//}
		processEndTime = Time.getCurrentTime();
	}
	
	static public function register(child:IDisplay, parent:Sprite, index:Int) 
	{
		var fromBitmapData:FromBitmapData = que.get(child.base);
		if (fromBitmapData != null){
			fromBitmapData.displays.push( { child:child, parent:parent, index:index } );
		}
		else {
			trace("");
		}
	}
	
	static function get_frameTime():Float 
	{
		return Math.floor(1000 / Kea.current.frameRate);
	}
	
	static function get_maxTime():Float 
	{
		return maxFrameFraction * frameTime;
	}
}