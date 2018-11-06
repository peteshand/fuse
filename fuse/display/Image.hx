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
	@:isVar public var blendMode(default, set):BlendMode;
	@:isVar public var bounds(get, never):Rectangle;
	@:isVar public var offsetU(default, set):Float;
	@:isVar public var offsetV(default, set):Float;
	@:isVar public var scaleU(default, set):Float;
	@:isVar public var scaleV(default, set):Float;

	var shaders:Array<IShader> = [];

	public function new(texture:ITexture) 
	{
		super();
		displayType = DisplayType.IMAGE;
		
		this.texture = texture;
		this.offsetU = 0;
		this.offsetV = 0;
		this.scaleU = 1;
		this.scaleV = 1;
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
		_bounds.y = ((_bounds.y + _bounds.height) - 1) * stage.stageHeight / -2;
		_bounds.width = _bounds.width * stage.stageWidth / 2;
		_bounds.height = _bounds.height * stage.stageHeight / 2;
		
		return _bounds;
	}

	function set_offsetU(value:Float):Float
	{
		if (offsetU != value){
			displayData.offsetU = offsetU = value;
			updateUVs = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_offsetV(value:Float):Float
	{
		if (offsetV != value){
			displayData.offsetV = offsetV = value;
			updateUVs = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleU(value:Float):Float
	{
		if (scaleU != value){
			displayData.scaleU = scaleU = value;
			updateUVs = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleV(value:Float):Float
	{
		if (scaleV != value){
			displayData.scaleV = scaleV = value;
			updateUVs = true;
			updateStaticBackend();
		}
		return value;
	}

	override function set_renderLayer(value:Null<Int>):Null<Int> 
	{
		if (renderLayer != value){
			displayData.renderLayer = renderLayer = value;
			updateVisible = true;
			updateStaticBackend();
			Fuse.current.workerSetup.visibleChange(this, this.visible);
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
			onTextureUpdate();
			displayData.textureId = texture.objectId;
			//isStatic = 0;
			updateTexture = true;
			//updateAll = true;
			updateStaticBackend();
		}
		return value;
	}
	
	function onTextureUpdate() 
	{
		if (width == 0) this.width = texture.width;
		if (height == 0) this.height = texture.height;
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
		if (shader == null) return;
		shaders.push(shader);
		updateShaderId();
	}

	public function removeShader(shader:IShader):Void
	{
		var index:Int = shaders.indexOf(shader);
		if (index != -1){
			shaders.splice(index, 1);
			updateShaderId();
		}
	}

	public function removeAllShader():Void
	{
		shaders = [];
		updateShaderId();
	}

	function updateShaderId()
	{
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

	public function clone()
	{
		var _clone = new Image(this.texture);
		_clone.renderLayer = this.renderLayer;
		_clone.blendMode = this.blendMode;
		_clone.name = this.name;
		_clone.x = this.x;
		_clone.y = this.y;
		_clone.width = this.width;
		_clone.height = this.height;
		_clone.pivotX = this.pivotX;
		_clone.pivotY = this.pivotY;
		_clone.rotation = this.rotation;
		_clone.scaleX = this.scaleX;
		_clone.scaleY = this.scaleY;
		_clone.color = this.color;
		_clone.colorTL = this.colorTL;
		_clone.colorTR = this.colorTR;
		_clone.colorBL = this.colorBL;
		_clone.colorBR = this.colorBR;
		_clone.alpha = this.alpha;
		_clone.visible = this.visible;
		_clone.mask = this.mask;
		return _clone;
	}
}