package fuse.texture;

#if html5
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

class DivTexture extends CanvasTexture {
	public var div(default, null):DivElement;

	var base64CssAssetBundler = new Base64CssAssetBundler();
	var tempAdd:Bool = false;

	public var divWidth:Int;
	public var divHeight:Int;

	var canvas:CanvasElement;
	var ctx:CanvasRenderingContext2D;
	var cssStr:String = "";
	var svg:SVGElement;

	public function new(div:DivElement = null) {
		if (div == null) {
			div = untyped js.Browser.document.createDivElement();
		}
		this.div = div;
		getSize();

		canvas = js.Browser.document.createCanvasElement();
		ctx = canvas.getContext2d();

		updateDivContent();

		super(canvas);
	}

	function updateDivContent() {
		canvas.width = divWidth;
		canvas.height = divHeight;

		base64CssAssetBundler.findCss(div, (cssStr:String) -> {
			this.cssStr = cssStr;
			createSvg();
		});
	}

	public function createSvg() {
		if (svg != null) {
			js.Browser.document.body.removeChild(svg);
		}

		svg = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");
		svg.setAttribute("width", Std.string(divWidth));
		svg.setAttribute("height", Std.string(divHeight));

		var style:StyleElement = js.Browser.document.createStyleElement();
		style.innerText = cssStr;
		svg.appendChild(style);

		var foreignObject:ForeignObjectElement = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", 'foreignObject');
		foreignObject.setAttribute("x", "0");
		foreignObject.setAttribute("y", "0");
		foreignObject.setAttribute("width", "100%");
		foreignObject.setAttribute("height", "100%");
		svg.appendChild(foreignObject);

		foreignObject.appendChild(div);

		var img = new Image();
		img.setAttribute("crossOrigin", "anonymous");

		img.onload = function() {
			ctx.drawImage(img, 0, 0);
			canvasTexture.update();
		}
		img.src = svg2img(svg);

		js.Browser.document.body.append(svg);
	}

	function getSize() {
		if (div.parentNode == null) {
			js.Browser.document.body.append(div);
			tempAdd = true;
		}
		divWidth = div.clientWidth;
		divHeight = div.clientHeight;
		if (tempAdd) {
			tempAdd = false;
			js.Browser.document.body.removeChild(div);
		}
	}

	function svg2img(svg) {
		var xml = new XMLSerializer().serializeToString(svg);
		var svg64 = null;
		try {
			svg64 = Browser.window.btoa(xml);
		} catch (e:Dynamic) {
			trace(e);
			return null;
		}

		var b64start = 'data:image/svg+xml;base64,';
		var image64 = b64start + svg64;
		return image64;
	}

	override public function update() {
		canvasTexture.update();
	}

	override public function dispose():Void {
		super.dispose();
	}
}
#end
