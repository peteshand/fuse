package fuse.text;

import fuse.utils.Align;
import delay.Delay;
import fuse.display.Quad;
import fuse.display.Image;
import fuse.display.Sprite;
import fuse.texture.DivTexture;
import js.html.DivElement;

/**
 * ...
 * @author P.J.Shand
 */
class HtmlTextField extends Sprite {
	@:isVar public var text(default, set):String = "";
	@:isVar public var styleId(default, set):String = "";
	@:isVar public var css(default, set):Dynamic;

	var texture:DivTexture;
	var div:DivElement;
	var image(get, null):Image;

	public function new(styleId:String = null, text:String = null) {
		super();
		div = untyped js.Browser.document.createDivElement();
		div.id = styleId;

		if (text != null) {
			this.text = text;
		}
	}

	function get_image():Image {
		if (image == null) {
			image = new Image(texture);
			addChild(image);
		}
		return image;
	}

	function set_text(value:String):String {
		if (text == value)
			return value;
		div.innerText = text = value;
		// Delay.killDelay(newTexture);
		// Delay.nextFrame(newTexture);
		newTexture();
		return text;
	}

	function set_styleId(value:String):String {
		if (styleId == value)
			return value;
		div.id = styleId = value;
		Delay.killDelay(newTexture);
		Delay.nextFrame(newTexture);
		return styleId;
	}

	function set_css(value:Dynamic):Dynamic {
		if (css == value)
			return value;
		css = value;
		for (field in Reflect.fields(css)) {
			var value = Reflect.getProperty(css, field);
			trace([field, value]);
			div.style.setProperty(field, value);
		}
		Delay.killDelay(newTexture);
		Delay.nextFrame(newTexture);
		return styleId;
	}

	function newTexture() {
		Delay.killDelay(newTexture);
		if (texture != null) {
			texture.dispose();
		}
		texture = new DivTexture(div);
		image.texture = texture;
	}

	override function get_width():Float {
		if (texture == null)
			return super.get_width();
		return texture.divWidth;
	}

	override function get_height():Float {
		if (texture == null)
			return super.get_height();
		return texture.divHeight;
	}

	override public function alignPivot(horizontalAlign:Align = Align.CENTER, verticalAlign:Align = Align.CENTER) {
		image.alignPivot(horizontalAlign, verticalAlign);
	}

	override public function alignPivotX(horizontalAlign:Align = Align.CENTER) {
		image.alignPivotX(horizontalAlign);
	}

	override public function alignPivotY(verticalAlign:Align = Align.CENTER) {
		image.alignPivotY(verticalAlign);
	}
}
