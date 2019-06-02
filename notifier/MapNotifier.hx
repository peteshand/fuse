package notifier;

import mantle.filesystem.DocStore;
import time.EnterFrame;
import haxe.ds.ObjectMap;
import signal.Signal1;

/**
 * ...
 * @author P.J.Shand
 */
class MapNotifier<T> {
	private var data = new ObjectMap<{}, T>();

	public var onAdd = new Signal1<Array<T>>();
	public var onRemove = new Signal1<Array<T>>();
	public var onChange = new Signal1<Array<T>>();
	public var allItems = new Array<T>();
	public var newItems = new Array<T>();
	public var removedItems = new Array<T>();
	public var changedItems = new Array<T>();

	// private var sharedObject:DocStore;

	public function new( /*id:String=null*/) {
		/*if (id != null) {
			sharedObject = DocStore.getLocal("ParseDataBind-" + id);

			var savedData:Array<T> = Reflect.getProperty(sharedObject.data, "savedData");
			if (savedData != null) {
				this.addArray(untyped savedData);
			}
			check();
		}*/

		EnterFrame.add(onTick);
	}

	function onTick() {
		check();
	}

	public function check():Void {
		if (newItems.length != 0) {
			onAdd.dispatch(newItems);
			newItems = new Array<T>();
		}
		if (changedItems.length != 0) {
			onChange.dispatch(changedItems);
			changedItems = new Array<T>();
		}
		if (removedItems.length != 0) {
			onRemove.dispatch(removedItems);
			removedItems = new Array<T>();
		}
	}

	public inline function exists(key:T):Bool {
		return data.exists(untyped key);
	}

	public inline function get(key:T):T {
		return data.get(untyped key);
	}

	public inline function iterator():Iterator<T> {
		return data.iterator();
	}

	public inline function keys():Iterator<T> {
		return untyped data.keys();
	}

	public function add(value:T) {
		if (exists(value)) {
			data.set(untyped value, value);
			changedItems.push(value);
		} else {
			data.set(untyped value, value);
			newItems.push(value);
		}
		// updateSavedData();
		updateAllItems();
	}

	public function addArray(value:Array<T>) {
		for (i in 0...value.length) {
			if (exists(value[i])) {
				data.set(untyped value[i], value[i]);
				changedItems.push(value[i]);
			} else {
				data.set(untyped value[i], value[i]);
				newItems.push(value[i]);
			}
		}
		// updateSavedData();
		updateAllItems();
	}

	public function remove(value:T) {
		if (value == null)
			return;
		if (exists(value)) {
			data.remove(untyped value);
			removedItems.push(value);
		}
		// updateSavedData();
		updateAllItems();
	}

	public function removeMany(value:Array<T>) {
		for (i in 0...value.length) {
			if (exists(value[i])) {
				data.remove(untyped value[i]);
				removedItems.push(value[i]);
			}
		}
		// updateSavedData();
		updateAllItems();
	}

	/*function updateSavedData() 
		{
			if (sharedObject == null) return;

			var parseObjects:Array<T> = [];
			for (parseObject in data)
			{
				parseObjects.push(parseObject);
			}
			sharedObject.setProperty("savedData", parseObjects);
			sharedObject.flush();
	}*/
	public function clear() {
		removeMany(allItems);
	}

	function updateAllItems():Void {
		allItems = new Array<T>();
		for (item in data.iterator()) {
			allItems.push(item);
		}
	}
}
