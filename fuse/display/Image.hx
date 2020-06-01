package fuse.display;

import fuse.texture.RenderTexture;
import fuse.geom.Rectangle;
import fuse.shader.IShader;
import fuse.texture.ITexture;
import fuse.display.DisplayObject;
import fuse.core.front.texture.Textures;
import fuse.core.backend.displaylist.DisplayType;
import fuse.utils.Orientation;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture)
class Image extends DisplayObject {
	@:isVar public var texture(default, set):ITexture;
	@:isVar public var blendMode(default, set):BlendMode;
	@:isVar public var offsetU(default, set):Float;
	@:isVar public var offsetV(default, set):Float;
	@:isVar public var scaleU(default, set):Float;
	@:isVar public var scaleV(default, set):Float;
	@:isVar public var edgeAA(default, set):Bool;
	@:isVar public var renderTarget(default, set):RenderTexture;

	var shaders:Array<IShader> = [];

	public function new(texture:ITexture) {
		super();
		displayType = DisplayType.IMAGE;

		this.texture = texture;
		this.offsetU = 0;
		this.offsetV = 0;
		this.scaleU = 1;
		this.scaleV = 1;
	}

	override function get_bounds():Rectangle {
		if (Math.isNaN(displayData.bottomLeftX))
			return null;

		var low:Rectangle = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, 0, 0);
		var high:Rectangle = new Rectangle(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, 0, 0);

		if (low.x > displayData.bottomLeftX)
			low.x = displayData.bottomLeftX;
		if (low.x > displayData.bottomRightX)
			low.x = displayData.bottomRightX;
		if (low.x > displayData.topLeftX)
			low.x = displayData.topLeftX;
		if (low.x > displayData.topRightX)
			low.x = displayData.topRightX;

		if (high.x < displayData.bottomLeftX)
			high.x = displayData.bottomLeftX;
		if (high.x < displayData.bottomRightX)
			high.x = displayData.bottomRightX;
		if (high.x < displayData.topLeftX)
			high.x = displayData.topLeftX;
		if (high.x < displayData.topRightX)
			high.x = displayData.topRightX;

		if (low.y > displayData.bottomLeftY)
			low.y = displayData.bottomLeftY;
		if (low.y > displayData.bottomRightY)
			low.y = displayData.bottomRightY;
		if (low.y > displayData.topLeftY)
			low.y = displayData.topLeftY;
		if (low.y > displayData.topRightY)
			low.y = displayData.topRightY;

		if (high.y < displayData.bottomLeftY)
			high.y = displayData.bottomLeftY;
		if (high.y < displayData.bottomRightY)
			high.y = displayData.bottomRightY;
		if (high.y < displayData.topLeftY)
			high.y = displayData.topLeftY;
		if (high.y < displayData.topRightY)
			high.y = displayData.topRightY;

		bounds.x = low.x;
		bounds.y = high.y;
		bounds.width = high.x - low.x;
		bounds.height = high.y - low.y;

		var _x:Float = (bounds.x + 1) * stage.stageWidth / 2;
		var _y:Float = (bounds.y - 1) * stage.stageHeight / -2;
		var _width:Float = bounds.width * stage.stageWidth / 2;
		var _height:Float = bounds.height * stage.stageHeight / 2;

