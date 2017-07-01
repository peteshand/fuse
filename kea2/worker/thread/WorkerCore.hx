package kea2.worker.thread;
import kea2.worker.thread.display.TextureOrder;
import kea2.worker.thread.display.TextureRenderBatch;
import kea2.worker.thread.display.WorkerDisplayList;
import kea2.worker.thread.layerConstruct.WorkerLayerConstruct;
import kea2.worker.thread.texture.RenderTextureManager;
import kea2.worker.thread.atlas.AtlasPacker;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerCore
{
	public static var textureOrder:TextureOrder;
	public static var textureRenderBatch:TextureRenderBatch;
	public static var atlasPacker:AtlasPacker;
	public static var renderTextureManager:RenderTextureManager;
	public static var workerDisplayList:WorkerDisplayList;
	public static var workerLayerConstruct:WorkerLayerConstruct;
	public static var hierarchyBuildRequired:Bool = true;
	
	public function new() { }
}