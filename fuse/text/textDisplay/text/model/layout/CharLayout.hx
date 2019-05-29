package fuse.text.textDisplay.text.model.layout;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import fuse.text.BitmapFont;
import fuse.text.textDisplay.text.model.format.InputFormat;
import fuse.text.textDisplay.text.model.format.TextWrapping;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.model.layout.Line;
import fuse.text.textDisplay.text.model.selection.Selection;
import fuse.text.textDisplay.text.model.layout.Word;
import fuse.display.Quad;
import fuse.text.BitmapChar;
import fuse.text.textDisplay.text.TextDisplay;
import fuse.text.textDisplay.text.util.CharacterHelper;
import fuse.text.textDisplay.utils.SpecialChar;
import fuse.text.textDisplay.utils.On;
import fuse.text.textDisplay.text.TextFieldAutoSize;
import fuse.utils.Align;

/**
 * ...
 * @author P.J.Shand
 */
class CharLayout {
	public var layoutChanged:On = new On();
	public var boundsChanged:On = new On();

	var lineNumber:Int;
	var placementX:Float;
	var placementY:Float;
	var words:Array<Word>;
	var charLinePositionX:Int;
	var textDisplay:TextDisplay;
	var _endChar:EndChar;
	var endChar(get, null):EndChar;
	var wordBreakFound:Bool;
	var limitReached:Bool;
	var defaultChar:Char;

	@:isVar public var snapCharsTo(default, set):Float = 0;

	function set_snapCharsTo(value:Float):Float {
		if (this.snapCharsTo == value)
			return value;
		this.snapCharsTo = value;
		textDisplay.markForUpdate();
		return value;
	}

	public var characters:Array<Char>;
	public var allCharacters:Array<Char>;
	public var lines = new Array<Line>();

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;

		_endChar = new EndChar("", 0, textDisplay);
		_endChar.isEndChar = true;
		allCharacters = [_endChar];

		defaultChar = new Char(null, 0);

		textDisplay.contentModel.charactersChanged.add(onCharsChanged);

