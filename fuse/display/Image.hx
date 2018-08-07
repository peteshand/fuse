package fuse.display;

import fuse.shader.IShader;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.front.texture.Textures;
import fuse.display.DisplayObject;
import fuse.texture.AbstractTexture;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author P.J.Shand
 */
class Image extends DisplayObject
{
	@:isVar public var texture(default, set):AbstractTexture;
	@:isVar public var renderLayer(default, set):Int;
	@:isVar public var blendMode(default, set):BlendMode;
	var shaders:Array<IShader> = [];

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
			//isStatic = 0;
			//updateAll = true;
			updatePosition = true;
			updateRotation = true;
			updateStaticBackend();
		}
		return value;
	}
	
	override function set_mask(value:Image):Image 
	{
		if (this == value) return value;
		if (mask != value) {
			mask = value;
			if (mask == null) {
				Fuse.current.workerSetup.removeMask(this);
			}
			else {
				Fuse.current.workerSetup.addMask(this, this.displayType, mask, mask.displayType);
			}
		}
		return mask;
	}
	
	function set_texture(value:AbstractTexture):AbstractTexture 
	{
		if (value == null) value = untyped Textures.blankTexture;
		if (texture != value) {
			if (texture != null) texture.removeChangeListener(this);
			texture = value;
			texture.addChangeListener(this);
			OnTextureUpdate();
			displayData.textureId = texture.textureId;
			//isStatic = 0;
			updateTexture = true;
			//updateAll = true;
			updateStaticBackend();
		}
		return value;
	}
	
	function OnTextureUpdate() 
	{
		this.width = texture.width;
		this.height = texture.height;
		updateAlignment();
	}
	
	function set_blendMode(value:BlendMode):BlendMode 
	{
		if (blendMode != value) {
			displayData.blendMode = blendMode = value;
			//updateBlend = true; // new param needed?
			updateColour = true;
			updateStaticBackend();
		}
		return value;
	}

	public function addShader(shader:IShader):Void
	{
		shaders.push(shader);
		var shaderId:Int = 0;
		for (i in 0...shaders.length) {
			shaderId += shaders[i].objectId;
		}
		displayData.shaderId = shaderId;
	}
}