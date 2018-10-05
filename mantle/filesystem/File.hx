package mantle.filesystem;

#if (js||flash)
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
#elseif nodejs

import js.node.Fs;
import js.node.Path;
import mantle.net.FileReference;

class File extends FileReference
{
	public static var documentsDirectory(get, null):File;
	public static var applicationDirectory(get, null):File;
	
	static function get_documentsDirectory():File 
	{
		return new File('/Users/peteshand/Documents');
	}
	
	static function get_applicationDirectory():File 
	{
		return new File("/Users/peteshand/Projects/GrumpySailor/create-space/create-space/haxe/bin/electron/bin");
	}
	
	
	private var path:String;
	public var nativePath(get, never):String;
	public var exists(get, null):Bool;
	public var url(get, null):String;
	public var separator(get, null):String;
	public var isDirectory(get, never):Bool;

	public function new(path:String="") 
	{
		this.path = path;
		super();
	}

	public function resolvePath(path:String):File
	{
		return new File(this.path + "/" + path);
	}

	private function get_nativePath():String 
	{
		return path;
	}
	
	private function get_url():String 
	{
		return path;
	}

	private function get_exists():Bool 
	{
		var flag = true;
		try{
			Fs.accessSync(path, Fs.F_OK);
		}catch(e:Dynamic){
			flag = false;
		}
		return flag;
	}

	public function createDirectory():Void
	{
		Fs.mkdirSync(path);
	}

	public function getDirectoryListing():Array<File>
	{
		var fileStrs:Array<String> = Fs.readdirSync(path);
		var files:Array<File> = [];
		for (i in 0...fileStrs.length) {
			files.push(new File(path + separator + fileStrs[i]));
		}
		return files;
	}

	
	function get_isDirectory():Bool 
	{
		return Fs.lstatSync(path).isDirectory();
	}

	override function get_creationDate():Date
	{
		var jsDate = Fs.statSync(path).birthtime;
		return new Date(jsDate.getFullYear(), jsDate.getMonth(), jsDate.getDate(), jsDate.getHours(), jsDate.getMinutes(), jsDate.getSeconds());
	}

	override function get_modificationDate():Date
	{
		var jsDate = Fs.statSync(path).mtime;
		return new Date(jsDate.getFullYear(), jsDate.getMonth(), jsDate.getDate(), jsDate.getHours(), jsDate.getMinutes(), jsDate.getSeconds());
	}

	function get_separator():String
	{
		return Path.sep;
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