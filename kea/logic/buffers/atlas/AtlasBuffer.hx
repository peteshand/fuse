package kea.logic.buffers.atlas;

import kea.Kea;
import kea.logic.renderer.Renderer;
import kea.display.DisplayObject;
import kea.display.IDisplay;
import kea.model.buffers.atlas.TextureAtlas;
import kea.notify.Notifier;
import kha.Image;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasBuffer
{
	private var currentImage = new Notifier<Image>();
	
	private var atlases:Array<TextureAtlas> = [];
	var textureAtlas:TextureAtlas;
	
	public function new() 
	{
		textureAtlas = new TextureAtlas();
	}
	
	@:access(kea.logic.renderer.Renderer)
	public function update() 
	{
		if (Renderer.layerStateChangeAvailable) {
			currentImage.remove(OnCurrentDisplayChange);
			currentImage.value = null;
			currentImage.add(OnCurrentDisplayChange);
			//trace("update AtlasBuffer: " + Kea.current.updateList.renderList.length);
			
			for (i in 0...Kea.current.logic.displayList.renderList.length) 
			{
				currentImage.value = Kea.current.logic.displayList.renderList[i].base;
			}
		}
		
		textureAtlas.update();
	}
	
	function OnCurrentDisplayChange() 
	{
		//if (currentImage.value != null) trace("Base Image = " + currentImage.value.name);
		//else trace("null");
	}
	
	
	
	
	
	
	
	
	
	
	
	public function setTexture(id:Int, displayObject:DisplayObject) 
	{
		textureAtlas.setTexture(id, displayObject);
	}
}