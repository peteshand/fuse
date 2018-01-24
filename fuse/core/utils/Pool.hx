package fuse.core.utils;

import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.batches.batch.AtlasBatch;
//import fuse.core.assembler.batches.batch.CacheDrawBatch;
import fuse.core.assembler.batches.batch.DirectBatch;
import fuse.core.assembler.batches.batch.CacheBakeBatch;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.backend.display.CoreMovieClip;

import fuse.core.backend.display.CoreImage;
import fuse.core.backend.display.CoreInteractiveObject;
import fuse.core.backend.display.CoreQuad;
import fuse.core.backend.display.CoreSprite;
import fuse.utils.ObjectPool;
import fuse.core.backend.display.CoreDisplayObject;

/**
 * ...
 * @author P.J.Shand
 */
class Pool
{
	public static var layerBufferes:ObjectPool<LayerBuffer>;
	
	public static var atlasBatches:ObjectPool<AtlasBatch>;
	public static var cacheBakeBatches:ObjectPool<CacheBakeBatch>;
	public static var directBatches:ObjectPool<DirectBatch>;
	//public static var cacheDrawBatches:ObjectPool<CacheDrawBatch>;
	
	public static var atlasPartitions2:ObjectPool<AtlasPartition>;
	public static var displayObjects:ObjectPool<CoreDisplayObject>;
	public static var interactiveObject:ObjectPool<CoreInteractiveObject>;
	public static var sprites:ObjectPool<CoreSprite>;
	public static var images:ObjectPool<CoreImage>;
	public static var movieclips:ObjectPool<CoreMovieClip>;
	public static var quads:ObjectPool<CoreQuad>;
	
	static function __init__():Void
	{
		layerBufferes = new ObjectPool<LayerBuffer>(LayerBuffer, 0, []);
		atlasBatches = new ObjectPool<AtlasBatch>(AtlasBatch, 0, []);
		cacheBakeBatches = new ObjectPool<CacheBakeBatch>(CacheBakeBatch, 0, []);
		directBatches = new ObjectPool<DirectBatch>(DirectBatch, 0, []);
		//cacheDrawBatches = new ObjectPool<CacheDrawBatch>(CacheDrawBatch, 0, []);
		
		atlasPartitions2 = new ObjectPool<AtlasPartition>(AtlasPartition, 0, []);
		
		displayObjects = new ObjectPool<CoreDisplayObject>(CoreDisplayObject, 0, []);
		interactiveObject = new ObjectPool<CoreInteractiveObject>(CoreInteractiveObject, 0, []);
		sprites = new ObjectPool<CoreSprite>(CoreSprite, 0, []);
		images = new ObjectPool<CoreImage>(CoreImage, 0, []);
		movieclips = new ObjectPool<CoreMovieClip>(CoreMovieClip, 0, []);
		quads = new ObjectPool<CoreQuad>(CoreQuad, 0, []);
		
		//staticLayerGroup = new ObjectPool<StaticLayerGroup>(StaticLayerGroup, 0, []);
		//layerGroup = new ObjectPool<LayerGroup>(LayerGroup, 0, []);
	}
	
	public static function init(initNum:Int=100):Void
	{
		displayObjects.spawn(initNum);
		interactiveObject.spawn(initNum);
		sprites.spawn(initNum);
		images.spawn(initNum);
		quads.spawn(initNum);
		
		//staticLayerGroup.spawn(initNum);
		//layerGroup.spawn(initNum);
	}
	
	public function new() { }
}