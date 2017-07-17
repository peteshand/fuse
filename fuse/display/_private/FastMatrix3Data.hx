package fuse.display._private;
import kha.FastFloat;
import openfl.utils.ByteArray.ByteArrayData;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
@:forward(readBytes, writeBytes, length, position, endian)

abstract FastMatrix3Data(ByteArrayData) from ByteArrayData to ByteArrayData
{
	public static var renderId:Int = 0;
	public static var objectLength:Int = 36;
	
	public var _00(get, set):FastFloat;
	public var _10(get, set):FastFloat;
	public var _20(get, set):FastFloat;
	public var _01(get, set):FastFloat;
	public var _11(get, set):FastFloat;
	public var _21(get, set):FastFloat;
	public var _02(get, set):FastFloat;
	public var _12(get, set):FastFloat;
	public var _22(get, set):FastFloat;
	
	public inline function new():Void
	{	
		this = new ByteArrayData();
		this.length = 36 * 1000;
		this.endian = Endian.LITTLE_ENDIAN;
		this.shareable = true;
	}
	
	inline function get__00():FastFloat { 
		this.position = (renderId * objectLength) + 0;
		return this.readFloat();
	}
	
	inline function get__10():FastFloat { 
		this.position = (renderId * objectLength) + 4;
		return this.readFloat();
	}
	
	inline function get__20():FastFloat { 
		this.position = (renderId * objectLength) + 8;
		return this.readFloat();
	}
	
	inline function get__01():FastFloat { 
		this.position = (renderId * objectLength) + 12;
		return this.readFloat();
	}
	
	inline function get__11():FastFloat { 
		this.position = (renderId * objectLength) + 16;
		return this.readFloat();
	}
	
	inline function get__21():FastFloat { 
		this.position = (renderId * objectLength) + 20;
		return this.readFloat();
	}
	
	inline function get__02():FastFloat { 
		this.position = (renderId * objectLength) + 24;
		return this.readFloat();
	}
	
	inline function get__12():FastFloat { 
		this.position = (renderId * objectLength) + 28;
		return this.readFloat();
	}
	
	inline function get__22():FastFloat { 
		this.position = (renderId * objectLength) + 32;
		return this.readFloat();
	}
	
	
	
	
	inline function set__00(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 0;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__10(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 4;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__20(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 8;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__01(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 12;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__11(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 16;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__21(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 20;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__02(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 24;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__12(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 28;
		this.writeFloat(value);
		return value;
	}
	
	inline function set__22(value:FastFloat):FastFloat { 
		this.position = (renderId * objectLength) + 32;
		this.writeFloat(value);
		return value;
	}
}