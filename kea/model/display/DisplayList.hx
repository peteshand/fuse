package kea.model.display;
import kea.display.IDisplay;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayList
{
	var display:IDisplay;
	
	public var parent:DisplayList;
	public var values:Array<DisplayList> = [];
	public var child:Array<DisplayList> = [];
	
	//public var onAdd = new Signal0();
	//public var onRemove = new Signal0();
	
	public function new(display:IDisplay) 
	{
		this.display = display;
		
	}
	
	public function addChild(item:DisplayList):Void
	{
		child.push(item);
	}
	
	public function addChildAt(item:DisplayList, index:Int):Void
	{
		var prev:DisplayList = this;
		if (child.length > 0) prev = child[child.length - 1];
		
		child.insert(item, index);
	}
	
	public function removeChild(item:DisplayList):Void
	{
		child.remove(item);
	}
}