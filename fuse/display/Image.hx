package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObject;
import fuse.display.Image;
import fuse.texture.ITexture;
import openfl.errors.Error;


/**
 * ...
 * @author P.J.Shand
 */
class Image extends DisplayObject
{
	@:isVar public var texture(default, set):ITexture;
	@:isVar public var renderLayer(default, set):Int;
	@:isVar public var mask(default, set):Image;
	
	public function new(texture:ITexture) 
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
	
	function set_texture(value:ITexture):ITexture 
	{
		if (value == null) {
			throw new Error("Texture can not be null");
		}
		
		if (texture != value) {
			texture = value;
			this.width = texture.width;
			this.height = texture.height;
			displayData.textureId = texture.textureId;
			isStatic = 0;
		}
		return value;
	}
}