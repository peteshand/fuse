package fuse.pool;

import fuse.core.backend.display.CoreImage;
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
	public static var sprites:ObjectPool<CoreSprite>;
	public static var images:ObjectPool<CoreImage>;
	public static var quads:ObjectPool<CoreQuad>;
	
	public static var staticLayerGroup:ObjectPool<StaticLayerGroup>;
	public static var layerGroup:ObjectPool<LayerGroup>;
	
	static function __init__():Void
	{
		displayObjects = new ObjectPool<CoreDisplayObject>(CoreDisplayObject, 0, []);
		sprites = new ObjectPool<CoreSprite>(CoreSprite, 0, []);
		images = new ObjectPool<CoreImage>(CoreImage, 0, []);
		quads = new ObjectPool<CoreQuad>(CoreQuad, 0, []);
		
		staticLayerGroup = new ObjectPool<StaticLayerGroup>(StaticLayerGroup, 0, []);
		layerGroup = new ObjectPool<LayerGroup>(LayerGroup, 0, []);
	}
	
	public static function init():Void
	{
		displayObjects.spawn(100);
		sprites.spawn(100);
		images.spawn(100);
		quads.spawn(100);
		
		staticLayerGroup.spawn(100);
		layerGroup.spawn(100);
	}
	
	public function new() { }
}