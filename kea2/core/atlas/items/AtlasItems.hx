package kea2.core.atlas.items;

import kea2.texture.ITexture;
import kea2.display.containers.DisplayObject;
import kea2.core.atlas.items.AtlasItem;
/**
 * ...
 * @author P.J.Shand
 */

 // The AtlasItems contains all the AtlasItem objects that are currently visible on stage

class AtlasItems
{
	var atlasMap = new Map<ITexture, AtlasItem>();
	
	public function new() { }
	
	public function add(texture:ITexture) 
	{
		//if (texture == null) return;
		
		if (!atlasMap.exists(texture)) {
			atlasMap.set(texture, new AtlasItem(texture));
		}
		var atlasItem:AtlasItem = atlasMap.get(texture);
		//atlasItem.add(displayObject);
	}
	
	public function remove(texture:ITexture) 
	{
		//if (texture == null) return;
		
		var atlasItem:AtlasItem = atlasMap.get(texture);
		if (atlasItem != null) {
			//if (!atlasItem.remove(displayObject)) {
				atlasMap.remove(texture);
			//}
		}
	}
	
	public function getByTexture(texture:ITexture):AtlasItem
	{
		return atlasMap.get(texture);
	}
	
	
}