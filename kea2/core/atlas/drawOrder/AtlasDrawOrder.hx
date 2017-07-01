package kea2.core.atlas.drawOrder;
import kea2.core.atlas.items.AtlasItem;
import kea2.core.atlas.items.AtlasItems;
import kea2.texture.ITexture;
import kea2.utils.Notifier;
import kea2.Kea;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasDrawOrder
{
	private var currentImage = new Notifier<ITexture>();
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
		
		/*for (i in 0...Kea.current.logic.displayList.renderList.length) 
		{
			currentImage.value = Kea.current.logic.displayList.renderList[i].base;
		}*/
		
		return orderedlist;
	}
	
	function OnCurrentDisplayChange() 
	{
		if (currentImage.value != null) {
			orderedlist.push(atlasItems.getByTexture(currentImage.value));
		}
	}
	
}