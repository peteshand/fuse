package fuse.utils.div;

import js.html.DOMRect;
import haxe.Json;
import delay.Delay;
import js.html.DivElement;
import fuse.utils.css.Base64CssAssetBundler;
import fuse.utils.div.DivRenderer;
import js.html.CanvasRenderingContext2D;
import js.html.StyleElement;
import js.html.XMLSerializer;
import js.html.svg.SVGElement;
import js.html.svg.ForeignObjectElement;
import js.html.Image;
import js.html.DivElement;
import js.html.CanvasElement;
import js.Browser;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import signals.Signal1;
import signals.Signal;
import notifier.utils.Persist;
import utils.Hash;
import notifier.Notifier;

class DivRenderer {
	// @:isVar public var text(default, set):String = null;
	// @:isVar public var styleId(default, set):String = null;
	// @:isVar public var css(default, set):Dynamic;
	var text:String = null;
	var styleId:String = null;
	var css:Dynamic;

	public var div(default, null):DivElement;
	public var textDiv(default, null):DivElement;

	var base64CssAssetBundler = new Base64CssAssetBundler();
	var tempAdd:Bool = false;

	public var width(get, null):Null<Int> = null;
	public var height(get, null):Null<Int> = null;
	public var textWidth(get, null):Null<Int> = null;
	public var textHeight(get, null):Null<Int> = null;
	// public var onBase64 = new Signal1<String>();
	public var onRender = new Signal();

	public var canvas:CanvasElement;

	var ctx:CanvasRenderingContext2D;
	var cssStr:String = "";
	var svg:SVGElement;
	var style:StyleElement;
	var img:Image;

	var cacheHash = new Notifier<Null<Float>>();
	var cachedData = new Notifier<String>();
	var cachedWidth = new Notifier<Int>();
	var cachedHeight = new Notifier<Int>();
	var cacheDate:Bool;

	public var src(get, null):String;

	var count:Int = 0;
	var bounds:DOMRect;
	var textBounds:DOMRect;

	public function new(styleId:String = null, text:String = "", css:Dynamic = null, cacheDate:Bool = false) {
		this.styleId = styleId;
		this.text = text;
		this.css = css;
		this.cacheDate = cacheDate;
		// if (div == null) {
		div = untyped js.Browser.document.createDivElement();
		textDiv = untyped js.Browser.document.createDivElement();
		div.appendChild(textDiv);
		// }

		img = new Image();
		img.setAttribute("crossOrigin", "anonymous");
		img.onload = onImageLoadComplete;

		/*if (base64 == null) {
				if (div != null) {
					loadFromDiv(div);
				}
			} else {
				loadFromData(base64);
		}*/

		// if (cacheDate) {
		//	cachedData.add(onBase64Set);
		// }
		// cacheHash.add(onCacheHashChange);

		// update();
		// }

		// function update() {
		// Delay.killDelay(update);

		div.id = styleId;
		for (field in Reflect.fields(css)) {
			var value = Reflect.getProperty(css, field);
			div.style.setProperty(field, value);
		}
		textDiv.innerHTML = text;

		// updateHash();
		// }

		// function updateHash() {
		var hashId:String = text + styleId;
		if (css != null)
			hashId += Json.stringify(css);
		cacheHash.value = Hash.compute(hashId);
		// }

		// function onCacheHashChange(hashId:Float) {
		if (text == null)
			return;

		/*if (cacheDate) {
			if (hashId != null) {
				Persist.register(cachedData, 'divData/' + hashId);
				Persist.register(cachedWidth, 'divData/' + hashId + "Width");
				Persist.register(cachedHeight, 'divData/' + hashId + "Height");
				canvas.width = width = cachedWidth.value;
				canvas.height = height = cachedHeight.value;
				cachedData.dispatch();
			} else {
				loadFromDiv(div);
			}
		} else {*/
		loadFromDiv(div);
		// }
	}

	/*function set_text(value:String):String {
			if (text == value)
				return value;
			text = value;
			update();
			return text;
		}

		function set_styleId(value:String):String {
			if (styleId == value)
				return value;
			styleId = value;
			Delay.killDelay(update);
			Delay.nextFrame(update);
			return styleId;
		}

		function set_css(value:Dynamic):Dynamic {
			if (css == value)
				return value;
			css = value;
			Delay.killDelay(update);
			Delay.nextFrame(update);
			return styleId;
	}*/
	/*function onBase64Set(base64:String) {
		if (base64 != null) {
			loadFromData(base64);
		} else {
			loadFromDiv(div);
		}
	}*/
	public function loadFromDiv(div:DivElement) {
		this.div = div;
		getSize();
		cachedWidth.value = width;
		cachedHeight.value = height;
		updateDivContent();
	}

	function updateDivContent() {
		base64CssAssetBundler.findCss(div, (cssStr:String) -> {
			this.cssStr = cssStr;
			createSvg();
		});
	}

	public function createSvg() {
		if (svg != null) {
			js.Browser.document.body.removeChild(svg);
		}

		if (svg == null) {
			svg = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");

			style = js.Browser.document.createStyleElement();
			svg.appendChild(style);

			var foreignObject:ForeignObjectElement = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", 'foreignObject');
			foreignObject.setAttribute("x", "0");
			foreignObject.setAttribute("y", "0");
			foreignObject.setAttribute("width", "100%");
			foreignObject.setAttribute("height", "100%");
			svg.appendChild(foreignObject);

			foreignObject.appendChild(div);
		}

		svg.setAttribute("width", Std.string(width));
		svg.setAttribute("height", Std.string(height));
		style.innerText = cssStr;

		loadFromData(svg2img(svg));

		// js.Browser.document.body.append(svg);
	}

	public function loadFromData(base64:String) {
		try {
			img.src = base64;
			cachedData.value = base64;
		} catch (e:Dynamic) {
			trace(e);
		}
	}

	function onImageLoadComplete() {
		canvas = js.Browser.document.createCanvasElement();
		canvas.width = textWidth;
		canvas.height = textHeight;
		ctx = canvas.getContext2d();
		// js.Browser.document.body.append(canvas);

		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.drawImage(img, 0, 0);
		onRender.dispatch();
	}

	function getSize() {
		if (div.parentNode == null) {
			js.Browser.document.body.append(div);
			tempAdd = true;
		}
		bounds = div.getBoundingClientRect();
		width = Math.floor(bounds.width);
		height = Math.floor(bounds.height);

		textBounds = textDiv.getBoundingClientRect();
		textWidth = Math.floor(textBounds.width);
		textHeight = Math.floor(textBounds.height);

		if (tempAdd) {
			tempAdd = false;
			js.Browser.document.body.removeChild(div);
		}
	}

	function svg2img(svg) {
		var xml:String = new XMLSerializer().serializeToString(svg);
		var svg64 = null;
		try {
			svg64 = Base64.encode(Bytes.ofString(xml));
		} catch (e:Dynamic) {
			trace(e);
			return null;
		}

		var b64start = 'data:image/svg+xml;base64,';
		var image64 = b64start + svg64;
		return image64;
	}

	function get_src():String {
		return img.src;
	}

	function get_width():Int {
		// if (width == null)
		// update();
		return width;
	}

	function get_height():Int {
		// if (height == null)
		// update();
		return height;
	}

	function get_textWidth():Int {
		return textWidth;
	}

	function get_textHeight():Int {
		return textHeight;
	}
}
