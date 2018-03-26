package fuse.core.assembler.atlas.textures;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.texture.CoreTexture;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasTextures
{
	public static var textures = new GcoArray<CoreTexture>([]);
	
	public function new() { }
	
	public static function clear() 
	{
		textures.clear();
	}
	
	static public function build() 
	{
		clear();
		
		//trace("HierarchyAssembler.hierarchy.length = " + HierarchyAssembler.hierarchy.length);
		
		for (i in 0...HierarchyAssembler.hierarchy.length) 
		{
			add(HierarchyAssembler.hierarchy[i].coreTexture);
		}
		
		//trace("textures.length = " + textures.length);
	}
	
	static inline function add(coreTexture:CoreTexture) 
	{
		if (coreTexture == null) return;
		if (coreTexture.textureData.directRender == 1) return; // Texture should always render directly to the back buffer
		if (coreTexture.textureData.textureAvailable == 0) {
			//trace("texture isn't available: " + coreTexture.textureId);
			return; // Texture isn't render yet, default texture will be used instead
		}
		
		if (!exists(coreTexture.textureId)) {
			//trace("texture available: " + coreTexture.textureId);
			textures.push(coreTexture);
		}
	}
	
	static private function exists(textureId:Int) 
	{
		for (i in 0...textures.length) 
		{
			if (textureId == textures[i].textureId) return true;
		}
		return false;
	}
}