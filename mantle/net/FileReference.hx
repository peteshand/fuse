package mantle.net;

#if (js||flash)
import openfl.net.SharedObject;
#end


/**
 * ...
 * @author Thomas Byrne
 */
#if air


	typedef FileReference = flash.net.FileReference;
	
	
#elseif sys


	
#elseif nodejs

import js.node.Fs;
import openfl.utils.ByteArray;
import openfl.net.URLRequest;

class FileReference
{
	public var creationDate(get, null):Date;
	public var creator(get, null):String;
	public var data(get, null):ByteArray;
	public var extension(get, null):String;
	public var modificationDate(get, null):Date;
	public var name(get, null):String;
	public static var permissionStatus(get, null):String;
	public var size(get, null):Float;
	public var type(get, null):String;
	
	public function new() 
	{
		
	}

	function get_creationDate():Date
	{
		// Need to implement
		return null;
	}

	function get_creator():String
	{
		// Need to implement
		return null;
	}
	
	function get_data():ByteArray
	{
		// Need to implement
		return null;
	}
	
	function get_extension():String
	{
		// Need to implement
		return null;
	}
	
	function get_modificationDate():Date
	{
		// Need to implement
		return null;
	}
	
	function get_name():String
	{
		// Need to implement
		return null;
	}
	
	static function get_permissionStatus():String
	{
		// Need to implement
		return null;
	}
	
	function get_size():Float
	{
		// Need to implement
		return 0;
	}
	
	function get_type():String
	{
		// Need to implement
		return null;
	}

	public function browse(typeFilter:Array<String> = null):Bool
	{
		// Need to implement
		return false;
	}

	public function cancel():Void
	{
		// Need to implement
	}
		
	public function download(request:URLRequest, defaultFileName:String = null):Void
	{
		// Need to implement
	}
			
	public function load():Void
	{
		// Need to implement
	}
			
	public function requestPermission():Void
	{
		// Need to implement
	}
			
	public function save(data:Dynamic, defaultFileName:String = null):Void
	{
		// Need to implement
	}
			
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void
	{
		// Need to implement
	}
			
	public function uploadUnencoded(request:URLRequest):Void
	{
		// Need to implement
	}
}

#elseif (js||flash)
	
	class File
	{
		public static var documentsDirectory(get, null):File;
		public static var applicationDirectory(get, null):File;
		
		@:allow(mantle.filesystem.FileStream)
		private var sharedObject:SharedObject;
		private var path:String;
		public var nativePath(get, never):String;
		public var exists(get, null):Bool;
		public var url(get, null):String;
		
		public function new(path:String="") 
		{
			this.path = path;
			init();
		}
		
		private function init():Void
		{
			if (sharedObject == null) sharedObject = SharedObject.getLocal(path);
		}
		
		public function resolvePath(path:String):File
		{
			return new File(this.path + "/" + path);
		}
		
		public function createDirectory():Void
		{
			
		}
		
		private function get_nativePath():String 
		{
			return path;
		}
		
		private function get_url():String 
		{
			return path;
		}
		
		private static function get_documentsDirectory():File 
		{
			return new File("documents/");
		}
		
		private static function get_applicationDirectory():File 
		{
			return new File("applicationDirectory/");
		}
		
		private function get_exists():Bool 
		{
			if (Reflect.getProperty(sharedObject.data, "data") == null) {
				return false;
			}
			else {
				return true;
			}
		}
	}
	
#end