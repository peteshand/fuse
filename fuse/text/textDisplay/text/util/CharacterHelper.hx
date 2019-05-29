package fuse.text.textDisplay.text.util;

import fuse.text.FontRegistry;
import fuse.text.textDisplay.text.model.format.InputFormat;
import fuse.text.textDisplay.text.model.format.TextTransform;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.util.FormatParser.FormatNode;

/**
 * ...
 * @author P.J.Shand
 */
class CharacterHelper {
	public function new() {}

	inline static public function findCharFormat(textDisplay:TextDisplay, char:Char, nodes:Array<FormatNode>):Void {
		var format = char.format;
		format.clear();

		if (nodes.length > 0)
			applyFormats(format, char, nodes);

		updateCharFormat(format, char, textDisplay.formatModel.defaultFont);

		InputFormatHelper.copyMissingValues(format, textDisplay.defaultFormat);
	}

	inline static public function findBitmapChar(char:Char):Void {
		var charID:Int = char.id;
		if (char.format.textTransform == TextTransform.UPPERCASE) {
			charID = String.fromCharCode(charID).toUpperCase().charCodeAt(0);
		} else if (char.format.textTransform == TextTransform.LOWERCASE) {
			charID = String.fromCharCode(charID).toLowerCase().charCodeAt(0);
		}
		char.bitmapChar = char.font.getChar(charID);
	}

	inline static public function updateCharFormat(format:InputFormat, char:Char, defaultFont:BitmapFont):Void {
		char.format = format;
		if (format.face != null) {
			char.font = FontRegistry.getBitmapFont(format.face);
			if (char.font == null)
				char.font = FontRegistry.getBitmapFont(FontRegistry.findBitmapName(format.face, cast format.size));
		}
		if (char.font == null)
			char.font = defaultFont;
	}

	inline static private function applyFormats(format:InputFormat, char:Char, nodes:Array<FormatNode>) {
		for (j in 0...nodes.length) {
			if (char.index >= nodes[j].startIndex && char.index <= nodes[j].endIndex) {
				InputFormatHelper.copyActiveValues(format, nodes[j].format);
			}

			if (nodes[j].children.length > 0) {
				applyFormats(format, char, nodes[j].children);
			}
		}
	}
}
