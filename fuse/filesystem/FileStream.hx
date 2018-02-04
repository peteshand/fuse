package fuse.filesystem;

import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;


/**
 * ...
 * @author P.J.Shand
 */
//#if air
//
	//typedef FileStream = flash.filesystem.FileStream;	
	//
//#elseif js
	import openfl.utils.Endian;
	
	class FileStream extends EventDispatcher 
	{
		public var bytesAvailable(default, never):UInt;
		public var endian:Endian;
		public var objectEncoding:UInt;
		public var position:Float;
		public var readAhead:Float;
		
		public function new() 
		{
			super();
		}
		
		public function close():Void
		{
			// TODO: implement
		}
		
		public function open(file:File, fileMode:FileMode):Void
		{
			// TODO: implement
		}
		
		public function openAsync(file:File, fileMode:FileMode):Void
		{
			// TODO: implement
		}
		
		public function readBoolean():Bool
		{
			// TODO: implement
			return false;
		}
		
		public function readByte():Int
		{
			// TODO: implement
			return 0;
		}
		
		public function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
		{
			// TODO: implement
		}
		
		public function readDouble():Float
		{
			// TODO: implement
			return 0;
		}
		
		public function readFloat():Float
		{
			// TODO: implement
			return 0;
		}
		
		public function readInt():Int
		{
			// TODO: implement
			return 0;
		}
		
		public function readMultiByte(length:UInt, charSet:String):String
		{
			// TODO: implement
			return null;
		}
		
		public function readObject():Dynamic
		{
			// TODO: implement
			return null;
		}
		
		public function readShort():Int
		{
			// TODO: implement
			return 0;
		}
		
		public function readUTF():String
		{
			// TODO: implement
			return null;
		}
		
		public function readUTFBytes(length:UInt):String
		{
			// TODO: implement
			return null;
		}
		
		public function readUnsignedByte():UInt
		{
			// TODO: implement
			return 0;
		}
		
		public function readUnsignedInt():UInt
		{
			// TODO: implement
			return 0;
		}
		
		public function readUnsignedShort():UInt
		{
			// TODO: implement
			return 0;
		}
		
		public function truncate():Void
		{
			// TODO: implement
		}
		
		public function writeBoolean(value:Bool):Void
		{
			// TODO: implement
		}
		
		public function writeByte(value:Int):Void
		{
			// TODO: implement
		}
		
		public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
		{
			// TODO: implement
		}
		
		public function writeDouble(value:Float):Void
		{
			// TODO: implement
		}
		
		public function writeFloat(value:Float):Void
		{
			// TODO: implement
		}
		
		public function writeInt(value:Int):Void
		{
			// TODO: implement
		}
		
		public function writeMultiByte(value:String, charSet:String):Void
		{
			// TODO: implement
		}
		
		public function writeObject(object:Dynamic):Void
		{
			// TODO: implement
		}
		
		public function writeShort(value:Int):Void
		{
			// TODO: implement
		}
		
		public function writeUTF(value:String):Void
		{
			// TODO: implement
		}
		
		public function writeUTFBytes(value:String):Void
		{
			// TODO: implement
		}
		
		public function writeUnsignedInt(value:UInt):Void
		{
			// TODO: implement
		}
	}
//#end