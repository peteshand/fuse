package mantle.filesystem;

import fuse.info.PlatformInfo;
import openfl.net.FileFilter;
import openfl.net.FileReference;

/**
 * ...
 * @author P.J.Shand
 */
#if air
typedef File = flash.filesystem.File;
#elseif js
class File extends FileReference {
	@:isVar public static var applicationDirectory(get, null):File;
	@:isVar public static var applicationStorageDirectory(get, null):File;
	@:isVar public static var cacheDirectory(get, null):File;
	@:isVar public static var desktopDirectory(get, null):File;
	@:isVar public static var documentsDirectory(get, null):File;
	@:isVar public static var userDirectory(get, null):File;

	static function __init__():Void {
		applicationDirectory = new File("js://applicationDirectory");
		applicationStorageDirectory = new File("js://applicationStorageDirectory");
		cacheDirectory = new File("js://cacheDirectory");
		desktopDirectory = new File("js://desktopDirectory");
		documentsDirectory = new File("js://documentsDirectory");
		userDirectory = new File("js://userDirectory");
	}

	public static var lineEnding(get, never):String;
	public static var permissionStatus(get, never):String;
	public static var separator(get, null):String;
	public static var systemCharset(default, never):String;

	public var downloaded:Bool;
	public var exists(default, never):Bool;
	// public var icon(default,never):flash.desktop.Icon;
	public var isDirectory(default, never):Bool;
	public var isHidden(default, never):Bool;
	public var isPackage(default, never):Bool;
	public var isSymbolicLink(default, never):Bool;
	public var nativePath:String;
	public var parent(default, never):File;
	public var preventBackup:Bool;
	public var spaceAvailable(default, never):Float;
	public var url:String;

	var path:String;

	public function new(?path:String) {
		super();
		this.path = path;
	}

	public function browseForDirectory(title:String):Void {
		// TODO: implement
	}

	public function browseForOpen(title:String, ?typeFilter:Array<FileFilter>):Void {
		// TODO: implement
	}

	public function browseForOpenMultiple(title:String, ?typeFilter:Array<FileFilter>):Void {
		// TODO: implement
	}

	public function browseForSave(title:String):Void {
		// TODO: implement
	}

	public function canonicalize():Void {
		// TODO: implement
	}

	public function clone():File {
		// TODO: implement
		return null;
	}

	public function copyTo(newLocation:flash.net.FileReference, overwrite:Bool = false):Void {
		// TODO: implement
	}

	public function copyToAsync(newLocation:flash.net.FileReference, overwrite:Bool = false):Void {
		// TODO: implement
	}

	public function createDirectory():Void {
		// TODO: implement
	}

	public function deleteDirectory(deleteDirectoryContents:Bool = false):Void {
		// TODO: implement
	}

	public function deleteDirectoryAsync(deleteDirectoryContents:Bool = false):Void {
		// TODO: implement
	}

	public function deleteFile():Void {
		// TODO: implement
	}

	public function deleteFileAsync():Void {
		// TODO: implement
	}

	public function getDirectoryListing():Array<File> {
		// TODO: implement
		return null;
	}

	public function getDirectoryListingAsync():Void {
		// TODO: implement
	}

	public function getRelativePath(ref:flash.net.FileReference, useDotDot:Bool = false):String {
		// TODO: implement
		return null;
	}

	public function moveTo(newLocation:flash.net.FileReference, overwrite:Bool = false):Void {
		// TODO: implement
	}

	public function moveToAsync(newLocation:flash.net.FileReference, overwrite:Bool = false):Void {
		// TODO: implement
	}

	public function moveToTrash():Void {
		// TODO: implement
	}

	public function moveToTrashAsync():Void {
		// TODO: implement
	}

	public function openWithDefaultApplication():Void {
		// TODO: implement
	}

	public function resolvePath(path:String):File {
		return new File(this.path + separator + path);
	}

	public static function createTempDirectory():File {
		// TODO: implement
		return null;
	}

	public static function createTempFile():File {
		// TODO: implement
		return null;
	}

	public static function getRootDirectories():Array<File> {
		// TODO: implement
		return null;
	}

	static function get_applicationDirectory():File {
		return applicationDirectory;
	}

	static function get_applicationStorageDirectory():File {
		return applicationStorageDirectory;
	}

	static function get_cacheDirectory():File {
		return cacheDirectory;
	}

	static function get_desktopDirectory():File {
		return desktopDirectory;
	}

	static function get_documentsDirectory():File {
		return documentsDirectory;
	}

	static function get_userDirectory():File {
		return userDirectory;
	}

	static function get_lineEnding():String {
		if (PlatformInfo.platform == Platform.WINDOWS)
			return String.fromCharCode(0x0D);
		else if (PlatformInfo.platform == Platform.MAC)
			return String.fromCharCode(0x0A);
		else
			return null;
	}

	static function get_permissionStatus():String {
		return PermissionStatus.GRANTED;
	}

	static function get_separator():String {
		// TODO: test on each platform
		if (PlatformInfo.platform == Platform.WINDOWS)
			return "\\";
		else if (PlatformInfo.platform == Platform.MAC)
			return "/";
		else
			return "/";
	}
}
#end
