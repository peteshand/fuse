package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObject;
import fuse.display.Image;
import fuse.texture.IBaseTexture;
import fuse.texture.AbstractTexture;
import openfl.errors.Error;


/**
 * ...
 * @author P.J.Shand
 */
class Image extends DisplayObject
{
	@:isVar public var texture(default, set):AbstractTexture;
	@:isVar public var renderLayer(default, set):Int;
	@:isVar public var mask(default, set):Image;
	
	public function new(texture:AbstractTexture) 
	{
		super();
		displayType = DisplayType.IMAGE;
		
		this.texture = texture;
		
		renderLayer = 0;
	}
	
	inline function set_renderLayer(value:Int):Int 
	{
		if (renderLayer != value){
			displayData.renderLayer = renderLayer = value;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_mask(value:Image):Image 
	{
		if (mask != value) {
			mask = value;
			if (mask == null) {
				Fuse.current.workerSetup.removeMask(this);
			}
			else {
				Fuse.current.workerSetup.addMask(this, mask);
			}
		}
		return mask;
	}
	
	function set_texture(value:AbstractTexture):AbstractTexture 
	{
		if (value == null) return null;
		
		if (texture != value) {
			if (texture != null) texture.onUpdate.remove(OnTextureUpdate);
			texture = value;
			texture.onUpdate.add(OnTextureUpdate);
			OnTextureUpdate();
			displayData.textureId = texture.textureId;
			isStatic = 0;
		}
		return value;
	}
	
	function OnTextureUpdate() 
	{
		this.width = texture.width;
		this.height = texture.height;
	}
}