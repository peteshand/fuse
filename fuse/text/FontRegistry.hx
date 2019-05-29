package fuse.text;

import fuse.text.BitmapFont;

class FontRegistry {
	// the name container with the registered bitmap fonts
	private static var BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";
	private static var bitmapFonts /*(get, null)*/:Map<String,
		BitmapFont> = new Map();

	// private static var fontFamilys = new Map<String, FontFamily>();

	/** Makes a bitmap font available at any TextField in the current stage3D context.
	 *  The font is identified by its <code>name</code> (not case sensitive).
	 *  Per default, the <code>name</code> property of the bitmap font will be used, but you
	 *  can pass a custom name, as well. @return the name of the font. */
	public static function registerBitmapFont(bitmapFont:BitmapFont, name:String = null /*, size:Null<Int>=null*/):String {
		if (name == null)
			name = bitmapFont.name + "_" + bitmapFont.size;
		name = name.toLowerCase();
		bitmapFonts[name.toLowerCase()] = bitmapFont;
		/*if (!fontFamilys.exists(name)) {
				fontFamilys[name] = new FontFamily();
			}
			fontFamilys[name].add(size, bitmapFont); */
		return name;
	}

	/** Unregisters the bitmap font and, optionally, disposes it. */
	public static function unregisterBitmapFont( /*size:Int, */ name:String, dispose:Bool = true):Void {
		name = name.toLowerCase();

		if (dispose && !bitmapFonts.exists(name)) {
			bitmapFonts[name].dispose();
			// fontFamilys[name].remove(size);
		}

		bitmapFonts.remove(name);
	}

	/** Returns a registered bitmap font (or null, if the font has not been registered). 
	 *  The name is not case sensitive. */
	public static function getBitmapFont(name:String):BitmapFont {
		if (name == null)
			return null;
		var font:BitmapFont = bitmapFonts.get(name);
		if (font == null)
			font = bitmapFonts.get(name.toLowerCase());
		return font;
	}

	public static function findBitmapName(name:String, size:Float):String {
		var name = name.toLowerCase();
		var bestFit:String = null;
		var bestDif:Float = 0;
		for (regName in bitmapFonts.keys()) {
			if (regName.indexOf(name + "_") != 0)
				continue;

			var bitmapFont = bitmapFonts.get(regName);
			var dif:Float = Math.abs(bitmapFont.size - size);
			if (bestFit == null || dif < bestDif) {
				bestDif = dif;
				bestFit = regName;
			}
		}
		return bestFit;
	}
}
