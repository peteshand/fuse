package fuse.texture;

import fuse.core.front.texture.TextFieldTexture as FrontTextFieldTexture;
import fuse.utils.Align;
import fuse.utils.Color;
import fuse.display.Image;
import fuse.texture.ITexture;
import fuse.utils.GcoArray;
import fuse.utils.PowerOfTwo;
import lime.text.UTF8String;
import mantle.time.EnterFrame;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;

class TextFieldTexture extends BaseTexture
{
    var textFieldTexture:FrontTextFieldTexture;
    public var antiAliasType(get, set):AntiAliasType;
	public var autoSize(get, set):TextFieldAutoSize;
	public var background(get, set):Bool;
	public var backgroundColor(get, set):Int;
	public var border(get, set):Bool;
	public var borderColor(get, set):Int;
	public var bottomScrollV(get, never):Int;
	public var caretIndex(get, never):Int;
	public var defaultTextFormat(get, set):TextFormat;
	public var displayAsPassword(get, set):Bool;
	public var embedFonts(get, set):Bool;
	public var gridFitType(get, set):GridFitType;
	public var htmlText(get, set):UTF8String;
	public var length(get, never):Int;
	public var maxChars(get, set):Int;
	public var maxScrollH(get, never):Int;
	public var maxScrollV(get, never):Int;
	public var mouseWheelEnabled(get, set):Bool;
	public var multiline(get, set):Bool;
	public var numLines(get, never):Int;
	public var restrict(get, set):UTF8String;
	public var scrollH(get, set):Int;
	public var scrollV(get, set):Int;
	public var selectable(get, set):Bool;
	public var selectionBeginIndex(get, never):Int;
	public var selectionEndIndex(get, never):Int;
	public var sharpness(get, set):Float;
	public var text(get, set):UTF8String;
	public var textColor(get, set):Int;
	public var textHeight(get, never):Float;
	public var textWidth(get, never):Float;
	public var type(get, set):TextFieldType;
	public var wordWrap(get, set):Bool;
	
	public function new(width:Int, height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
        super();
        texture = textFieldTexture = new FrontTextFieldTexture(width, height, queUpload, onTextureUploadCompleteCallback);
    }

	public function appendText(text:String):Void
	{	
		textFieldTexture.appendText(text);
	}
	
	public function getCharBoundaries(charIndex:Int):Rectangle	{	return textFieldTexture.getCharBoundaries(charIndex); }
	public function getCharIndexAtPoint(x:Float, y:Float):Int	{	return textFieldTexture.getCharIndexAtPoint(x, y); }
	public function getFirstCharInParagraph(charIndex:Int):Int	{	return textFieldTexture.getFirstCharInParagraph(charIndex); }
	public function getLineIndexAtPoint(x:Float, y:Float):Int	{	return textFieldTexture.getLineIndexAtPoint(x, y); }
	public function getLineIndexOfChar(charIndex:Int):Int		{	return textFieldTexture.getLineIndexOfChar(charIndex); }
	public function getLineLength(lineIndex:Int):Int			{	return textFieldTexture.getLineLength(lineIndex); }
	public function getLineMetrics(lineIndex:Int):TextLineMetrics	{	return textFieldTexture.getLineMetrics(lineIndex); }
	public function getLineOffset(lineIndex:Int):Int				{	return textFieldTexture.getLineOffset(lineIndex); }
	public function getLineText(lineIndex:Int):String				{	return textFieldTexture.getLineText(lineIndex); }
	public function getParagraphLength(charIndex:Int):Int			{	return textFieldTexture.getParagraphLength(charIndex); }
	public function getTextFormat(beginIndex:Int = 0, endIndex:Int = 0):TextFormat	{	return textFieldTexture.getTextFormat(beginIndex, endIndex); }
	
	public function replaceSelectedText(value:String):Void
	{
		textFieldTexture.replaceSelectedText(value);
	}
	
	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
	{
		textFieldTexture.replaceText(beginIndex, endIndex, newText);
	}
	
	public function setSelection(beginIndex:Int, endIndex:Int)
	{
		textFieldTexture.setSelection(beginIndex, endIndex);
	}
	
