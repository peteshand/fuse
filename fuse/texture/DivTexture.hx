package fuse.texture;

import js.node.Fs;
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
	var base64CssAssetBundler = new Base64CssAssetBundler();
	var div:DivElement;
	var tempAdd:Bool = false;
	var divWidth:Int;
	var divHeight:Int;
	var canvas:CanvasElement;
	var ctx:CanvasRenderingContext2D;
	var cssStr:String = "";
	var pathToSave:String = "";

	public function new(div:DivElement, pathToSave:String = null, create:Bool = true) {
		this.div = div;
		getSize();
		canvas = js.Browser.document.createCanvasElement();
		canvas.width = divWidth;
		canvas.height = divHeight;
		ctx = canvas.getContext2d();
		if (create == true) {
			this.pathToSave = pathToSave;
			base64CssAssetBundler.findCss(div, (cssStr:String) -> {
				this.cssStr = cssStr;
				createSvg();
			});
		}
		super(canvas);
	}

	public function loadFromData(data:String) {
		var img = new Image();
		img.setAttribute("crossOrigin", "anonymous");
		img.onload = function() {
			ctx.drawImage(img, 0, 0);
			canvasTexture.update();
		};
		img.src = data;
	}

	public function createSvg() {
		var svg:SVGElement = untyped js.Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");
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

		if (pathToSave != null)
			Fs.writeFile(pathToSave, img.src, fileWriteResult);
	}

	function fileWriteResult(err:Dynamic) {
		trace("error writing file " + err);
	}

	function getSize() {
		if (div.parentNode == null) {
			js.Browser.document.body.append(div);
			tempAdd = true;
		}
		divWidth = div.clientWidth;
		divHeight = div.clientHeight;
		if (tempAdd) {
			js.Browser.document.body.removeChild(div);
		}
	}

	function svg2img(svg) {
		var xml = new XMLSerializer().serializeToString(svg);
		var svg64 = Browser.window.btoa(xml);
		var b64start = 'data:image/svg+xml;base64,';
		var image64 = b64start + svg64;
		return image64;
	}
}
#end
