package mantle.util.fs;

#if js
import openfl.net.SharedObject;

#end


/**
 * ...
 * @author Thomas Byrne
 */
#if air


	typedef File = flash.filesystem.File;
	
	
#elseif sys


	abstract File(String)
	{
		public function new(path:String) 
		{
			this = path;
		}
		
		public function resolvePath(path:String):File
		{
			return new File(this + "/" + path);
		}
		
		public function deleteFile():Void
		{
			sys.FileSystem.deleteFile(this);
		}
		
		public function deleteDirectory(deleteDirectoryContents : Bool=false):Void
		{
			if (!deleteDirectoryContents && getDirectoryListing().length > 0){
				throw "Cannot delete directory with contents";
			}
			sys.FileSystem.deleteDirectory(this);
		}
		
		public function createDirectory():Void
		{
			sys.FileSystem.createDirectory(this);
		}
		
		public function getDirectoryListing():Array<File>
		{
			return cast sys.FileSystem.readDirectory(this);
		}
		
		public var exists(get, never):Bool;
		function get_exists():Bool 
		{
			return sys.FileSystem.exists(this);
		}
		
		public var isDirectory(get, never):Bool;
		function get_isDirectory():Bool 
		{
			return sys.FileSystem.isDirectory(this);
		}
		
		public var nativePath(get, never):String;
		function get_nativePath():String 
		{
			return this;
		}
	}
#elseif js
	
	class File
	{
		public static var documentsDirectory(get, null):File;
		
		@:allow(mantle.util.fs.FileStream)
		private var sharedObject:SharedObject;
		private var path:String;
		public var nativePath(get, null):String;
		public var exists(get, null):Bool;
		
		public function new(path:String) 
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
		
		
		private function get_nativePath():String 
		{
			return path;
		}
		
		private static function get_documentsDirectory():File 
		{
			return new File("documents/");
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