package kea.model.display;
import kea2.display.containers.IDisplay;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayList
{
	var display:IDisplay;
	
	public var parent:DisplayList;
	public static var linear:Array<DisplayList> = [];
	public var child:Array<DisplayList> = [];
	
	//public var onAdd = new Signal0();
	//public var onRemove = new Signal0();
	
	public var prev:DisplayList;
	public var next:DisplayList;
	
	static function __init__()
	{
		linear = [];
	}
	
	public function new(parent:DisplayList, display:IDisplay) 
	{
		this.parent = parent;
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