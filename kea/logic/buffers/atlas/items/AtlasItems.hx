package kea.logic.buffers.atlas.items;

import kea.display.DisplayObject;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.texture.Texture;
/**
 * ...
 * @author P.J.Shand
 */

 // The AtlasItems contains all the AtlasItem objects that are currently visible on stage

class AtlasItems
{
	var atlasMap = new Map<Texture, AtlasItem>();
	
	public function new() { }
	
	public function add(displayObject:DisplayObject) 
	{
		if (displayObject.base == null) return;
		
		if (!atlasMap.exists(displayObject.base)) {
			atlasMap.set(displayObject.base, new AtlasItem(displayObject.base));
		}
		var atlasItem:AtlasItem = atlasMap.get(displayObject.base);
		atlasItem.add(displayObject);
	}
	
	public function remove(displayObject:DisplayObject) 
	{
		if (displayObject.base == null) return;
		
		var atlasItem:AtlasItem = atlasMap.get(displayObject.base);
		if (atlasItem != null) {
			if (!atlasItem.remove(displayObject)) {
				atlasMap.remove(displayObject.base);
			}
		}
	}
	
	public function getByTexture(texture:Texture):AtlasItem
	{
		return atlasMap.get(texture);
	}
	
	
}