package kea.logic.buffers.atlas;

import kea2.Kea;
import kea.logic.buffers.atlas.drawOrder.AtlasDrawOrder;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.items.AtlasItems;
import kea.logic.buffers.atlas.packer.AtlasPacker;
import kea.logic.buffers.atlas.renderer.AtlasRenderer;
import kea.logic.buffers.atlas.renderer.TextureAtlas;
import kea.logic.renderer.Renderer;
import kea2.display.containers.DisplayObject;
import kea2.display.containers.IDisplay;
import kea.notify.Notifier;
import kha.Image;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasBuffer
{
	public static var TEMP_WIDTH:Int = 4096;
	public static var TEMP_HEIGHT:Int = 4096;
	
	//private var currentImage = new Notifier<Image>();
	
	public var numAtlases:Int = 2;
	public var atlases:Array<TextureAtlas> = [];
	//var textureAtlas:TextureAtlas;
	var updateAvailable:Bool;
	var atlasItems:AtlasItems;
	var atlasDrawOrder:AtlasDrawOrder;
	var orderedlist:Array<AtlasItem> = [];
	var atlasPacker:AtlasPacker;
	var atlasRenderer:AtlasRenderer;
	
	public function new() 
	{
		for (i in 0...numAtlases) 
		{
			atlases.push(new TextureAtlas(i));
		}
		
		//textureAtlas = new TextureAtlas();
		atlasItems = new AtlasItems();
		atlasDrawOrder = new AtlasDrawOrder();
		atlasPacker = new AtlasPacker(this);
		atlasRenderer = new AtlasRenderer(this);
		
	}
	
	@:access(kea.logic.renderer.Renderer)
	public function update() 
	{
		/*if (Renderer.layerStateChangeAvailable) {
			currentImage.remove(OnCurrentDisplayChange);
			currentImage.value = null;
			currentImage.add(OnCurrentDisplayChange);
			//trace("update AtlasBuffer: " + Kea.current.updateList.renderList.length);
			
			for (i in 0...Kea.current.logic.displayList.renderList.length) 
			{
				currentImage.value = Kea.current.logic.displayList.renderList[i].base;
			}
		}
		
		textureAtlas.update();*/
		
		if (updateAvailable) {
			for (i in 0...atlases.length) 
			{
				atlases[i].active = false;
			}
			
			if (orderedlist.length == 0) {
				orderedlist = atlasDrawOrder.findOrderedlist(atlasItems);
			}
			
			//trace("orderedlist.length = " + orderedlist.length);
			if (orderedlist.length == 0) {
				updateAvailable = false;
			}
			
			else if (orderedlist.length > 0) {
				
				var processlist:Array<AtlasItem> = [];
				var len:Int = orderedlist.length;
				if (len > 10) len = 10;
				for (j in 0...len) 
				{
					processlist.push(orderedlist.shift());
				}
				if (orderedlist.length == 0) {
					updateAvailable = false;
				}
				
				atlasPacker.pack(processlist, 0, 0);
				atlasRenderer.render(processlist);
			}
		}
		
		
	}
	
	public function remove(displayObject:DisplayObject) 
	{
		atlasItems.remove(displayObject);
		updateAvailable = true;
		//textureAtlas.removeTexture(id, displayObject);
	}
	
	
	public function add(displayObject:DisplayObject) 
	{
		atlasItems.add(displayObject);
		updateAvailable = true;
		
		//textureAtlas.setTexture(id, displayObject);
	}
	
	/*public function getAtlas(index:Int) 
	{
		if (atlases.length == index) atlases.push(new TextureAtlas(atlases.length));
		return atlases[index];
	}*/
}