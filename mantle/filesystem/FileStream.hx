package mantle.filesystem;

import openfl.utils.ByteArray;
import mantle.filesystem.File;


/**
 * ...
 * @author Thomas Byrne
 */
#if air


	typedef FileStream = flash.filesystem.FileStream;

#elseif nodejs

import js.node.Fs;
import js.node.fs.ReadStream;
import js.node.fs.WriteStream;
import js.node.Buffer;

class FileStream
{
	var openFile:File;
	var fileMode:FileMode;
	var writeStream:WriteStream;
	var readStream:ReadStream;
	
	public function new()
	{
		
	}
	
	public function open(openFile:File, fileMode:FileMode) 
	{
		this.openFile = openFile;
		this.fileMode = fileMode;

		if (fileMode == FileMode.WRITE) writeStream = Fs.createWriteStream(openFile.nativePath);
		else if (fileMode == FileMode.READ) readStream = Fs.createReadStream(openFile.nativePath);
		
		
	}

	public function readUTF():String
	{
		if (openFile == null) return null;
		return Fs.readFileSync(openFile.nativePath, 'utf8');
	}
	
	public function writeUTFBytes(value:String):String
	{
		if (openFile == null) return null;
		
		writeStream.once('open', function(fd) {
			writeStream.write(value);
			writeStream.end();
		});

		return value;
	}

	public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		if (openFile == null) return null;
		
		writeStream.once('open', function(fd) {
			writeStream.write(Buffer.from(bytes));
			writeStream.end();
		});
	}

	
	
	public function close() 
	{
		
		openFile = null;
	}
}
#elseif js
	
	class FileStream
	{
		var openFile:File;
		var fileMode:FileMode;

		public function new()
		{
			
		}
		
		public function open(openFile:File, fileMode:FileMode) 
		{
			this.openFile = openFile;
			this.fileMode = fileMode;
		}
		
		public function writeUTFBytes(value:String):String
		{
			if (openFile == null) return null;
			Reflect.setProperty(openFile.sharedObject, "data", value);
			return value;
		}

		public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
		{
			if (openFile == null) return null;
			Reflect.setProperty(openFile.sharedObject, "data", bytes);
		}

		
		
		public function close() 
		{
			if (openFile != null) {
				openFile.sharedObject.flush();
			}
			openFile = null;
		}
	}
	
#end