package fuse.pool;

import fuse.core.backend.display.CoreImage;
import fuse.core.backend.display.CoreInteractiveObject;
import fuse.core.backend.display.CoreQuad;
import fuse.core.backend.display.CoreSprite;
import fuse.pool.ObjectPool;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.layerCache.groups.StaticLayerGroup;

/**
 * ...
 * @author P.J.Shand
 */
class Pool
{
	
	public static var displayObjects:ObjectPool<CoreDisplayObject>;
	public static var interactiveObject:ObjectPool<CoreInteractiveObject>;
	public static var sprites:ObjectPool<CoreSprite>;
	public static var images:ObjectPool<CoreImage>;
	public static var quads:ObjectPool<CoreQuad>;
	
	public static var staticLayerGroup:ObjectPool<StaticLayerGroup>;
	public static var layerGroup:ObjectPool<LayerGroup>;
	
	static function __init__():Void
	{
		displayObjects = new ObjectPool<CoreDisplayObject>(CoreDisplayObject, 0, []);
		interactiveObject = new ObjectPool<CoreInteractiveObject>(CoreInteractiveObject, 0, []);
		sprites = new ObjectPool<CoreSprite>(CoreSprite, 0, []);
		images = new ObjectPool<CoreImage>(CoreImage, 0, []);
		quads = new ObjectPool<CoreQuad>(CoreQuad, 0, []);
		
		staticLayerGroup = new ObjectPool<StaticLayerGroup>(StaticLayerGroup, 0, []);
		layerGroup = new ObjectPool<LayerGroup>(LayerGroup, 0, []);
	}
	
	public static function init(initNum:Int=100):Void
	{
		displayObjects.spawn(initNum);
		interactiveObject.spawn(initNum);
		sprites.spawn(initNum);
		images.spawn(initNum);
		quads.spawn(initNum);
		
		staticLayerGroup.spawn(initNum);
		layerGroup.spawn(initNum);
	}
	
	public function new() { }
}