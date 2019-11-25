package fuse.text;

import fuse.display.Sprite;
import fuse.texture.CanvasTexture;
import fuse.utils.div.DivRenderer;
import fuse.core.front.texture.Textures;
import fuse.display.Image;
import js.html.DivElement;
import notifier.utils.Persist;
import utils.Hash;
import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class HtmlTextField extends Sprite {
	var divRenderer:DivRenderer;

	// @:isVar var text(default, set):String = "";
	// @:isVar var styleId(default, set):String = null;
	// @:isVar var css(default, set):Dynamic = null;
	public var divWidth(get, null):Int;
	public var divHeight(get, null):Int;
	public var textWidth(get, null):Int;
	public var textHeight(get, null):Int;

	var div:DivElement;
	var canvasTexture:CanvasTexture;

	public function new(styleId:String = null, text:String = "", css:Dynamic = null, cacheDate:Bool = false) {
		divRenderer = new DivRenderer(styleId, text, css, cacheDate);
		divRenderer.onRender.add(onDivRendered);
		super();
	}

	function onDivRendered() {
		canvasTexture = new CanvasTexture(divRenderer.canvas);
		var image = new Image(canvasTexture);
		addChild(image);
		this.width = canvasTexture.width;
		this.height = canvasTexture.height;
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
}
