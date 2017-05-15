package kea.logic.buffers.atlas.drawOrder;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.items.AtlasItems;
import kea.notify.Notifier;
import kea.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasDrawOrder
{
	private var currentImage = new Notifier<Texture>();
	var atlasItems:AtlasItems;
	var orderedlist:Array<AtlasItem>;
	
	public function new() 
	{
		
		
	}
	
	public function findOrderedlist(atlasItems:AtlasItems) 
	{
		this.atlasItems = atlasItems;
		
		orderedlist = [];
		currentImage.remove(OnCurrentDisplayChange);
		currentImage.value = null;
		currentImage.add(OnCurrentDisplayChange);
		
		for (i in 0...Kea.current.logic.displayList.renderList.length) 
		{
			currentImage.value = Kea.current.logic.displayList.renderList[i].base;
		}
		
		return orderedlist;
	}
	
	function OnCurrentDisplayChange() 
	{
		if (currentImage.value != null) {
			orderedlist.push(atlasItems.getByTexture(currentImage.value));
		}
	}
	
}