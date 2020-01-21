package fuse.utils.div;

import js.html.CSSStyleDeclaration;
import js.html.DOMRectList;
import fuse.text.TextFormatAlign;
import fuse.display.Sprite;
import js.html.DOMRect;
import haxe.Json;
import delay.Delay;
import fuse.utils.css.Base64CssAssetBundler;
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
import signals.Signal;

class DivRenderer {
	public var div(default, null):DivElement;
	public var textDiv(default, null):DivElement;

	var base64CssAssetBundler = new Base64CssAssetBundler();

	public var width(get, null):Null<Int> = null;
	public var height(get, null):Null<Int> = null;
	public var textWidth(get, null):Null<Int> = null;
	public var textHeight(get, null):Null<Int> = null;
	public var onRender = new Signal();

	public var canvas:CanvasElement;

	var styleId:String = null;
	var ctx:CanvasRenderingContext2D;
	var cssStr:String = null;

	public var svg:SVGElement;

	var foreignObject:ForeignObjectElement;
	var svgStyle:StyleElement;
	var textDivStyle:StyleElement;
	var img:Image;

	public var src(get, null):String;

	var count:Int = 0;
	var bounds:DOMRect;
	var textBounds:DOMRect;
	var image64:String;

	// static var currentlyLoading:Void->Void;
	// static var queue:Array<Void->Void> = [];
	@:isVar public var text(default, set):String = "";

	var index:Int;

	static var COUNT:Int = 0;

	public function new(?styleId:String = null, ?width:Null<Int>, ?height:Null<Int>, ?size:Null<Float>, ?color:Null<Color>, ?kerning:Null<Float>,
			?leading:Null<Float>, ?font:String, ?alignment:Null<TextFormatAlign>, ?css:Dynamic = null) {
		this.styleId = styleId;
		index = COUNT++;
		// trace(index);
		div = untyped js.Browser.document.createDivElement();
		textDiv = untyped js.Browser.document.createDivElement();
		div.appendChild(textDiv);

		// textDiv.style.verticalAlign = 'top';
		textDivStyle = js.Browser.document.createStyleElement();
		textDiv.appendChild(textDivStyle);
		// vertical-align: top;

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

		div.style.setProperty('display', "inline-block");

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

			foreignObject = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", 'foreignObject');
			foreignObject.setAttribute("x", "0");
			foreignObject.setAttribute("y", "0");
			foreignObject.setAttribute("width", "100%");
			foreignObject.setAttribute("height", "100%");
			svg.appendChild(foreignObject);

			foreignObject.appendChild(div);
		}

		canvas = js.Browser.document.createCanvasElement();

		ctx = canvas.getContext2d();
		// js.Browser.document.body.appendChild(svg);

		bundleCss();
	}

	function bundleCss() {
		base64CssAssetBundler.findCss(div, (cssStr:String) -> {
			this.cssStr = cssStr;
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
		if (text != value) {
			text = textDiv.innerHTML = value;
			if (textDiv.children.length > 0) {
				var cssText:String = "";
				for (child in textDiv.children) {
					cssText += child.style.cssText;
				}
				textDiv.style.cssText = cssText;
			}
			svg2img();
		}

		return text;
	}

	function getSize() {
		js.Browser.document.body.append(div);

		bounds = div.getBoundingClientRect();
		width = Math.ceil(bounds.width);
		height = Math.ceil(bounds.height);

		textBounds = textDiv.getBoundingClientRect();
		textWidth = Math.ceil(textBounds.width);
		textHeight = Math.ceil(textBounds.height);

		svg.setAttribute("width", Std.string(textWidth));
		svg.setAttribute("height", Std.string(textHeight));

		foreignObject.appendChild(div);
	}

	function svg2img() {
		updateSvgStyles();

		if (cssStr == null)
			return;

		getSize();

		var xml:String = new XMLSerializer().serializeToString(svg);
		var svg64 = null;
		try {
			svg64 = Base64.encode(Bytes.ofString(xml));
		} catch (e:Dynamic) {
			trace(e);
			return;
		}
		if (svg64 == null) {
			// currentlyLoading = null;
			// loadFromQueue();
			return;
		}
		image64 = 'data:image/svg+xml;base64,' + svg64;

		try {
			img.src = image64;
		} catch (e:Dynamic) {
			trace(e);
			// currentlyLoading = null;
			// loadFromQueue();
			return;
		}
	}

	function onImageLoadComplete() {
		canvas.width = textWidth;
		canvas.height = textHeight;

		if (ctx != null) {
			ctx = null;
		}
		ctx = canvas.getContext2d();
		ctx.clearRect(0, 0, canvas.width, canvas.height);

		ctx.drawImage(img, 0, 0);
		onRender.dispatch();

		// currentlyLoading = null;
		// loadFromQueue();
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
