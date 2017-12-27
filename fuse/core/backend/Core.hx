package fuse.core.backend;
import fuse.core.backend.texture.CoreTextures;
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.backend.texture.RenderTextureManager;

/**
 * ...
 * @author P.J.Shand
 */

class Core
{
	public static var displayList:DisplayList;
	public static var textures:CoreTextures;
	public static var textureRenderBatch:TextureRenderBatch;
	public static var renderTextureManager:RenderTextureManager;
	
	@:isVar public static var textureBuildRequiredCount(default, set):Int = 0;
	
	public static var textureBuildNextFrame:Bool;
	public static var textureBuildRequired:Bool;
	public static var STAGE_WIDTH(default, set):Int;
	public static var STAGE_HEIGHT(default, set):Int;
	public static var RESIZE:Bool = false;
	
	@:isVar public static var isStatic(get, set):Int;
	
	public function new() { }
	
	static public function init() 
	{
		Core.displayList = new DisplayList();
		
		
		Core.textures = new CoreTextures();
		Core.textureRenderBatch = new TextureRenderBatch();
		
		Core.renderTextureManager = new RenderTextureManager();
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
	
	static function get_isStatic():Int 
	{
		return isStatic;
	}
	
	static function set_isStatic(value:Int):Int 
	{
		if (isStatic == value) return value;
		isStatic = value;
		return isStatic;
	}
	
	static function set_STAGE_WIDTH(value:Int):Int 
	{
		if (STAGE_WIDTH == value) return value;
		STAGE_WIDTH = value;
		RESIZE = true;
		return STAGE_WIDTH;
	}
	
	static function set_STAGE_HEIGHT(value:Int):Int 
	{
		if (STAGE_HEIGHT == value) return value;
		STAGE_HEIGHT = value;
		RESIZE = true;
		return STAGE_HEIGHT;
	}
}