		var ratio:Float = stage.windowWidth / stage.windowHeight;
		switch stage.orientation {
			case Orientation.LANDSCAPE:
				bounds.x = _x;
				bounds.y = _y;
				bounds.width = _width;
				bounds.height = _height;
			case Orientation.LANDSCAPE_FLIPPED:
				bounds.x = stage.windowWidth - _x - _width;
				bounds.y = stage.windowHeight - _y - _height;
				bounds.width = _width;
				bounds.height = _height;
			case Orientation.PORTRAIT:
				bounds.x = stage.windowHeight - ((_height + _y) / ratio);
				bounds.y = (_x * ratio);
				bounds.width = _height;
				bounds.height = _width;
			case Orientation.PORTRAIT_FLIPPED:
				bounds.x = (_y / ratio);
				bounds.y = stage.windowWidth - ((_width + _x) * ratio);
				bounds.width = _height;
				bounds.height = _width;
		}
		return bounds;
	}

	function set_offsetU(value:Float):Float {
		if (offsetU != value) {
			displayData.offsetU = offsetU = value;
			updateUVs = true;
			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_offsetV(value:Float):Float {
		if (offsetV != value) {
			displayData.offsetV = offsetV = value;
			updateUVs = true;
			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleU(value:Float):Float {
		if (scaleU != value) {
			displayData.scaleU = scaleU = value;
			updateUVs = true;
			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleV(value:Float):Float {
		if (scaleV != value) {
			displayData.scaleV = scaleV = value;
			updateUVs = true;
			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_edgeAA(value:Bool):Bool {
		if (edgeAA != value) {
			edgeAA = value;
			if (value == true) {
				displayData.edgeAA = 1;
			} else {
				displayData.edgeAA = 0;
			}

			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	function set_renderTarget(value:RenderTexture):RenderTexture {
		if (renderTarget != value) {
			renderTarget = value;
			displayData.renderTargetId = renderTarget.objectId;
			updatePosition = true;
			updateStaticBackend();
		}
		return value;
	}

	override function set_renderLayer(value:Null<Int>):Null<Int> {
		// if (renderLayer != value) {
		displayData.renderLayer = renderLayer = value;
		updateVisible = true;
		Fuse.current.workerSetup.setRenderLayer(this, renderLayer);
		Fuse.current.workerSetup.visibleChange(this, this.visible);
		updateStaticBackend();

		// }
		return value;
	}

	override function set_mask(value:Image):Image {
		if (this == value)
			return value;
		if (mask != value) {
			mask = value;
			if (mask == null) {
				Fuse.current.workerSetup.removeMask(this);
			} else {
				Fuse.current.workerSetup.addMask(this, this.displayType, mask, mask.displayType);
			}
		}
		return mask;
	}

	function set_texture(value:ITexture):ITexture {
		if (value == null)
			value = Textures.blankTexture;
		if (texture != value) {
			if (texture != null)
				texture.removeChangeListener(this);
			texture = value;
			texture.addChangeListener(this);
			onTextureUpdate();
			displayData.textureId = texture.objectId;
			// isStatic = 0;
			updateTexture = true;
			// updateAll = true;
			updateStaticBackend();
		}
		return value;
	}

	function onTextureUpdate() {
		if (width == 0)
			this.width = texture.width;
		if (height == 0)
			this.height = texture.height;
		updateAlignment();
	}

	function set_blendMode(value:BlendMode):BlendMode {
		if (blendMode != value) {
			displayData.blendMode = blendMode = value;
			// updateBlend = true; // new param needed?
			updateColour = true;
			updateStaticBackend();
		}
		return value;
	}

	public function addShader(shader:IShader):Void {
		if (shader == null)
			return;
		shader.onUpdate.add(onShaderChange);
		shaders.push(shader);
		updateShaderId();
	}

	public function removeShader(shader:IShader):Void {
		var index:Int = shaders.indexOf(shader);
		if (index != -1) {
			shader.onUpdate.remove(onShaderChange);
			shaders.splice(index, 1);
			updateShaderId();
		}
	}

	function onShaderChange() {
		updateColour = true;
		updateStaticBackend();
	}

	public function removeAllShader():Void {
		shaders = [];
		updateShaderId();
	}

	function updateShaderId() {
		var shaderId:Int = 0;
		for (i in 0...shaders.length) {
			shaderId += shaders[i].objectId;
		}
		displayData.shaderId = shaderId;
	}

	override public function resetMovement() {
		super.resetMovement();
		updateTexture = false;
	}

	public function clone() {
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
