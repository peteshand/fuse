package fuse.utils.css;

import js.html.XMLHttpRequestResponseType;
import js.html.FileReader;
import js.html.XMLHttpRequest;
import js.html.CSSStyleRule;
import js.html.DivElement;
import js.Browser;

class Base64CssAssetBundler {
	static var urls:Array<UrlData> = [];
	static var cssStr:String = "";
	static var allFontFaces:Array<CSSStyleRule> = [];

	public static function findCss(div:DivElement, callback:String->Void) {
		urls = [];

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
			for (urlData in urls) {
				cssStr = cssStr.split(urlData.token).join("url(" + urlData.base64 + ")");
			}
			callback(cssStr);
		});
	}

	static function findFontFaces() {
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

	static function findUrls(callback:Void->Void) {
		var r = ~/url\(.*?\)/g;
		var matchFound:Bool = r.match(cssStr);
		if (!matchFound)
			callback();
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

			var urlData:UrlData = {
				url: u2,
				token: "{{" + urls.length + "}}"
			}
			urls.push(urlData);

			toDataUrl(u2, (base64:String) -> {
				urlData.base64 = base64;
				cssStr = cssStr.split(u).join(urlData.token);
				findUrls(callback);
			});
		} catch (e:Dynamic) {
			trace(e);
			urlFound = false;
			callback();
		}
	}

	static function loadUrls(?index:Int = 0, callback:Void->Void) {
		if (index == urls.length) {
			callback();
		} else {
			toDataUrl(urls[index].url, (base64:String) -> {
				urls[index].base64 = base64;
				loadUrls(index + 1, callback);
			});
		}
	}

	static function toDataUrl(url:String, callback:Dynamic->Void) {
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
