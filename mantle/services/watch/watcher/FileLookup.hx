package mantle.services.watch.watcher;

import mantle.delay.Delay;
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;
import openfl.errors.Error;
import openfl.events.IOErrorEvent;

/**
 * ...
 * @author P.J.Shand
 */
class FileLookup
{
	private static var MAX_FILES_PER_CHUNK:Int = 30;
	
	var extensions:Array<String>;
	var recursive:Bool;
	var onInitComplete:Void->Void;
	var isGettingListing:Array<File> = [];
	
	public var children = new Map<String, FileLookup>();
	public var currentPaths = new Array<String>();
	public var file:File;
	public var lastSettings:LastSettings;
	
	public var onNewFile = new Signal1(File);
	public var onFileChange = new Signal1(File);
	public var onRemoveFile = new Signal1(File);
	
	@:allow(com.imagination.core.services.watch.watcher)
	private function new() 
	{
		
	}
	
	public function init(file:File, extensions:Array<String>=null, recursive:Bool=false, ?onInitComplete:Void->Void) 
	{
		this.file = file;
		this.extensions = extensions;
		this.recursive = recursive;
		this.onInitComplete = onInitComplete;
		
		for (i in 0 ... extensions.length){
			var extension = extensions[i];
			if (extension.charAt(0) == "."){
				extensions[i] = extension.substr(1);
			}
		}
		
		if (file.isDirectory) {
			readDirectory(file, onInitialFiles, finaliseInit);
		}
		else {
			if (extensionMatch(file)){
				onNewFile.dispatch(file);
			}
			finaliseInit();
		}
	}
	
	function finaliseInit() 
	{
		if (file.isDirectory) {
			lastSettings = { modificationTime: file.modificationDate.getTime(), exists:file.exists };	
		}
		else {
			lastSettings = { modificationTime: file.modificationDate.getTime(), exists:file.exists };
		}
		if(onInitComplete != null) onInitComplete();
	}
	
	function readDirectory(file:File, onFiles:Array<File> -> Void, onComplete:Void->Void, ?onFail:String->Void, retries:Int = 2) 
	{
		if (!file.exists){
			onComplete();
			return;
		}
		
		isGettingListing.push(file);
		
		var onSuccess;
		var onErrorBase;
		var onError;
		
		onSuccess = function(e:FileListEvent){
			isGettingListing.remove(file);
			file.removeEventListener(FileListEvent.DIRECTORY_LISTING, onSuccess);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			processFiles(e.files, onFiles, onComplete);
		}
		onErrorBase = function(error:String){
			isGettingListing.remove(file);
			file.removeEventListener(FileListEvent.DIRECTORY_LISTING, onSuccess);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			if (retries > 0){
				readDirectory(file, onFiles, onComplete, onFail, retries - 1);
			}else{
				if (onFail != null) onFail(error);
			}
		}
		onError = function(e:IOErrorEvent){
			onErrorBase(e.text);
		}
		file.addEventListener(FileListEvent.DIRECTORY_LISTING, onSuccess);
		file.addEventListener(IOErrorEvent.IO_ERROR, onError);
		
		try{
			file.getDirectoryListingAsync();
		}catch (e:Dynamic){
			onErrorBase(Std.string(e));
		}
	}
	
	function processFiles(files:Array<File>, onFiles:Array<File> -> Void, onComplete:Void->Void) 
	{
		if (files.length > MAX_FILES_PER_CHUNK){
			onFiles(files.splice(0, MAX_FILES_PER_CHUNK));
			Delay.byFrames(1, processFiles.bind(files, onFiles, onComplete));
		}else{
			onFiles(files);
			files = null;
			onComplete();
		}
	}
	
	private function onInitialFiles(files:Array<File>):Void 
	{
		for (file in files) 
		{
			if (recursive && file.isDirectory) {
				createNew(file);
				continue;
			}
			
			if (!extensionMatch(file)) continue;
			
			createNew(file);
		}
	}
	
