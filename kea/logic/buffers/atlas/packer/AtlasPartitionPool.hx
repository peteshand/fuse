package kea.logic.buffers.atlas.packer;
import flash.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasPartitionPool
{
	static var initialSpawnCount:Int = 5000;
	static var availableItems:Map<Int, AtlasPartition>;
	static var count:Int = 0;
	
	public function new() {}
	
	static function init() 
	{
		//trace("init");
		availableItems = new Map<Int, AtlasPartition>();
		for (i in 0...initialSpawnCount) 
		{
			var item:AtlasPartition = new AtlasPartition(i, 0, 0, 0, 0);
			availableItems.set(i, item);
		}
	}
	
	public static function allocate(x:Int, y:Int, width:Int, height:Int):AtlasPartition
	{
		if (availableItems == null) AtlasPartitionPool.init();
		//
		count++;
		var item:AtlasPartition = availableItems.iterator().next();
		if (item == null) {
			//trace("allocate " + count);
			item = new AtlasPartition(count, 0, 0, 0, 0);
		}
		else availableItems.remove(item.key);
		
		item.init(x, y, width, height);
		
		return item;
	}
	
	public static function release(item:AtlasPartition):Void
	{
		//trace("release " + count);
		count--;
		availableItems.set(item.key, item);
	}
	
}