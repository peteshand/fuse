package fuse.text;

import fuse.geom.Rectangle;
import fuse.text.FontRegistry;
import fuse.texture.BaseTexture;
import openfl.display.BitmapData;

class BitmapFont {
	var texture:BaseTexture;
	private var __chars:Map<Int, BitmapChar>;
	private var __name:String;
	private var __size:Float;
	private var __lineHeight:Float;
	private var __baseline:Float;
	private var __offsetX:Float;
	private var __offsetY:Float;
	private var __padding:Float;
	// private var __helperImage:Image;
	private var __type:String;
	private var __distanceFieldSpread:Float;

	public function new(texture:BaseTexture, ?fontData:String, ?fontXml:Xml) {
		__chars = new Map<Int, BitmapChar>();

		this.texture = texture;
		parseFontData(fontData, fontXml);

		FontRegistry.registerBitmapFont(this);
	}

	/** Disposes the texture of the bitmap font! */
	public function dispose():Void {
		if (texture != null)
			texture.dispose();
	}

	private function parseFontData(?fontData:String, ?fontXml:Xml):Void {
		if (fontData != null) {
			fontXml = Xml.parse(fontData).firstElement();
		}
		parseFontXml(fontXml);
	}

	private function parseFontXml(fontXml:Xml):Void {
		var scale:Float = 1; // __texture.scale;
		var frame:Rectangle = null; // __texture.frame;
		var frameX:Float = frame != null ? frame.x : 0;
		var frameY:Float = frame != null ? frame.y : 0;

		var info:Xml = fontXml.elementsNamed("info").next();
		if (info == null) {
			fontXml = fontXml.firstElement();
			info = fontXml.elementsNamed("info").next();
		}

		var common:Xml = fontXml.elementsNamed("common").next();
		__name = info.get("face");
		__size = Std.parseFloat(info.get("size")) / scale;
		__lineHeight = Std.parseFloat(common.get("lineHeight")) / scale;
		__baseline = Std.parseFloat(common.get("base")) / scale;

		if (info.get("smooth") == "0")
			// smoothing = TextureSmoothing.NONE;

			if (__size <= 0) {
				trace("[Starling] Warning: invalid font size in '" + __name + "' font.");
				__size = (__size == 0.0 ? 16.0 : __size * -1.0);
			}

		var distanceField:Xml = fontXml.elementsNamed("distanceField").next();
		if (distanceField != null && distanceField.exists("distanceRange") && distanceField.exists("fieldType")) {
			__distanceFieldSpread = Std.parseFloat(distanceField.get("distanceRange"));
			// __type = distanceField.get("fieldType") == "msdf" ? BitmapFontType.MULTI_CHANNEL_DISTANCE_FIELD : BitmapFontType.DISTANCE_FIELD;
		} else {
			__distanceFieldSpread = 0.0;
			// __type = BitmapFontType.STANDARD;
		}

		var chars:Xml = fontXml.elementsNamed("chars").next();
		for (charElement in chars.elementsNamed("char")) {
			var id:Int = Std.parseInt(charElement.get("id"));
			var xOffset:Float = Std.parseFloat(charElement.get("xoffset")) / scale;
			var yOffset:Float = Std.parseFloat(charElement.get("yoffset")) / scale;
			var xAdvance:Float = Std.parseFloat(charElement.get("xadvance")) / scale;

			var region:Rectangle = new Rectangle();
			region.x = Std.parseFloat(charElement.get("x")) / scale + frameX;
			region.y = Std.parseFloat(charElement.get("y")) / scale + frameY;
			region.width = Std.parseFloat(charElement.get("width")) / scale;
			region.height = Std.parseFloat(charElement.get("height")) / scale;

			var bitmapChar:BitmapChar = new BitmapChar(id, texture, region, xOffset, yOffset, xAdvance);
			addChar(id, bitmapChar);
		}

		if (fontXml.exists("kernings")) {
			var kernings:Xml = fontXml.elementsNamed("kernings").next();
			for (kerningElement in kernings.elementsNamed("kerning")) {
				var first:Int = Std.parseInt(kerningElement.get("first"));
				var second:Int = Std.parseInt(kerningElement.get("second"));
				var amount:Float = Std.parseFloat(kerningElement.get("amount")) / scale;
				if (__chars.exists(second))
					getChar(second).addKerning(first, amount);
			}
		}
	}

	public function addChar(charID:Int, bitmapChar:BitmapChar):Void {
		__chars.set(charID, bitmapChar);
	}

	public function getChar(charID:Int):BitmapChar {
		return __chars.get(charID);
	}

	/** The name of the font as it was parsed from the font file. */
	public var name(get, never):String;

	private function get_name():String {
		return __name;
	}

	/** The native size of the font. */
	public var size(get, never):Float;

	private function get_size():Float {
		return __size;
	}

	/** The type of the bitmap font. @see starling.text.BitmapFontType @default standard */
	public var type(get, set):String;

	public function get_type():String {
		return __type;
	}

	public function set_type(value:String):String {
		return __type = value;
	}

	/** If the font uses a distance field texture, this property returns its spread (i.e.
	 *  the width of the blurred edge in points). */
	public var distanceFieldSpread(get, set):Float;

	public function get_distanceFieldSpread():Float {
		return __distanceFieldSpread;
	}

	public function set_distanceFieldSpread(value:Float):Float {
		return __distanceFieldSpread = value;
	}

	/** The height of one line in points. */
	public var lineHeight(get, never):Float;

	private function get_lineHeight():Float {
		return __lineHeight;
	}

	private function set_lineHeight(value:Float):Void {
		__lineHeight = value;
	}

	/** The smoothing filter that is used for the texture. */
	public var smoothing(get, set):String;

	private function get_smoothing():String {
		return ""; // __helperImage.textureSmoothing;
	}

	private function set_smoothing(value:String):String {
		// return __helperImage.textureSmoothing = value;
		return value;
	}

	/** The baseline of the font. This property does not affect text rendering;
	 * it's just an information that may be useful for exact text placement. */
	public var baseline(get, set):Float;

	private function get_baseline():Float {
		return __baseline;
	}

	private function set_baseline(value:Float):Float {
		return __baseline = value;
	}

	/** An offset that moves any generated text along the x-axis (in points).
	 * Useful to make up for incorrect font data. @default 0. */
	public var offsetX(get, set):Float;

	private function get_offsetX():Float {
		return __offsetX;
	}

	private function set_offsetX(value:Float):Float {
		return __offsetX = value;
	}

	/** An offset that moves any generated text along the y-axis (in points).
	 * Useful to make up for incorrect font data. @default 0. */
	public var offsetY(get, set):Float;

	private function get_offsetY():Float {
		return __offsetY;
	}

	private function set_offsetY(value:Float):Float {
		return __offsetY = value;
	}

	/** The width of a "gutter" around the composed text area, in points.
	 *  This can be used to bring the output more in line with standard TrueType rendering:
	 *  Flash always draws them with 2 pixels of padding. @default 0.0 */
	public var padding(get, set):Float;

	private function get_padding():Float {
		return __padding;
	}

	private function set_padding(value:Float):Float {
		return __padding = value;
	}

	/** The underlying texture that contains all the chars. */
	private function get_texture():BaseTexture {
		return texture;
	}
}
