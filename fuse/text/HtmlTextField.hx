package fuse.text;

import js.html.svg.SVGElement;
import color.Color;
import fuse.display.Sprite;
import fuse.texture.CanvasTexture;
import fuse.utils.div.DivRenderer;
import fuse.display.Image;
import js.html.CanvasElement;
import js.html.DivElement;

/**
 * ...
 * @author P.J.Shand
 */
class HtmlTextField extends Sprite {
	var divRenderer:DivRenderer;

	// @:isVar var styleId(default, set):String = null;
	// @:isVar var css(default, set):Dynamic = null;
	public var divWidth(get, null):Int;
	public var divHeight(get, null):Int;
	public var textWidth(get, null):Int;
	public var textHeight(get, null):Int;
	@:isVar public var text(default, set):String = "";

	@:isVar public var offsetU(default, set):Float = 0;
	@:isVar public var offsetV(default, set):Float = 0;

	var div:DivElement;
	var canvasTexture:CanvasTexture;
	var image:Image;
	var textColor:Color = 0x00000000;

	public var canvas(get, null):CanvasElement;
	public var svg(get, null):SVGElement;

	public function new(?styleId:String = null, ?width:Null<Int>, ?height:Null<Int>, ?size:Null<Float>, ?color:Color, ?kerning:Null<Float>,
			?leading:Null<Float>, ?font:String, ?alignment:Null<TextFormatAlign>, ?css:Dynamic = null) {
		divRenderer = new DivRenderer(styleId, width, height, size, color, kerning, leading, font, alignment, css);
		divRenderer.onRender.add(onDivRendered);
		super();
	}

	function onDivRendered() {
		if (canvasTexture == null) {
			canvasTexture = new CanvasTexture(divRenderer.canvas);
			image = new Image(canvasTexture);
			addChild(image);
			this.width = canvasTexture.width;
			this.height = canvasTexture.height;
		} else {
			canvasTexture.update();
		}
		image.offsetV = offsetV;
		image.offsetU = offsetU;
		image.color = textColor;
	}

	function get_divWidth():Int {
		return divRenderer.width;
	}

	function get_divHeight():Int {
		return divRenderer.height;
	}

	function get_textWidth():Int {
		return divRenderer.textWidth;
	}

	function get_textHeight():Int {
		return divRenderer.textHeight;
	}

	function set_text(value:String):String {
		value = value.split("\n").join("<br/>");
		return divRenderer.text = value;
	}

	function get_canvas() {
		return divRenderer.canvas;
	}

	function get_svg() {
		return divRenderer.svg;
	}

	function set_offsetV(value:Float):Float {
		offsetV = value;
		if (image != null) {
			image.offsetV = offsetV;
		}
		return offsetV;
	}

	function set_offsetU(value:Float):Float {
		offsetU = value;
		if (image != null) {
			image.offsetU = offsetU;
		}
		return offsetU;
	}

	override function get_color():Color {
		return textColor;
	}

	override function set_color(value:Color):Color {
		textColor = value;
		if (image != null) {
			image.color = textColor;
		}
		return value;
	}
}