	public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
	{
		textFieldTexture.setTextFormat(format, beginIndex, endIndex);
	}
	
	
	function get_antiAliasType():AntiAliasType	return textFieldTexture.antiAliasType;
	function get_autoSize():TextFieldAutoSize	return textFieldTexture.autoSize;
	function get_background():Bool			return textFieldTexture.background;
	function get_backgroundColor():Int		return textFieldTexture.backgroundColor;
	function get_border():Bool				return textFieldTexture.border;
	function get_borderColor():Int			return textFieldTexture.borderColor;
	function get_bottomScrollV():Int		return textFieldTexture.bottomScrollV;
	function get_caretIndex():Int			return textFieldTexture.caretIndex;
	function get_defaultTextFormat():TextFormat	return textFieldTexture.defaultTextFormat;
	function get_displayAsPassword():Bool	return textFieldTexture.displayAsPassword;
	function get_embedFonts():Bool			return textFieldTexture.embedFonts;
	function get_gridFitType():GridFitType	return textFieldTexture.gridFitType;
	function get_htmlText():String			return textFieldTexture.htmlText;
	function get_length():Int				return textFieldTexture.length;
	function get_maxChars():Int				return textFieldTexture.maxChars;
	function get_maxScrollH():Int			return textFieldTexture.maxScrollH;
	function get_maxScrollV():Int			return textFieldTexture.maxScrollV;
	function get_mouseWheelEnabled():Bool	return textFieldTexture.mouseWheelEnabled;
	function get_multiline():Bool			return textFieldTexture.multiline;
	function get_numLines():Int				return textFieldTexture.numLines;
	function get_restrict():String			return textFieldTexture.restrict;
	function get_scrollH():Int				return textFieldTexture.scrollH;
	function get_scrollV():Int				return textFieldTexture.scrollV;
	function get_selectable():Bool			return textFieldTexture.selectable;
	function get_selectionBeginIndex():Int	return textFieldTexture.selectionBeginIndex;
	function get_selectionEndIndex():Int	return textFieldTexture.selectionEndIndex;
	function get_sharpness():Float			return textFieldTexture.sharpness;
	function get_text():String				return textFieldTexture.text;
	function get_textColor():Int			return textFieldTexture.textColor;
	function get_textWidth():Float			return textFieldTexture.textWidth;
	function get_textHeight():Float			return textFieldTexture.textHeight;
	function get_type():TextFieldType		return textFieldTexture.type;
	function get_wordWrap():Bool			return textFieldTexture.wordWrap;
	
	function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		return textFieldTexture.antiAliasType = value;
	}
	
	function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		return textFieldTexture.autoSize = value;
	}
	
	function set_background(value:Bool):Bool
	{
		return textFieldTexture.background = value;
	}
	
	function set_backgroundColor(value:Int):Int
	{
		return textFieldTexture.backgroundColor = value;
	}
	
	function set_border(value:Bool):Bool
	{
		return textFieldTexture.border = value;
	}
	
	function set_borderColor(value:Int):Int
	{
		return textFieldTexture.borderColor = value;
	}
	
	function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		return textFieldTexture.defaultTextFormat = value;
	}
	
	function set_displayAsPassword(value:Bool):Bool
	{
		return textFieldTexture.displayAsPassword = value;
	}
	
	function set_embedFonts(value:Bool):Bool
	{
		return textFieldTexture.embedFonts = value;
	}
	
	function set_gridFitType(value:GridFitType):GridFitType
	{
		return textFieldTexture.gridFitType = value;
	}
	
	function set_htmlText(value:String):String
	{
		return textFieldTexture.htmlText = value;
	}
	
	function set_maxChars(value:Int):Int
	{
		return textFieldTexture.maxChars = value;
	}
	
	function set_mouseWheelEnabled(value:Bool):Bool
	{
		return textFieldTexture.mouseWheelEnabled = value;
	}
	
	function set_multiline(value:Bool):Bool
	{
		return textFieldTexture.multiline = value;
	}
	
	function set_scrollH(value:Int):Int
	{
		return textFieldTexture.scrollH = value;
	}
	
	function set_restrict(value:String):String
	{
		return textFieldTexture.restrict = value;
	}
	
	function set_scrollV(value:Int):Int
	{
		return textFieldTexture.scrollV = value;
	}
	
	function set_selectable(value:Bool):Bool
	{
		return textFieldTexture.selectable = value;
	}
	
	function set_sharpness(value:Float):Float
	{
		return textFieldTexture.sharpness = value;
	}
	
	function set_text(value:String):String
	{
		return textFieldTexture.text = value;
	}
	
	function set_textColor(value:Int):Int
	{
		return textFieldTexture.textColor = value;
	}
	
	function set_wordWrap(value:Bool):Bool
	{
		return textFieldTexture.wordWrap = value;
	}
	
	function set_type(value:TextFieldType):TextFieldType
	{
		return textFieldTexture.type = value;
	}
	
	public function updateText():Void
	{
		textFieldTexture.updateText();
	}
}