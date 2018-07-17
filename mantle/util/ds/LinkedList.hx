package mantle.util.ds;

/**
 * ...
 * @author Thomas Byrne
 */
class LinkedList<T:LinkedListItem<T>>
{
	private var first:Null<T>;
	private var last:Null<T>;
	
	@:isVar
	public var length(default, null):Int;

	public function new() 
	{
		
	}
	public function push(item:T):Void {
		if (first == null) {
			first = item;
		}else {
			item.prev = last;
			last.next = item;
		}
		last = item;
		length++;
	}
	public function pop():T {
		var ret:T = last;
		last = ret.prev;
		ret.prev = null;
		if (last != null) {
			last.next = null;
		}
		length--;
		return ret;
	}
	public function unshift(item:T):Void {
		if (last == null) {
			last = item;
		}else {
			item.next = first;
			first.prev = item;
		}
		first = item;
		length++;
	}
	public function shift():T {
		var ret:T = first;
		first = ret.next;
		ret.next = null;
		if (first != null) {
			first.prev = null;
		}
		length--;
		return ret;
	}
	
	public function remove(item:T):Void {
		var focus:T = first;
		while (focus!=null) {
			if (focus == item) {
				var next = focus.next;
				var prev = focus.prev;
				
				if (next != null) {
					next.prev = prev;
					if (prev != null) {
						prev.next = next;
					}else {
						first = next;
					}
					
				}else if (prev != null) {
					prev.next = null;
					last = prev;
					
				}else {
					first = null;
					last = null;
				}
				item.next = null;
				item.prev = null;
				length--;
				return;
			}
			focus = focus.next;
		}
	}
	
	public function sortedAdd(item:T, f:T -> T -> Int):Void {
		var focus:T = first;
		while (focus != null) {
			var sortCode:Int = f(focus, item);
			if (sortCode == 1) {
				addBefore(item, focus);
				return;
			}
			focus = focus.next;
		}
		push(item);
	}
	
	public function addBefore(add:T, before:T) 
	{
		length++;
		var prev = before.prev;
		if (prev!=null) {
			prev.next = add;
			add.prev = prev;
		}else {
			first = add;
		}
		add.next = before;
		before.prev = add;
	}
	
	public function iterateTillTrue(f:T -> Bool, removeItems:Bool=false):Void {
		var focus:T = first;
		while (focus!=null) {
			if (f(focus)) {
				return;
			}
			var next = focus.next;
			if (removeItems) {
				if (focus.next != null) {
					focus.next.prev = null;
				}
				focus.next = null;
				first = next;
			}
			focus = next;
		}
	}
}

typedef LinkedListItem<T:LinkedListItem<T>> = {
	public var next:T;
	public var prev:T;
}