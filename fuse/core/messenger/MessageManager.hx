package fuse.core.messenger;

import fuse.core.communication.data.MemoryBlock;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.messenger.message.IMessage;
import openfl.Lib;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class MessageManager
{
	static var _memoryBlock:MemoryBlock;
	static var memoryBlock(get, null):MemoryBlock;
	
	public static var BUFFER_SIZE:Int = 100000;
	static var typeMap:Map<String, MessageTypeInfo>;
	static var typeIndexCount:Int = 1;
	
	//static var writePosition:Int = 0;
	
	static var messengers = new Map<Int, IMessage<Dynamic>>();
	
	static function init():Void
	{
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnTick);
		
		typeMap = new Map<String, MessageTypeInfo>();
		MessageManager.registerType(Int);
		MessageManager.registerType(Float);
		MessageManager.registerType(Array);
	}
	
	public static function registerType(type:Dynamic):Void
	{
		var typeName:String = Type.getClassName(type);
		if (typeMap.exists(typeName)) return;
		
		var messageTypeInfo:MessageTypeInfo = { 
			type:type, 
			typeName:typeName, 
			typeIndex:typeIndexCount
		};
		
		typeMap.set(typeName, messageTypeInfo);
		trace("registerType: " + typeName + " - " + typeIndexCount);
		typeIndexCount++;
		
	}
	
	static function getTypeIndex(type:Dynamic):Int
	{
		return typeMap.get(Type.getClassName(type)).typeIndex;
	}
	
	static private function OnTick(e:Event):Void 
	{
		if (_memoryBlock == null) return;
		
		SharedMemory.memory.position = memoryBlock.start;
		ProcessData();
		
		SharedMemory.memory.position = memoryBlock.start;
		SharedMemory.memory.writeInt(0);
		SharedMemory.memory.position = memoryBlock.start;
		//writePosition = 0;
	}
	
	static private function ProcessData() 
	{
		var _id:Int = SharedMemory.memory.readInt();
		if (_id == 0) {
			SharedMemory.memory.position = memoryBlock.start;
			return;
		}
		var messenger:IMessage<Dynamic> = messengers.get(_id);
		if (messenger != null) {
			messenger.process();
			//ProcessData();
		}
	}
	
	public function new() 
	{
		
	}
	
	static function get_memoryBlock():MemoryBlock 
	{
		if (_memoryBlock == null) {
			_memoryBlock = Fuse.current.sharedMemory.messageDataPool.createMemoryBlock(MessageManager.BUFFER_SIZE, 0);
		}
		return _memoryBlock;
	}
	
}

typedef MessageTypeInfo =
{
	type:Dynamic,
	typeName:String,
	typeIndex:Int
}