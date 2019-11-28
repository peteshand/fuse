package fuse.utils.div;

import js.html.Element;
import fuse.text.TextFormatAlign;
import fuse.display.Sprite;
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
	public var div(default, null):DivElement;
	public var textDiv(default, null):DivElement;

	var base64CssAssetBundler = new Base64CssAssetBundler();
	var tempAdd:Bool = false;

	public var width(get, null):Null<Int> = null;
	public var height(get, null):Null<Int> = null;
	public var textWidth(get, null):Null<Int> = null;
	public var textHeight(get, null):Null<Int> = null;
	public var onCssReady = new Signal();
	public var onRender = new Signal();

	public var canvas:CanvasElement;

	var styleId:String = null;
	var ctx:CanvasRenderingContext2D;
	var cssStr:String = "";
	var svg:SVGElement;
	var svgStyle:StyleElement;
	var img:Image;

	public var src(get, null):String;

	var count:Int = 0;
	var bounds:DOMRect;
	var textBounds:DOMRect;
	var image64:String;

	@:isVar public var text(default, set):String = "";

	public function new(?styleId:String = null, ?width:Null<Int>, ?height:Null<Int>, ?size:Null<Float>, ?color:Null<Color>, ?kerning:Null<Float>,
			?leading:Null<Float>, ?font:String, ?alignment:Null<TextFormatAlign>, ?css:Dynamic = null) {
		this.styleId = styleId;

		div = untyped js.Browser.document.createDivElement();
		textDiv = untyped js.Browser.document.createDivElement();
		div.appendChild(textDiv);

		img = new Image();
		img.setAttribute("crossOrigin", "anonymous");
		img.onload = onImageLoadComplete;

		div.id = styleId;
		for (field in Reflect.fields(css)) {
			var value = Reflect.getProperty(css, field);
			div.style.setProperty(field, value);
		}

		if (width != null)
			div.style.setProperty('width', width + 'px');
		if (height != null)
			div.style.setProperty('height', height + 'px');
		if (color != null)
			div.style.setProperty('color', '#' + StringTools.hex(color, 6));
		if (size != null)
			div.style.setProperty('font-size', size + "px");

		if (font != null && alignment == null) {
			if (font == TextFormatAlign.CENTER || font == TextFormatAlign.END || font == TextFormatAlign.JUSTIFY || font == TextFormatAlign.LEFT
				|| font == TextFormatAlign.RIGHT || font == TextFormatAlign.START) {
				alignment = font;
				font = null;
			}
		}
		if (font != null)
			div.style.setProperty('font-family', font);
		if (alignment != null)
			div.style.setProperty('text-align', alignment);
		if (kerning != null)
			div.style.setProperty('letter-spacing', kerning + "px");
		if (leading != null)
			div.style.setProperty('line-height', leading + "px");

		var hashId:String = /*text +*/ styleId;
		if (css != null)
			hashId += Json.stringify(css);

		if (svg != null) {
			js.Browser.document.body.removeChild(svg);
		}

		if (svg == null) {
			svg = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");

			svgStyle = js.Browser.document.createStyleElement();
			svg.appendChild(svgStyle);

			var foreignObject:ForeignObjectElement = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", 'foreignObject');
			foreignObject.setAttribute("x", "0");
			foreignObject.setAttribute("y", "0");
			foreignObject.setAttribute("width", "100%");
			foreignObject.setAttribute("height", "100%");
			svg.appendChild(foreignObject);

			foreignObject.appendChild(div);
		}

		canvas = js.Browser.document.createCanvasElement();

		ctx = canvas.getContext2d();
		js.Browser.document.body.appendChild(svg);

		bundleCss();
	}

	function bundleCss() {
		base64CssAssetBundler.findCss(div, (cssStr:String) -> {
			this.cssStr = cssStr;
			updateSvgStyles();
			onCssReady.dispatch();
		});
	}

	function updateSvgStyles() {
		if (textDiv.innerHTML != "") {
			base64CssAssetBundler.findCss(textDiv, (innerCssStr:String) -> {
				svgStyle.innerText = cssStr + innerCssStr;
			});
		} else {
			svgStyle.innerText = cssStr;
		}
	}

	function set_text(value:String):String {
		text = textDiv.innerHTML = value;
		updateSvgStyles();

		if (cssStr == null)
			return value;
		getSize();

		svg2img();
		loadBase64();

		return text;
	}

	function getSize() {
		if (svg.parentNode == null) {
			js.Browser.document.body.append(svg);
			tempAdd = true;
		}
		bounds = div.getBoundingClientRect();
		width = Math.floor(bounds.width);
		height = Math.floor(bounds.height);

		textBounds = textDiv.getBoundingClientRect();
		textWidth = Math.floor(textBounds.width);
		textHeight = Math.floor(textBounds.height);

		svg.setAttribute("width", Std.string(width));
		svg.setAttribute("height", Std.string(height));

		if (tempAdd) {
			tempAdd = false;
			js.Browser.document.body.removeChild(svg);
		}
	}

	function svg2img() {
		var xml:String = new XMLSerializer().serializeToString(svg);
		var svg64 = null;
		try {
			svg64 = Base64.encode(Bytes.ofString(xml));
		} catch (e:Dynamic) {
			trace(e);
			return;
		}
		image64 = 'data:image/svg+xml;base64,' + svg64;
	}

	function loadBase64() {
		try {
			img.src = image64;
			// cachedData.value = image64;
		} catch (e:Dynamic) {
			trace(e);
		}
	}

	function onImageLoadComplete() {
		canvas.width = textWidth;
		canvas.height = textHeight;
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.drawImage(img, 0, 0);
		onRender.dispatch();
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
