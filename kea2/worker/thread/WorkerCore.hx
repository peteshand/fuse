package kea2.worker.thread;
import kea2.worker.communication.IWorkerComms;
import kea2.worker.thread.atlas.AtlasTextureDrawOrder;
import kea2.worker.thread.display.TextureOrder;
import kea2.worker.thread.display.TextureRenderBatch;
import kea2.worker.thread.display.WorkerDisplayList;
import kea2.worker.thread.layerCache.LayerCaches;
import kea2.worker.thread.texture.RenderTextureManager;
import kea2.worker.thread.atlas.AtlasPacker;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerCore
{
	public static var workerDisplayList:WorkerDisplayList;
	
	public static var atlasPacker:AtlasPacker;
	public static var atlasTextureDrawOrder:AtlasTextureDrawOrder;
	
	public static var textureOrder:TextureOrder;
	public static var textureRenderBatch:TextureRenderBatch;
	
	public static var renderTextureManager:RenderTextureManager;
	//public static var workerLayerConstruct:WorkerLayerConstruct;
	public static var layerCache:LayerCaches;
	
	@:isVar public static var textureBuildRequiredCount(default, set):Int = 0;
	
	public static var textureBuildNextFrame:Bool;
	public static var textureBuildRequired:Bool;
	@:isVar public static var hierarchyBuildRequired(get, set):Bool = true;
	public static var STAGE_WIDTH:Int;
	public static var STAGE_HEIGHT:Int;
	
	public function new() { }
	
	static public function init(workerComms:IWorkerComms) 
	{
		WorkerCore.workerDisplayList = new WorkerDisplayList(workerComms);
		
		WorkerCore.atlasPacker = new AtlasPacker();
		WorkerCore.atlasTextureDrawOrder = new AtlasTextureDrawOrder();
		//WorkerCore.atlasTextureRenderBatch = new AtlasTextureRenderBatch();
		
		WorkerCore.textureOrder = new TextureOrder();
		WorkerCore.textureRenderBatch = new TextureRenderBatch();
		
		WorkerCore.renderTextureManager = new RenderTextureManager();
		//WorkerCore.workerLayerConstruct = new WorkerLayerConstruct();
		WorkerCore.layerCache = new LayerCaches();
	}
	
	static inline function get_hierarchyBuildRequired():Bool 
	{
		return hierarchyBuildRequired;
	}
	
	static function set_hierarchyBuildRequired(value:Bool):Bool 
	{
		hierarchyBuildRequired = value;
		
		if (hierarchyBuildRequired) textureBuildRequiredCount = 0;
		else textureBuildRequiredCount++;
		
		return hierarchyBuildRequired;
	}
	
	static function get_textureBuildRequiredCount():Int 
	{
		return textureBuildRequiredCount;
	}
	
	static function set_textureBuildRequiredCount(value:Int):Int 
	{
		textureBuildRequiredCount = value;
		if (textureBuildRequiredCount < 2) textureBuildRequired = true;
		else textureBuildRequired = false;
		return textureBuildRequiredCount = value;
	}
}