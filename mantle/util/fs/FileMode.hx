package mantle.util.fs;


/**
 * ...
 * @author Thomas Byrne
 */
#if air


	typedef FileMode = flash.filesystem.FileMode;
	
#elseif js
	
	class FileMode
	{
		public static var APPEND:String = "append";
		public static var READ:String = "read";
		public static var UPDATE:String = "update";
		public static var WRITE:String = "write";
		
		public function new()
		{
			
		}
	}
	
#end