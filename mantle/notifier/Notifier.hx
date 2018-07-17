package mantle.notifier;

import mantle.util.fs.DocStore;
import mantle.util.ds.WeakMap;
import msignal.Signal.Signal0;

/**
 * A Notifier adds a "change" signal to a value.
 * If the value is of a base type (Int, Float, String, Bool)
 * then the notifier can be treated as a value in expressions.
 * (i.e. the ".value" can be omitted).
 * 
 * @author P.J.Shand
 * @author Thomas Byrne
 */
@:forward(add, addOnce, addWithPriority, addOnceWithPriority, remove, removeAll, dispatch)
abstract Notifier<T>(BaseNotifier<T>)
{
	
	// Implicit Casting
	
	public inline function new(?value:T, ?id:String) {
		this = new BaseNotifier(value, id);
	}
	
	
	/**
	 * Allows for the notation notifier.when("test", handler) on Notifier<Bool>.
	 * The handler will be called when the value of the notifier matches the first argument.
	 */
	@:impl static inline public function when<T>(notifier : BaseNotifier<T>, match:Null<T>, handler:Void->Void) : Void {
		notifier.set(function(value:T){
			if (value == match) handler();
		});
	}
/*
	@:to inline function toType() : T
	{
		return this==null ? null : this.value;
	}

	@:to inline function toString() : String
	{
		return Std.string(this.value);
	}*/
	
	inline public function set(handler:T->Void):BaseNotifier<T>
	{
		return this.set(handler);
	}
	inline public function unset(handler:T->Void):BaseNotifier<T>
	{
		return this.unset(handler);
	}
	
	static var bindings:WeakMap<BaseNotifier<Dynamic>, PropBind> = new WeakMap();
	
	inline public function bind(target:Dynamic, targetProp:String):BaseNotifier<T>
	{
		var bind:PropBind = bindings.get(this);
		if (bind == null){
			bind = new PropBind(this, "value", this);
			bindings.set(this, bind);
		}
		bind.add(target, targetProp);
		return this;
	}
	inline public function unbind(target:Dynamic, targetProp:String):BaseNotifier<T>
	{
		var bind:PropBind = bindings.get(this);
		if (bind != null){
			bind.remove(target, targetProp);
		}
		return this;
	}
		
	// Gets around casting issues
	public var exists(get, never):Bool;
	inline function get_exists():Bool 
	{
		return this!=null;
	}
		
	// Underlying prop access
	public var requireChange(get, set):Bool;
	inline function get_requireChange():Bool 
	{
		return this.requireChange;
	}
	
	inline function set_requireChange(value:Bool):Bool 
	{
		return this.requireChange = value;
	}
	
	//public var change(get, never):Signal0;
	public var value(get, set):Null<T>;
	//inline function get_change():Signal0 
	//{
		//return this.change;
	//}
	inline function get_value():Null<T> 
	{
		return this == null ? null : this.value;
	}
	inline function set_value(value:Null<T>):Null<T> 
	{
		return this.value = value;
	}
	
	public inline function addAction(action:T->T):Void 
	{
		return this.addAction(action);
	}
	
	
	
	// Int Operator Overloads
	
	@:op(A++)
	@:impl static inline function int_postIncr(lhs:BaseNotifier<Int>) : Int
		return lhs.value++;
	
	@:op(++A)
	@:impl static inline function int_preIncr(lhs:BaseNotifier<Int>) : Int
		return ++lhs.value;
	
	@:op(A--)
	@:impl static inline function int_postDecr(lhs:BaseNotifier<Int>) : Int
		return lhs.value--;
	
	@:op(--A)
	@:impl static inline function int_preDecr(lhs:BaseNotifier<Int>) : Int
		return --lhs.value;
	
	@:op(A * B)
	@:impl static inline function int_multiply(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value * rhs;
	
	@:op(A + B)
	@:impl static inline function int_add(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value + rhs;
	
	@:op(A - B)
	@:impl static inline function int_subtract(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value - rhs;
	
	@:op(A / B)
	@:impl static inline function int_divide(lhs:BaseNotifier<Int>, rhs:Int) : Float
		return lhs.value / rhs;
	
	@:op(A == B)
	@:impl static inline function int_testEq(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value == rhs;
	
	@:op(A = B)
	@:impl static inline function int_equal(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value = rhs;
	
	@:op(A != B)
	@:impl static inline function int_testNeq(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value != rhs;
	
	@:op(A += B)
	@:impl static inline function int_addEq(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value += rhs;
	
	@:op(A -= B)
	@:impl static inline function int_subtractEq(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value -= rhs;
	
	@:op(A *= B)
	@:impl static inline function int_multiplyEq(lhs:BaseNotifier<Int>, rhs:Int) : Int
		return lhs.value *= rhs;
	
	@:op(A << B)
	@:impl static inline function int_shiftLeft(lhs:BaseNotifier<Int>, rhs:Int) : Float
		return lhs.value << rhs;
	
	@:op(A >> B)
	@:impl static inline function int_shiftRight(lhs:BaseNotifier<Int>, rhs:Int) : Float
		return lhs.value >> rhs;
	
	@:op(A > B)
	@:impl static inline function int_grThan(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value > rhs;
	
	@:op(A < B)
	@:impl static inline function int_lsThan(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value < rhs;
	
	@:op(A >= B)
	@:impl static inline function int_grThanEq(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value >= rhs;
	
	@:op(A <= B)
	@:impl static inline function int_lsThanEq(lhs:BaseNotifier<Int>, rhs:Int) : Bool
		return lhs.value <= rhs;
	
	
	
	// Float Operator Overloads
	
	@:op(A++)
	@:impl static inline function float_postIncr(lhs:BaseNotifier<Float>) : Float
		return lhs.value++;
	
	@:op(++A)
	@:impl static inline function float_preIncr(lhs:BaseNotifier<Float>) : Float
		return ++lhs.value;
	
	@:op(A--)
	@:impl static inline function float_postDecr(lhs:BaseNotifier<Float>) : Float
		return lhs.value--;
	
	@:op(--A)
	@:impl static inline function float_preDecr(lhs:BaseNotifier<Float>) : Float
		return --lhs.value;
	
	@:op(A * B)
	@:impl static inline function float_multiply(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value * rhs;
	
	@:op(A + B)
	@:impl static inline function float_add(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value + rhs;
	
	@:op(A - B)
	@:impl static inline function float_subtract(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value - rhs;
	
	@:op(A / B)
	@:impl static inline function float_divide(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value / rhs;
	
	@:op(A == B)
	@:impl static inline function float_testEq(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value == rhs;
	
	@:op(A != B)
	@:impl static inline function float_testNeq(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value != rhs;
	
	@:op(A = B)
	@:impl static inline function float_equal(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value = rhs;
	
	@:op(A += B)
	@:impl static inline function float_addEq(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value += rhs;
	
	@:op(A -= B)
	@:impl static inline function float_subtractEq(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value -= rhs;
	
	@:op(A *= B)
	@:impl static inline function float_multiplyEq(lhs:BaseNotifier<Float>, rhs:Float) : Float
		return lhs.value *= rhs;
	
	@:op(A > B)
	@:impl static inline function float_grThan(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value > rhs;
	
	@:op(A < B)
	@:impl static inline function float_lsThan(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value < rhs;
	
	@:op(A >= B)
	@:impl static inline function float_grThanEq(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value >= rhs;
	
	@:op(A <= B)
	@:impl static inline function float_lsThanEq(lhs:BaseNotifier<Float>, rhs:Float) : Bool
		return lhs.value <= rhs;
	
	
	
	// Bool Operator Overloads
	
	@:op(A == B)
	@:impl static inline function bool_testEq(lhs:BaseNotifier<Bool>, rhs:Bool) : Bool
		return lhs.value == rhs;
	
	@:op(A != B)
	@:impl static inline function bool_testNeq(lhs:BaseNotifier<Bool>, rhs:Bool) : Bool
		return lhs.value != rhs;
	
	@:op(A = B)
	@:impl static inline function bool_equal(lhs:BaseNotifier<Bool>, rhs:Bool) : Bool
		return lhs.value = rhs;
	
	@:op(! A)
	@:impl static inline function bool_negate(lhs:BaseNotifier<Bool>) : Bool
		return !lhs.value;
	
	
	
	// String Operator Overloads
	
	@:op(A + B)
	@:impl static inline function string_add(lhs:BaseNotifier<String>, rhs:String) : String
		return lhs.value + rhs;
	
	@:op(A == B)
	@:impl static inline function string_testEq(lhs:BaseNotifier<String>, rhs:String) : Bool
		return lhs.value == rhs;
	
	@:op(A != B)
	@:impl static inline function string_testNeq(lhs:BaseNotifier<String>, rhs:String) : Bool
		return lhs.value != rhs;
	
	@:op(A = B)
	@:impl static inline function string_equal(lhs:BaseNotifier<String>, rhs:String) : String
		return lhs.value = rhs;
	
}



/**
 * Underlying runtime object
 */
class BaseNotifier<T> extends Signal0 
{
	public var requireChange:Bool = true;
	private var _value:T;
	private var _setHandlers:Array<T->Void>;
	private var _unsetHandlers:Array<T->Void>;
	private var actions:Array<T->T>;
	
	public var value(get, set):Null<T>;
	//public var change:Signal0;
	
	public var sharedObject:DocStore;
	
	public function new(?v:T, ?id:String) 
	{
		//change = new Signal0();
		_value = v;
		if (id != null) {
			sharedObject = DocStore.getLocal("Notifier_" + id);
			var localData:Null<T> = untyped Reflect.getProperty(sharedObject.data, "value");
			if (localData != null) _value = localData;
			this.add(SaveDataLocally);
		}
		super();
	}
	function SaveDataLocally() 
	{
		sharedObject.setProperty("value", this.value);
		sharedObject.flush();
	}
	
	
	
	function toString():String
	{
		return cast this.value;
	}
	
	private function get_value():Null<T> 
	{
		return _value;
	}
	
	private function set_value(v:Null<T>):Null<T> 
	{
		if (actions != null) {
			for (i in 0...actions.length) v = actions[i](v);
		}
		
		if (_value == v && requireChange) return v;
		
		if (_value != null && _unsetHandlers != null) {
			for(handler in _unsetHandlers) handler(_value);
		}
		_value = v;
		if (_value != null && _setHandlers != null) {
			for(handler in _setHandlers) handler(_value);
		}
		this.dispatch();
		return v;
	}
	
	public function addAction(action:T->T) 
	{
		if (actions == null) actions = [];
		actions.push(action);
	}
	
	public function set(handler:T->Void):BaseNotifier<T> 
	{
		if (_setHandlers == null)_setHandlers = [];
		_setHandlers.push(handler);
		return this;
	}
	
	/**
	 * unset handlers are unshifted onto the stack so that unbinding happens in 
	 * the reverse direction to binding (last added first).
	 */
	public function unset(handler:T->Void):BaseNotifier<T>
	{
		if (_unsetHandlers == null)_unsetHandlers = [];
		_unsetHandlers.unshift(handler);
		return this;
	}
}