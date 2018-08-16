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
		
		for (i in 0...HierarchyAssembler.hierarchy.length) 
		{
			add(HierarchyAssembler.hierarchy[i].coreTexture);
		}
		
		//trace("textures.length = " + textures.length);
		
		textures.sort(function(t1:CoreTexture, t2:CoreTexture):Int {
			if (t1.textureData.activeData.height < t2.textureData.activeData.height) return 1;
			else if (t1.textureData.activeData.height > t2.textureData.activeData.height) return -1;
			else return 0;
		});
	}
	
	static inline function add(coreTexture:CoreTexture) 
	{
		if (coreTexture == null) return;
		if (coreTexture.textureData.directRender == 1) return; // Texture should always render directly to the back buffer
		if (coreTexture.textureData.textureAvailable == 0) {
			//trace("texture isn't available: " + coreTexture.textureId);
			return; // Texture isn't render yet, default texture will be used instead
		}
		//trace("width = " + coreTexture.textureData.activeData.width);
		//trace("textureAvailable = " + coreTexture.textureData.textureAvailable);
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