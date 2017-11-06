package fuse.core.communication.data;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class WorkerSharedProperties
{
	public static inline var BACK_TO_MAIN:String = "backToMain";
	public static inline var MAIN_TO_BACK:String = "mainToBack";
	static public inline var TRANSFORM_DATA:String = "transformData";
	static public inline var CONDUCTOR_DATA:String = "conductorData";
	static public inline var CORE_MEMORY:String = "coreMemory";
	static public inline var INDEX:String = "index";
	static public inline var NUMBER_OF_WORKERS:String = "numberOfWorkers";
	static public inline var FRAME_RATE:String = "frameRate";
	static public inline var DISPLAY:String = "display";
	static public inline var MUTEX:String = "mutex";
	static public inline var CONDITION:String = "condition";
	static public inline var VERTEX_DATA:String = "vertexData";
	static public inline var DISPLAY_DATA:String = "displayData";
	
	public function new() 
	{
		
	}
}