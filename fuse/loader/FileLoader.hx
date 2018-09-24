package fuse.loader;

import mantle.filesystem.File;
import mantle.filesystem.FileMode;
import mantle.filesystem.FileStream;

import openfl.events.Event;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class FileLoader extends Loader
{
	var file:File;
	var fileStream:FileStream;
	var bytes:ByteArray;
	
	public function new() 
	{
		fileStream = new FileStream();
		bytes = new ByteArray();
		
		super();
	}
	
	override public function load(url:String):Void
	{
		file = File.applicationDirectory.resolvePath(url);
		fileStream.open(file, FileMode.READ);
		fileStream.readBytes(bytes, 0, file.size);
		fileStream.close();
		
		bytes.position = 0;
		trace(bytes.bytesAvailable);
		trace(bytes.length);
		
		#if air
			loader.loadBytes(bytes, loaderContext);
		#else
			loader.loadBytes(bytes);
		#end
	}
}