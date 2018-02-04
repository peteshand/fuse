package fuse.loader;

import fuse.filesystem.File;
import fuse.filesystem.FileMode;
import fuse.filesystem.FileStream;

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
	var byteArray:ByteArray;
	
	public function new() 
	{
		fileStream = new FileStream();
		byteArray = new ByteArray();
		
		super();
	}
	
	override public function load(url:String):Void
	{
		file = new File(url);
		fileStream.open(file, FileMode.READ);
		fileStream.readBytes(byteArray, 0, file.size);
		fileStream.close();
		
		#if air
			loader.loadBytes(byteArray, loaderContext);
		#else
			loader.loadBytes(byteArray);
		#end
	}
}