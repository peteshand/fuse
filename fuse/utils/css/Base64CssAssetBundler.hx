package fuse.utils.css;

import signals.Signal1;
import js.html.XMLHttpRequestResponseType;
import js.html.FileReader;
import js.html.XMLHttpRequest;
import js.html.CSSStyleRule;
import js.html.DivElement;
import js.Browser;

class Base64CssAssetBundler {
	// static var urls = new Map<String, UrlData>(); // :Array<UrlData> = [];
	// static var urls:Array<UrlData> = [];
	static var allFontFaces:Array<CSSStyleRule>;

	var cssStr:String;
	var loaders = new Map<String, Base64Loader>();
	var count:Int = 0;

	public function new() {}

	public function findCss(div:DivElement, callback:String->Void) {
		// urls = [];
		Base64Loader.COUNT = 0;
		cssStr = "";
		// urls = new Map<String, UrlData>();

		findFontFaces();

		var fontFacesToAdd = new Map<String, CSSStyleRule>();
		for (stylesheet in Browser.document.styleSheets) {
			var cssStyleRules:Array<CSSStyleRule> = untyped stylesheet.cssRules;
			for (cssStyleRule in cssStyleRules) {
				var apply:Bool = false;
				if (cssStyleRule.selectorText == null) {
					continue;
					// apply = true;
				} else if (cssStyleRule.selectorText.indexOf("#") == 0) {
					if (div.id == cssStyleRule.selectorText.substring(1, cssStyleRule.selectorText.length))
						apply = true;
				} else if (cssStyleRule.selectorText.indexOf(".") == 0) {
					if (div.className == cssStyleRule.selectorText.substring(1, cssStyleRule.selectorText.length))
						apply = true;
				} else {
					if (div.nodeName == cssStyleRule.selectorText)
						apply = true;
				}
				if (apply) {
					var fontFamily:String = cssStyleRule.style.getPropertyValue('font-family');
					if (fontFamily != null) {
						for (fontFace in allFontFaces) {
							var fontFaceFontFamily = fontFace.style.getPropertyValue('font-family');
							if (fontFaceFontFamily == fontFamily) {
								fontFacesToAdd.set(fontFaceFontFamily, fontFace);
							}
						}
					}

					cssStr += cssStyleRule.cssText;
				}
			}
		}

		for (fontFace in fontFacesToAdd.iterator()) {
			cssStr += fontFace.cssText;
		}

		cssStr = cssStr.split("\n").join(" ");

		findUrls(() -> {
			for (loader in loaders.iterator()) {
				cssStr = cssStr.split(loader.token).join("url(" + loader.base64 + ")");
			}
			callback(cssStr);
		});
	}

	function findFontFaces() {
		if (allFontFaces != null)
			return;
		allFontFaces = [];

		for (stylesheet in Browser.document.styleSheets) {
			var cssStyleRules:Array<CSSStyleRule> = untyped stylesheet.cssRules;
			for (cssStyleRule in cssStyleRules) {
				if (cssStyleRule.selectorText == null) {
					if (cssStyleRule.cssText.indexOf("@font-face") != -1) {
						allFontFaces.push(cssStyleRule);
					}
				}
			}
		}
	}

	function findUrls(callback:Void->Void) {
		var r = ~/url\(.*?\)/g;
		var matchFound:Bool = r.match(cssStr);
		if (!matchFound) {
			callback();
			return;
		}

		var urlFound = true;
		var index:Int = 0;
		try {
			var u:String = r.matched(index++);
			var c:String = "(";
			if (u.indexOf("'") != -1) {
				c = "'";
			} else if (u.indexOf('"') != -1) {
				c = '"';
			}
			var split:Array<String> = u.split(c);
			var u2:String = split[1];
			if (c == "(") {
				u2 = u2.split(")")[0];
			}

			var loader:Base64Loader = getLoader(u2);
			loader.load((base64:String) -> {
				cssStr = cssStr.split(u).join(loader.token);
				findUrls(callback);
			});
		} catch (e:Dynamic) {
			// trace(e);
			urlFound = false;
			callback();
		}
	}

	function mapLength(map:Map<Dynamic, Dynamic>):Int {
		var count:Int = 0;
		for (key in map.keys()) {
			count++;
		}
		return count;
	}

	function getLoader(url:String):Base64Loader {
		var loader:Base64Loader = loaders.get(url);
		if (loader == null) {
			loader = new Base64Loader(url);
			loaders.set(url, loader);
		}
		return loader;
	}
}

class Base64Loader {
	var onload = new Signal1();

	public var base64:String;
	public var url:String;
	public var token:String;

	public static var COUNT:Int = 0;

	public function new(url:String) {
		this.url = url;
		token = "{{" + COUNT++ + "}}";

		toDataUrl(url, (base64:String) -> {
			this.base64 = base64;
			onload.dispatch(base64);
		});
	}

	public function load(callback:String->Void) {
		if (base64 == null) {
			onload.add(callback);
		} else {
			callback(base64);
		}
	}

	function toDataUrl(url:String, callback:Dynamic->Void) {
		var xhr = new XMLHttpRequest();
		xhr.onload = function() {
			var reader = new FileReader();
			reader.onloadend = function() {
				callback(reader.result);
			}
			reader.readAsDataURL(xhr.response);
		};
		xhr.onerror = function() {
			trace("Error loading " + url);
			callback(url);
		}
		xhr.open('GET', url);
		xhr.responseType = XMLHttpRequestResponseType.BLOB; // 'blob'; // XMLHttpRequestResponseType

		xhr.send();
	}
}

typedef UrlData = {
	url:String,
	token:String,
	?base64:String
}
