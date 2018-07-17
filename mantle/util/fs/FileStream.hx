package mantle.util.fs;
import mantle.util.fs.File;


/**
 * ...
 * @author Thomas Byrne
 */
#if air


	typedef FileStream = flash.filesystem.FileStream;
	
#elseif js
	
	class FileStream
	{
		private var openFile:File;
		public function new()
		{
			
		}
		
		public function open(openFile:File, fileMode:Dynamic) 
		{
			this.openFile = openFile;
			
		}
		
		public function writeUTFBytes(jsonStr:String):String
		{
			if (openFile == null) return null;
			Reflect.setProperty(openFile.sharedObject, "data", jsonStr);
			return jsonStr;
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