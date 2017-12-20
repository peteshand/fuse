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
	public static var STAGE_WIDTH:Int;
	public static var STAGE_HEIGHT:Int;
	
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
}