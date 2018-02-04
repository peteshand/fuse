package fuse.filesystem;

/**
 * ...
 * @author P.J.Shand
 */
//#if air
//
	//typedef FileMode = flash.filesystem.FileMode;	
	//
//#elseif js
	@:enum abstract FileMode(String) from String to String
	{
		public static inline var APPEND:String = "append";
		public static inline var READ:String = "read";
		public static inline var UPDATE:String = "update";
		public static inline var WRITE:String = "write";
	}
//#end