package fuse.core.backend;
import fuse.core.backend.texture.CoreTextures;
import fuse.core.communication.IWorkerComms;
import fuse.core.backend.atlas.AtlasTextureDrawOrder;
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.TextureOrder;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.backend.displaylist.DisplayListBuilder;
import fuse.core.backend.layerCache.LayerCaches;
import fuse.core.backend.texture.RenderTextureManager;
import fuse.core.backend.atlas.AtlasPacker;

/**
 * ...
 * @author P.J.Shand
 */
class Core
{
	public static var displayList:DisplayList;
	public static var displayListBuilder:DisplayListBuilder;
	
	public static var atlasPacker:AtlasPacker;
	public static var atlasTextureDrawOrder:AtlasTextureDrawOrder;
	
	public static var textures:CoreTextures;
	public static var textureOrder:TextureOrder;
	public static var textureRenderBatch:TextureRenderBatch;
	
	public static var renderTextureManager:RenderTextureManager;
	//public static var workerLayerConstruct:WorkerLayerConstruct;
	public static var layerCaches:LayerCaches;
	
	@:isVar public static var textureBuildRequiredCount(default, set):Int = 0;
	
	public static var textureBuildNextFrame:Bool;
	public static var textureBuildRequired:Bool;
	@:isVar public static var hierarchyBuildRequired(get, set):Bool = true;
	public static var STAGE_WIDTH:Int;
	public static var STAGE_HEIGHT:Int;
	
	public static var isStatic:Int;
	
	public static var texturesHaveChanged:Bool = false;
	
	public function new() { }
	
	static public function init() 
	{
		Core.displayList = new DisplayList();
		Core.displayListBuilder = new DisplayListBuilder();
		
		Core.atlasPacker = new AtlasPacker();
		Core.atlasTextureDrawOrder = new AtlasTextureDrawOrder();
		//WorkerCore.atlasTextureRenderBatch = new AtlasTextureRenderBatch();
		
		Core.textures = new CoreTextures();
		Core.textureOrder = new TextureOrder();
		Core.textureRenderBatch = new TextureRenderBatch();
		
		Core.renderTextureManager = new RenderTextureManager();
		//WorkerCore.workerLayerConstruct = new WorkerLayerConstruct();
		Core.layerCaches = new LayerCaches();
	}
	
	static inline function get_hierarchyBuildRequired():Bool 
	{
		return hierarchyBuildRequired;
	}
	
	static function set_hierarchyBuildRequired(value:Bool):Bool 
	{
		hierarchyBuildRequired = value;
		//trace("hierarchyBuildRequired = " + hierarchyBuildRequired);
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
		//trace("textureBuildRequiredCount = " + textureBuildRequiredCount);
		if (textureBuildRequiredCount < 2) textureBuildRequired = true;
		else textureBuildRequired = false;
		
		return textureBuildRequiredCount = value;
	}
}