package fuse.core.communication.memory;

import openfl.utils.ByteArray;
#if air
import flash.Memory as BaseMemory;
#else
import openfl.Memory as BaseMemory;
#end

/**
 * ...
 * @author P.J.Shand
 */
class Memory {
	static var values:Array<Float> = [];

	public static inline function getByte(addr:Int):Int {
		return BaseMemory.getByte(addr);
	}

	public static inline function getDouble(addr:Int):Float {
		return BaseMemory.getDouble(addr);
	}

	public static inline function getFloat(addr:Int):Float {
		return BaseMemory.getFloat(addr);
	}

	public static inline function getI32(addr:Int):Int {
		return BaseMemory.getI32(addr);
	}

	public static inline function getUI16(addr:Int):Int {
		return BaseMemory.getUI16(addr);
	}

	public static function select(inBytes:ByteArray):Void {
		BaseMemory.select(inBytes);
	}

	public static inline function setByte(addr:Int, v:Int):Void {
		BaseMemory.setByte(addr, v);
	}

	public static inline function setDouble(addr:Int, v:Float):Void {
		BaseMemory.setDouble(addr, v);
	}

	public static inline function setFloat(addr:Int, v:Float):Void {
		// if (values[addr] == v) return;
		// values[addr] = v;
		BaseMemory.setFloat(addr, v);
	}

	public static inline function setI16(addr:Int, v:Int):Void {
		BaseMemory.setI16(addr, v);
	}

	public static inline function setI32(addr:Int, v:Int):Void {
		BaseMemory.setI32(addr, v);
	}
}