	private function extensionMatch(file:File):Bool
	{
		if (extensions == null) return true;
		var extension:String = file.type.substr(1); // strip "."
		return extensions.indexOf(extension) != -1;
	}
	
	function createNew(_file:File) 
	{
		var fileLookup:FileLookup = new FileLookup();
		fileLookup.onNewFile.add(OnNewChildFile);
		fileLookup.onFileChange.add(OnChildUpdateFile);
		fileLookup.onRemoveFile.add(OnRemoveChildFile);
		fileLookup.init(_file, extensions);
		children.set(_file.nativePath, fileLookup);
		currentPaths.push(_file.nativePath);
	}
	
	function remove(key:String) 
	{
		var fileLookup:FileLookup = children.get(key);
		if (fileLookup == null) return;
		
		OnRemoveChildFile(fileLookup.file);
		fileLookup.onNewFile.remove(OnNewChildFile);
		fileLookup.onFileChange.remove(OnChildUpdateFile);
		fileLookup.onRemoveFile.remove(OnRemoveChildFile);
		children.remove(key);
		currentPaths.remove(key);
	}
	
	/*public static function getExtension(value:String):String
	{
		var extension:String = value.substring(value.lastIndexOf(".")+1, value.length);
		return extension;
	}*/
	
	function OnNewChildFile(childFile:File) 
	{
		if (extensions == null) onNewFile.dispatch(childFile);
		else {
			for (i in 0...extensions.length) {
				if ("." + extensions[i] == childFile.type) onNewFile.dispatch(childFile);
			}
		}
	}
	
	function OnChildUpdateFile(childFile:File) 
	{
		if (extensions == null) onFileChange.dispatch(childFile);
		else {
			for (i in 0...extensions.length) {
				if ("." + extensions[i] == childFile.type) onFileChange.dispatch(childFile);
			}
		}
	}
	
	function OnRemoveChildFile(childFile:File) 
	{
		if (extensions == null) onRemoveFile.dispatch(childFile);
		else {
			for (i in 0...extensions.length) {
				if ("." + extensions[i] == childFile.type) onRemoveFile.dispatch(childFile);
			}
		}
	}
	
	public function checkForChange(?onComplete:Void->Void):Void
	{
		if (!file.isDirectory) return;
		
		if (file.isDirectory){
			var oldKeys:Array<String> = currentPaths.concat([]);
			readDirectory(file, onCheckFiles.bind(_, oldKeys), onCheckComplete.bind(onComplete, oldKeys));
		}
		if (lastSettings.exists != file.exists) {
			lastSettings.exists = file.exists;
			children.remove(file.nativePath);
			OnRemoveChildFile(file);
		}
		else if (lastSettings.modificationTime != file.modificationDate.getTime()) {
			lastSettings.modificationTime = file.modificationDate.getTime();
			OnChildUpdateFile(file);
		}
	}
	
	public function onCheckFiles(files:Array<File>, oldKeys:Array<String>):Void
	{
		for (file in files){
			if (!oldKeys.remove(file.nativePath)){
				createNew(file);
			}
		}
	}
	
	public function onCheckComplete(?onComplete:Void->Void, oldKeys:Array<String>):Void
	{
		for(oldKey in oldKeys){
			remove(oldKey);
		}
		
		if (recursive){
			checkChildren(currentPaths, 0, onComplete);
		}else{
			if (onComplete != null) onComplete();
		}
		
	}
	
	public function checkChildren(childKeys:Array<String>, ind:Int, ?onComplete:Void->Void):Void
	{
		if (ind >= childKeys.length){
			if (onComplete != null) onComplete();
			return;
		}
		var child:FileLookup = children[childKeys[ind]];
		child.checkForChange(checkChildren.bind(childKeys, ind, onComplete));
	}
}

typedef LastSettings = {
	modificationTime:Float,
	exists:Bool
}