		characters = textDisplay.contentModel.characters;
		onCharsChanged();
	}

	function onCharsChanged() {
		characters = textDisplay.contentModel.characters;
		allCharacters = characters.concat([_endChar]);
	}

	public function doProcess() {
		var oldTextX:Float = textDisplay._textBounds.x;
		var oldTextY:Float = textDisplay._textBounds.y;
		var oldTextW:Float = textDisplay._textBounds.width;
		var oldTextH:Float = textDisplay._textBounds.height;

		CharacterHelper.updateCharFormat(textDisplay.defaultFormat, defaultChar, textDisplay.formatModel.defaultFont);
		setPlacementX();
		findWords();
		findLineHeight();
		setLinePositions();

		calcTextSize();
		align();

		checkChange(oldTextX, oldTextY, oldTextW, oldTextH);
	}

	public function getChar(index:Int):Char {
		if (index >= characters.length)
			return null;
		return characters[index];
	}

	public function getCharOrEnd(index:Int):Char {
		if (index >= characters.length)
			return endChar;
		return characters[index];
	}

	public function getWordByPosition(_x:Float, _y:Float):Word {
		var char:Char = getCharByPosition(_x, _y, false);
		if (char == null || words == null)
			return null;

		for (word in words) {
			if (word == null)
				continue;
			if (word.containsIndex(char.index)) {
				return word;
			}
		}
		return null;
	}

	public function getCharByPosition(x:Float, y:Float, allowEndChar:Bool = true):Char {
		var closestIndex:Int = -1;
		var closestValue:Float = Math.POSITIVE_INFINITY;

		for (i in 0...lines.length) {
			var line = lines[i];
			var midY:Float = line.y + line.paddingTop + line.height / 2;
			var dif:Float = Math.abs(midY - y);
			if (Math.abs(dif) < closestValue) {
				closestValue = dif;
				closestIndex = i;
			} else {
				break; // closest found and now moving away from closest line
			}
		}
		if (closestIndex == -1) {
			return null;
		}
		return getCharByLineAndPosX(closestIndex, x, allowEndChar);
	}

	public function getCharByLineAndPosX(lineNumber:Int, _x:Float, allowEndChar:Bool = true):Char {
		var closestChar:Char = null;
		var closestValue:Float = Math.POSITIVE_INFINITY;

		if (lineNumber > lines.length - 1)
			lineNumber = lines.length - 1;
		if (lineNumber < 0)
			lineNumber = 0;

		var line:Line = lines[lineNumber];

		for (char in line.chars) {
			var dif:Float = Math.abs(char.x - _x);
			if (dif < closestValue) {
				closestValue = dif;
				closestChar = char;
			}
		}
		var endChar = this.endChar; // calling getter validates endChar
		return (allowEndChar || closestChar != endChar ? closestChar : null);
	}

	public function getLine(index:Int):Line {
		return lines[index];
	}

	public function remove(start:Int, end:Int):Void {
		characters.splice(start, end - start);
		for (i in start...characters.length) {
			characters[i].index -= end - start;
		}

		onCharsChanged();
		textDisplay.triggerUpdate(true);
		textDisplay.selection.index = start; // Must set index after updating text otherwise HistoryControl will modify previous HistoryStep
	}

	public function add(newStr:String, index:Int):Void {
		var format:InputFormat = textDisplay.formatModel.defaultFormat;
		var font:BitmapFont = textDisplay.formatModel.defaultFont;

		if (textDisplay.caret != null && textDisplay.caret.format != null) {
			format = textDisplay.caret.format.clone();
			font = textDisplay.caret.font;
		}

		var newStrSplit:Array<String> = newStr.split("");
		for (j in 0...newStrSplit.length) {
			var _index:Int = index + j;
			characters.insert(_index, new Char(newStrSplit[j], _index));
		}
		// characters.insert(index, new Char(newStr, index));
		for (i in (index + newStrSplit.length)...characters.length) {
			characters[i].index += newStrSplit.length;
		}

		onCharsChanged();
		textDisplay.triggerUpdate(true);
		textDisplay.selection.index += newStrSplit.length;
	}

	#if !debug inline #end function setPlacementX() {
		placementX = 0;
		placementY = 0;
		lineNumber = 0;

		var lastSpaceIndex:Int = 0;
		charLinePositionX = 0;

		var i:Int = 0;
		var goBack:Bool = false;
		limitReached = false;
		wordBreakFound = false;

		var lastChar:Char = null;
		var hasWrap:Bool = (textDisplay.textWrapping != TextWrapping.NONE);

		while (i < allCharacters.length) {
			goBack = false;
			var char:Char = allCharacters[i];
			if (char.isEndChar && lastChar != null) {
				char.font = lastChar.font;
				char.format = lastChar.format;
			} else {
				CharacterHelper.findCharFormat(textDisplay, char, textDisplay.contentModel.nodes);
				if (!char.isEndChar)
					CharacterHelper.findBitmapChar(char);
			}

			if (!textDisplay.allowLineBreaks && char.isLineBreak) {
				i++;
				continue;
			}

			char.spaceAsLineBreak = false;

			if (char.character == SpecialChar.Space) {
				lastSpaceIndex = i;
				wordBreakFound = true;
			}

			var charOffset = char.bitmapChar == null ? 0 : char.bitmapChar.xOffset * char.scale;
			if (i < allCharacters.length - 1
				&& char.character != SpecialChar.Space
				&& hasWrap
				&& !withinBoundsX(placementX + charOffset + char.width)) {
				if (lastSpaceIndex != i && wordBreakFound) {
					var lastSpaceChar:Char = allCharacters[lastSpaceIndex];
					lastSpaceChar.spaceAsLineBreak = true;
					if (lastSpaceChar.lineNumber == lineNumber) {
						i = lastSpaceIndex + 1;
						goBack = true;
					}
				}
				progressLine();
				if (goBack)
					continue;
			}

			char.x = placementX;
			if (limitReached)
				char.visible = false;
			else
				char.visible = true;

			if (char.bitmapChar != null)
				char.x += charOffset;

			char.lineNumber = lineNumber;
			char.charLinePositionX = charLinePositionX;
			charLinePositionX++;

			if (char.character != SpecialChar.Space || charLinePositionX != 0) {
				if (char.bitmapChar != null) {
					placementX += (char.bitmapChar.xAdvance * char.scale);
					if (char.format.kerning != null) {
						placementX += char.format.kerning;
					}
				}
			}

			if (i < allCharacters.length - 2 && char.character != SpecialChar.Space && hasWrap && !withinBoundsX(placementX)) {
				if (lastSpaceIndex != i && wordBreakFound) {
					var lastSpaceChar:Char = allCharacters[lastSpaceIndex];
					if (lastSpaceChar.lineNumber == lineNumber) {
						i = lastSpaceIndex + 1;
						goBack = true;
					}
				}
				progressLine();
				if (goBack)
					continue;
			} else if (char.character == SpecialChar.Return) {
				progressLine();
			} else if (char.character == SpecialChar.NewLine) {
				if (lastChar == null || lastChar.character != SpecialChar.Return) {
					// The sequence '\r\n' should only be rendered as a single line break
					progressLine();
				}
			}
			lastChar = char;
			i++;
		}
	}

	#if !debug inline #end function progressLine():Void {
		wordBreakFound = false;
		charLinePositionX = 0;
		placementX = 0;
		lineNumber++;
		if (!textDisplay.allowLineBreaks) {
			limitReached = true;
		}
	}

	#if !debug inline #end function findWords() {
		words = new Array<Word>();

		var t:Int = -1;
		var lt:Int = -1;
		var word:Word = null;
		for (i in 0...allCharacters.length) {
			var char:Char = allCharacters[i];
			if (char.character == SpecialChar.Space)
				t = 0;
			else if (char.character == SpecialChar.Tab)
				t = 1;
			else if (char.character == SpecialChar.NewLine)
				t = 2;
			else if (char.character == SpecialChar.Return)
				t = 3;
			else
				t = 4;
			if (lt != t) {
				word = new Word();
				word.index = words.length;
				words.push(word);
			}
			word.characters.push(char);
			lt = t;
		}
	}

	#if !debug inline #end function findLineHeight() {
		while (lines.length > 0) {
			lines.pop().dispose();
		}

		var rise:Float = Math.NaN;
		var fall:Float = Math.NaN;
		var leading:Float = Math.NaN;
		var top:Float = Math.NaN;
		var bottom:Float = Math.NaN;
		var lineHeight:Float = Math.NaN;

		var line:Line = null;
		var lineStack:Float = 0;
		var lastFont:BitmapFont = null;
		for (i in 0...allCharacters.length) {
			var char:Char = allCharacters[i];
			if (char.lineNumber >= lines.length) {
				if (line != null) {
					lineStack = finishLine(line, lineHeight, rise, fall, leading, lineStack, top, bottom, lines.length == 1, false);
				}

				line = Line.take();
				line.index = lines.length;
				lines.push(line);
				rise = Math.NaN;
				fall = Math.NaN;
				leading = Math.NaN;
				top = Math.NaN;
				bottom = Math.NaN;
				lineHeight = Math.NaN;
				lastFont = null;
			}
			char.line = line;
			if (char.font != lastFont) {
				var scale = char.scale;

				var charRise = char.font.baseline * scale;
				var charLineHeight = char.font.lineHeight * scale;
				var charFall = charLineHeight - charRise;
				var charLeading = char.format.leading;

				if (Math.isNaN(rise)) {
					rise = charRise;
					fall = charFall;
					leading = charLeading;
					lineHeight = charLineHeight;
				} else {
					if (rise < charRise)
						rise = charRise;
					if (fall < charFall)
						fall = charFall;
					if (leading < charLeading)
						leading = charLeading;
					if (lineHeight < charLineHeight)
						lineHeight = charLineHeight;
				}
				lastFont = char.font;
			}

			if (char.bitmapChar != null && !char.isEndChar && !char.isWhitespace) {
				var charTop:Float = (char.bitmapChar.yOffset * char.scale);
				var charBottom:Float = ((char.bitmapChar.yOffset + char.bitmapChar.height) * char.scale);

				if (Math.isNaN(top)) {
					top = charTop;
					bottom = charBottom;
				} else {
					if (top > charTop)
						top = charTop;
					if (bottom < charBottom)
						bottom = charBottom;
				}
			}

			line.chars.push(char);
		}
		if (line != null) {
			finishLine(line, lineHeight, rise, fall, leading, lineStack, top, bottom, lines.length == 1, true);
		}
	}

	#if !debug inline #end function finishLine(line:Line, lineHeight:Float, rise:Float, fall:Float, leading:Float, lineStack:Float, top:Float, bottom:Float,
			first:Bool, last:Bool):Float {
		if (line.index > 0)
			lineStack += leading;

		var paddingTop:Float = (Math.isNaN(top) ? 0 : top);
		var paddingBottom:Float = (Math.isNaN(bottom) ? 0 : (rise + fall) - bottom);

		line.setMetrics(lineHeight, rise, fall, leading, paddingTop, paddingBottom);
		line.y = lineStack;

		lineStack += line.height;
		return lineStack;
	}

	#if !debug inline #end function setLinePositions() {
		for (i in 0...allCharacters.length) {
			var char:Char = allCharacters[i];
			if (char.font == null)
				continue;

			var scale = char.scale;

			char.y = snap(char.line.y + char.line.rise);
			char.y -= char.font.baseline * scale;
			if (char.format.baseline != null)
				char.y += char.format.baseline;

			if (char.bitmapChar != null)
				char.y += char.bitmapChar.yOffset * scale;
		}
	}

	#if !debug inline #end function calcTextSize():Void {
		var autoHeight:Bool = (textDisplay.autoSize == TextFieldAutoSize.VERTICAL
			|| textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS);

		var boundsL:Float = 0;
		var boundsT:Float = 0;
		var boundsR:Float = 0;
		var boundsB:Float = 0;

		var firstLine:Line = null;
		var lastLine:Line = null;

		for (i in 0...lines.length) {
			var line = lines[i];
			if (line.boundsWidth == 0 || line.height == 0)
				continue;

			if (firstLine == null) {
				firstLine = line;
				boundsT = firstLine.y + (autoHeight ? firstLine.paddingTop : 0);
				boundsL = line.x;
				boundsR = line.right;
			} else {
				if (boundsL > line.x)
					boundsL = line.x;
				if (boundsR < line.right)
					boundsR = line.right;
			}
			lastLine = line;
		}

		if (lastLine == null && !autoHeight) {
			var line = lines[0];
			boundsT = line.y;
			boundsB = boundsT + line.height;
		} else if (lastLine != null) {
			boundsB = (lastLine.y + lastLine.height) - (autoHeight ? lastLine.paddingBottom : 0);
		}

		textDisplay._textBounds.setTo(boundsL, boundsT, boundsR - boundsL, boundsB - boundsT);
	}

	#if !debug inline #end function align() {
		var textY:Float = textDisplay._textBounds.y;
		var textHeight:Float = textDisplay._textBounds.height;

		var autoWidth:Bool = (textDisplay.autoSize == TextFieldAutoSize.HORIZONTAL
			|| textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS);
		var autoHeight:Bool = (textDisplay.autoSize == TextFieldAutoSize.VERTICAL
			|| textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS);
		var justify:Bool = false; // (textDisplay.hAlign == Align.JUSTIFY);

		var alignOffsetY:Float = -textY;
		if (!autoHeight) {
			if (textDisplay.targetHeight != null) {
				if (textDisplay.vAlign == Align.TOP) {
					alignOffsetY = 0;
				} else if (textDisplay.vAlign == Align.CENTER) {
					alignOffsetY += (textDisplay.targetHeight - textHeight) / 2;
				} else if (textDisplay.vAlign == Align.BOTTOM) {
					alignOffsetY += textDisplay.targetHeight - textHeight;
				}
			}
		}

		alignOffsetY = snap(alignOffsetY);

		var targetWidth:Float = (autoWidth ? textDisplay._textBounds.width : textDisplay.targetWidth);

		var minLineOffset:Float = 0;
		// var autoShiftX:Float = (autoWidth ? -textDisplay._textBounds.x : 0);

		for (i in 0...lines.length) {
			var line = lines[i];
			var lineOffset:Float = 0;

			var last:Int = line.chars.length - 1;
			if (justify) {
				lineOffset = -line.x + (targetWidth - line.boundsWidth) / last;
			} else if (textDisplay.hAlign == Align.LEFT) {
				lineOffset = 0;
			} else if (textDisplay.hAlign == Align.CENTER) {
				var lineWidth:Float = (autoWidth ? line.boundsWidth : line.totalWidth);
				lineOffset = (targetWidth - lineWidth) / 2;
			} else if (textDisplay.hAlign == Align.RIGHT) {
				var lineWidth:Float = (autoWidth ? line.boundsWidth : line.totalWidth);
				lineOffset = targetWidth - lineWidth;
			}
			if (autoWidth) {
				lineOffset -= textDisplay._textBounds.x;
			}

			if (i == 0)
				minLineOffset = lineOffset;
			else if (minLineOffset > lineOffset)
				minLineOffset = lineOffset;

			if (!justify) {
				line.x += lineOffset;
			}
			line.y += alignOffsetY;

			for (i in 0...line.chars.length) {
				var char = line.chars[i];
				if (justify) {
					if (line.validJustify || lineOffset < 0) {
						char.x += i <= last ? lineOffset * i : lineOffset;
					}
				} else
					char.x += lineOffset;

				char.y += alignOffsetY;
				char.x = snap(char.x, true);
			}
		}

		if (justify) {
			textDisplay._textBounds.width = textDisplay.targetWidth;
		} else {
			textDisplay._textBounds.x += minLineOffset;
		}
		textDisplay._textBounds.y += alignOffsetY;
	}

	inline function checkChange(oldTextX:Float, oldTextY:Float, oldTextW:Float, oldTextH:Float) {
		var sizeChange:Bool = false;
		var actualWidth:Float = (textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS
			|| textDisplay.autoSize == TextFieldAutoSize.HORIZONTAL ? textDisplay._textBounds.width : textDisplay.targetWidth);
		var actualHeight:Float = (textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS
			|| textDisplay.autoSize == TextFieldAutoSize.VERTICAL ? textDisplay._textBounds.height : textDisplay.targetHeight);

		if (textDisplay.actualWidth != actualWidth || textDisplay.actualHeight != actualHeight) {
			textDisplay.actualWidth = actualWidth;
			textDisplay.actualHeight = actualHeight;
			sizeChange = true;
		}

		if (oldTextX != textDisplay._textBounds.x
			|| oldTextY != textDisplay._textBounds.y
			|| oldTextW != textDisplay._textBounds.width
			|| oldTextH != textDisplay._textBounds.height) {
			sizeChange = true;
		}

		layoutChanged.fire();
		if (sizeChange)
			boundsChanged.fire();
	}

	function snap(value:Float, ?forwardOnly:Bool):Float {
		if (snapCharsTo == 0)
			return value;
		value = value / snapCharsTo;
		if (forwardOnly)
			value = Math.ceil(value);
		else
			value = Math.round(value);
		return value * snapCharsTo;
	}

	function withinBoundsX(value:Float):Bool {
		if (textDisplay.autoSize == TextFieldAutoSize.HORIZONTAL || textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS)
			return true;
		else if (value < textDisplay.targetWidth)
			return true;
		return false;
	}

	function withinBoundsY(value:Float):Bool {
		if (textDisplay.autoSize == TextFieldAutoSize.VERTICAL || textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS)
			return true;
		else if (value < textDisplay.targetHeight)
			return true;
		return false;
	}

	function get_endChar():EndChar {
		if (characters.length > 0) {
			var char:Char = characters[characters.length - 1];
			_endChar.font = char.font;
			_endChar.format = char.format;
		} else {
			_endChar.font = defaultChar.font;
			_endChar.format = defaultChar.format;
		}
		_endChar.index = characters.length;
		return _endChar;
	}
}
