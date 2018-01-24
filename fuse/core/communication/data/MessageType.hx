package fuse.core.communication.data;

/**
 * ...
 * @author P.J.Shand
 */

class MessageType
{
	public static inline var INIT:String = "init";
	public static inline var UPDATE:String = "update";
	static public inline var UPDATE_RETURN:String = "updateReturn";
	static public inline var ADD_MASK:String = "addMask";
	static public inline var REMOVE_MASK:String = "removeMask";
	static public inline var ADD_CHILD:String = "addDisplay";
	static public inline var ADD_CHILD_AT:String = "addDisplayAt";
	static public inline var REMOVE_CHILD:String = "removeDisplay";
	static public inline var SET_TOUCHABLE:String = "setTouchable";
	static public inline var MAIN_THREAD_TICK:String = "mainThreadTick";
	static public inline var WORKER_STARTED:String = "workerStarted";
	static public inline var ADD_TEXTURE:String = "addTexture";
	static public inline var REMOVE_TEXTURE:String = "removeTexture";
	//static public inline var ADD_TEXTURE:String = "addTexture";
	static public inline var MOUSE_INPUT:String = "mouseInput";
	static public inline var MOUSE_COLLISION:String = "mouseCollision";
	
	public function new() 
	{
		
	}
	
}