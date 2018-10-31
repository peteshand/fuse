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
#elseif electron

import js.node.Fs;
import js.node.Os;
import js.node.Path;
import js.node.Require;
import mantle.net.FileReference;
import openfl.net.FileFilter;

class File extends FileReference
{
	

	@:isVar static var temporaryDirectory(get, null):File;
	@:isVar public static var applicationDirectory(get, null):File;
	//@:isVar public static var applicationStorageDirectory(get, null):File;
	//@:isVar public static var cacheDirectory(get, null):File;
	@:isVar public static var desktopDirectory(get, null):File;
	@:isVar public static var documentsDirectory(get, null):File;
	//public static var lineEnding:String;
	//public static var permissionStatus:String;
	public static var separator(get, null):String;
	//public static var systemCharset(get, null):String;
	@:isVar public static var userDirectory(get, null):File;
	
	static function get_userDirectory():File 
	{
		if (userDirectory == null) userDirectory = new File(Os.homedir());
		return userDirectory;
	}
	
	static function get_documentsDirectory():File 
	{
		if (documentsDirectory == null) documentsDirectory = new File(userDirectory.nativePath + Path.sep + 'Documents');
		return documentsDirectory;
	}
	
	static function get_desktopDirectory():File 
	{
		if (desktopDirectory == null) desktopDirectory = new File(userDirectory.nativePath + Path.sep + 'Desktop');
		return desktopDirectory;
	}
	
	static function get_applicationDirectory():File 
	{
		if (applicationDirectory == null) applicationDirectory = new File(Path.dirname(Require.main.filename));
		return applicationDirectory;
	}

	static function get_temporaryDirectory():File 
	{
		if (temporaryDirectory == null) {
			temporaryDirectory = new File(userDirectory.nativePath + Path.sep + '.temp');
			if (!temporaryDirectory.exists) temporaryDirectory.createDirectory();
		}
		return temporaryDirectory;
	}

	
	
	private var path:String;
	
	//public var downloaded:Bool;
	public var exists(get, null):Bool;
	//public var icon(get, null):Icon;
	public var isDirectory(get, never):Bool;
	//public var isHidden(get, never):Bool;
	//public var isPackage(get, never):Bool;
	//public var isSymbolicLink(get, never):Bool;
	public var nativePath(get, never):String;
	//public var parent(get, null):File;
	//public var preventBackup:Bool;
	//public var spaceAvailable(get, null):Float;
	
	public var url(get, null):String;
	
	
	public function new(path:String="") 
	{
		this.path = path;
		super();
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

	static function get_separator():String
	{
		return Path.sep;
	}

	override function get_size():Float
	{
		var stats = Fs.statSync(path);
		return stats.size;
	}






    public function browseForDirectory(title:String):Void
	{
		throw "browseForDirectory is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForOpen(title:String, typeFilter:Array<FileFilter> = null):Void
	{
		throw "browseForOpen is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForOpenMultiple(title:String, typeFilter:Array<FileFilter> = null):Void
	{
		throw "browseForOpenMultiple is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForSave(title:String):Void
	{
		throw "browseForSave is yet to be implemented, please help add this feature";
	}
 	 	
    override public function cancel():Void
	{
		throw "cancel is yet to be implemented, please help add this feature";
	}
 	 	
    public function canonicalize():Void
	{
		throw "canonicalize is yet to be implemented, please help add this feature";
	}
 	 	
    public function clone():File
	{
		throw "clone is yet to be implemented, please help add this feature";
		return null;
	}
 	 	
    public function copyTo(newLocation:FileReference, overwrite:Bool = false):Void
	{
		throw "copyTo is yet to be implemented, please help add this feature";
	}
 	 	
    public function copyToAsync(newLocation:FileReference, overwrite:Bool = false):Void
	{
		throw "copyToAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function createDirectory():Void
	{
		Fs.mkdirSync(path);
	}
 	 	
    public static function createTempDirectory():File
	{
		//throw "createTempDirectory is yet to be implemented, please help add this feature";
		var name:String = StringTools.hex(Math.floor(Math.random() * 100000000000000000));
		return temporaryDirectory.resolvePath(name);
	}
 	 	
    public static function createTempFile():File
	{
		//throw "createTempFile is yet to be implemented, please help add this feature";
		var name:String = StringTools.hex(Math.floor(Math.random() * 100000000000000000)) + ".tmp";
		return temporaryDirectory.resolvePath(name);
	}
 	 	
    public function deleteDirectory(deleteDirectoryContents:Bool = false):Void
	{
		var files:Array<File> = this.getDirectoryListing();
		if (deleteDirectoryContents){
			for (i in 0...files.length){
				if (files[i].isDirectory) files[i].deleteDirectory(true);
				else files[i].deleteFile();
			}
			Fs.rmdirSync(path);
		} else {
			if (files.length == 0) Fs.rmdirSync(path);
		}
	}
 	 	
    public function deleteDirectoryAsync(deleteDirectoryContents:Bool = false):Void
	{
		throw "deleteDirectoryAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function deleteFile()
	{
		Fs.unlinkSync(path);
	}
 	 	
    public function deleteFileAsync():Void
	{
		throw "deleteFileAsync is yet to be implemented, please help add this feature";
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
 	 	
    public function getDirectoryListingAsync():Void
	{
		throw "getDirectoryListingAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function getRelativePath(ref:FileReference, useDotDot:Bool = false):String
	{
		throw "getRelativePath is yet to be implemented, please help add this feature";
	}
 	 	
    public static function getRootDirectories():Array<File>
	{
		throw "getRootDirectories is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveTo(newLocation:FileReference, overwrite:Bool = false):Void
	{
		//throw "moveTo is yet to be implemented, please help add this feature";
		var file:File = cast(newLocation);
		if (file == null) {
			throw 'new location needs to be a file';
		}
		Fs.renameSync(nativePath, file.nativePath);
    }
 	 	
    public function moveToAsync(newLocation:FileReference, overwrite:Bool = false):Void
	{
		throw "moveToAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveToTrash():Void
	{
		throw "moveToTrash is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveToTrashAsync():Void
	{
		throw "moveToTrashAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function openWithDefaultApplication():Void
	{
		throw "openWithDefaultApplication is yet to be implemented, please help add this feature";
	}
 	 	
    override public function requestPermission():Void
	{
		throw "requestPermission is yet to be implemented, please help add this feature";
	}
 	 	
    public function resolvePath(path:String):File
	{
		return new File(this.path + "/" + path);
	}

	
}

#elseif (flash||js)
	
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
		public static var separator(get, null):String;

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

		static function get_separator():String
		{
			return "/";
		}
	}
#elseif html5

#end