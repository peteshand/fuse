package fuse.display;

import fuse.geom.Rectangle;
import fuse.shader.IShader;
import fuse.texture.ITexture;
import fuse.display.DisplayObject;
import fuse.core.front.texture.Textures;
import fuse.core.backend.displaylist.DisplayType;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture)
class Image extends DisplayObject
{
	@:isVar public var texture(default, set):ITexture;
	@:isVar public var renderLayer(default, set):Int;
	@:isVar public var blendMode(default, set):BlendMode;
	@:isVar public var bounds(get, never):Rectangle;
	var shaders:Array<IShader> = [];

	public function new(texture:ITexture) 
	{
		super();
		displayType = DisplayType.IMAGE;
		
		this.texture = texture;
		
		renderLayer = 0;
	}
	
	function get_bounds():Rectangle
	{
		if (Math.isNaN(displayData.bottomLeftX)) return null;

		var _bounds:Rectangle = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, 0, 0);
		var _bounds2:Rectangle = new Rectangle(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, 0, 0);

		if (_bounds.x > displayData.bottomLeftX) _bounds.x = displayData.bottomLeftX;
		if (_bounds.x > displayData.bottomRightX) _bounds.x = displayData.bottomRightX;
		if (_bounds.x > displayData.topLeftX) _bounds.x = displayData.topLeftX;
		if (_bounds.x > displayData.topRightX) _bounds.x = displayData.topRightX;
		
		if (_bounds2.x < displayData.bottomLeftX) _bounds2.x = displayData.bottomLeftX;
		if (_bounds2.x < displayData.bottomRightX) _bounds2.x = displayData.bottomRightX;
		if (_bounds2.x < displayData.topLeftX) _bounds2.x = displayData.topLeftX;
		if (_bounds2.x < displayData.topRightX) _bounds2.x = displayData.topRightX;
		
		if (_bounds.y > displayData.bottomLeftY) _bounds.y = displayData.bottomLeftY;
		if (_bounds.y > displayData.bottomRightY) _bounds.y = displayData.bottomRightY;
		if (_bounds.y > displayData.topLeftY) _bounds.y = displayData.topLeftY;
		if (_bounds.y > displayData.topRightY) _bounds.y = displayData.topRightY;
		
		if (_bounds2.y < displayData.bottomLeftY) _bounds2.y = displayData.bottomLeftY;
		if (_bounds2.y < displayData.bottomRightY) _bounds2.y = displayData.bottomRightY;
		if (_bounds2.y < displayData.topLeftY) _bounds2.y = displayData.topLeftY;
		if (_bounds2.y < displayData.topRightY) _bounds2.y = displayData.topRightY;
		
		_bounds.width = _bounds2.x - _bounds.x;
		_bounds.height = _bounds2.y - _bounds.y;
		
		_bounds.x = (_bounds.x + 1) * stage.stageWidth / 2;
		_bounds.y = ((_bounds.y + _bounds.height) - 1) * stage.stageHeight / 2;
		_bounds.width = _bounds.width * stage.stageWidth / 2;
		_bounds.height = _bounds.height * stage.stageHeight / 2;
		
		return _bounds;
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
	
	function set_texture(value:ITexture):ITexture 
	{
		if (value == null) value = Textures.blankTexture;
		if (texture != value) {
			if (texture != null) texture.removeChangeListener(this);
			texture = value;
			texture.addChangeListener(this);
			OnTextureUpdate();
			displayData.textureId = texture.objectId;
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

	override public function resetMovement() 
	{
		super.resetMovement();
		updateTexture = false;
	}
}