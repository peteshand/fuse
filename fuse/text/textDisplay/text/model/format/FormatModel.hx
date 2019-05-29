package fuse.text.textDisplay.text.model.format;

import fuse.text.FontRegistry;
import fuse.text.textDisplay.text.model.format.InputFormat;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.util.FormatParser.FormatNode;
import fuse.text.textDisplay.text.util.InputFormatHelper;
import fuse.text.MiniBitmapFont;

/**
 * ...
 * @author P.J.Shand
 */
class FormatModel {
	public static var baseDefaultFont:BitmapFont;

	private var textDisplay:TextDisplay;

	public var defaultFormat:InputFormat;
	public var defaultFont(get, null):BitmapFont;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;

		checkDefaultFont();

		var defaultColor:UInt = 0xFFFFFF;
		defaultFormat = new InputFormat(baseDefaultFont.name, 16, defaultColor);
	}

	static function checkDefaultFont() {
		if (baseDefaultFont == null) {
			baseDefaultFont = new BitmapFont(MiniBitmapFont.texture, MiniBitmapFont.xml);
			FontRegistry.registerBitmapFont(baseDefaultFont);
		}
	}

	public function setDefaults(format:InputFormat) {
		InputFormatHelper.copyActiveValues(defaultFormat, format);
	}

	function get_defaultFont():BitmapFont {
		var bitmapFont:BitmapFont = FontRegistry.getBitmapFont(defaultFormat.face);
		if (bitmapFont == null)
			bitmapFont = baseDefaultFont;
		return bitmapFont;
	}
}
