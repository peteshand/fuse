package fuse.core.front.texture;

import openfl.display.StageQuality;
import fuse.core.front.texture.FrontBitmapTexture;
import fuse.utils.GcoArray;
import fuse.utils.PowerOfTwo;
import lime.text.UTF8String;
import time.EnterFrame;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField as NativeTextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;

/**
 * ...
 * @author P.J.Shand
 */
class FrontTextFieldTexture extends FrontBitmapTexture {
	static var dirtyItems:GcoArray<FrontTextFieldTexture>;

	static function init():Void {
		if (dirtyItems != null)
			return;
		dirtyItems = new GcoArray<FrontTextFieldTexture>();
		EnterFrame.add(updateDirtyTextFields);
	}

	static function updateDirtyTextFields() {
		for (i in 0...dirtyItems.length) {
			dirtyItems[i].updateText();
		}
		dirtyItems.clear();
	}

	@:isVar var dirtyProp(default, set):Bool = false;
	@:isVar var dirtySize(default, set):Bool = false;
	@:isVar var dirty(default, set):Bool = false;
	var nativeTextField:NativeTextField;
	var bitmapdata:BitmapData;
	var targetWidth:Float;
	var targetHeight:Float;
	var textureWidth:Int;
	var textureHeight:Int;

	// @:isVar public var width(default, set):Float;
	// @:isVar public var height(default, set):Float;
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
	// @:beta public var shader:Shader;
	public var sharpness(get, set):Float;
	public var text(get, set):UTF8String;
	public var textColor(get, set):Int;
	public var textHeight(get, never):Float;
	public var textWidth(get, never):Float;
	public var type(get, set):TextFieldType;
	public var wordWrap(get, set):Bool;

	var initialized:Bool = false;

	public function new(?text:String, width:Int, ?height:Null<Int>, ?defaultTextFormat:TextFormat, queUpload:Bool = true) {
		FrontTextFieldTexture.init();
		nativeTextField = new NativeTextField();
		nativeTextField.embedFonts = true;
		nativeTextField.antiAliasType = AntiAliasType.ADVANCED;
		nativeTextField.sharpness = 400;
		nativeTextField.width = width;
		nativeTextField.wordWrap = true;
		// if (width != null)
		//	nativeTextField.width = width;
		// if (height != null)
		//	nativeTextField.height = height;

		if (defaultTextFormat != null) {
			nativeTextField.defaultTextFormat = defaultTextFormat;
		}

		dirtySize = false;
		if (text != null && height == null) {
			nativeTextField.text = text;
			// nativeTextField.setTextFormat(defaultTextFormat);
			// dirtyProp = true;
			// dirtySize = true;
			// if (height == null)
			height = Math.ceil(nativeTextField.textHeight) + 5;
			nativeTextField.text = "";
		}

		bitmapdata = new BitmapData(width, height, true, clearColour);

		this.width = width;
		this.height = height;

		super(bitmapdata, width, height, queUpload);

		updateText();
	}

	public function appendText(text:String):Void {
		nativeTextField.appendText(text);
		dirtyProp = true;
	}

	public function getCharBoundaries(charIndex:Int):Rectangle {
		return nativeTextField.getCharBoundaries(charIndex);
	}

	public function getCharIndexAtPoint(x:Float, y:Float):Int {
		return nativeTextField.getCharIndexAtPoint(x, y);
	}

	public function getFirstCharInParagraph(charIndex:Int):Int {
		return nativeTextField.getFirstCharInParagraph(charIndex);
	}

	public function getLineIndexAtPoint(x:Float, y:Float):Int {
		return nativeTextField.getLineIndexAtPoint(x, y);
	}

	public function getLineIndexOfChar(charIndex:Int):Int {
		return nativeTextField.getLineIndexOfChar(charIndex);
	}

	public function getLineLength(lineIndex:Int):Int {
		return nativeTextField.getLineLength(lineIndex);
	}

	public function getLineMetrics(lineIndex:Int):TextLineMetrics {
		return nativeTextField.getLineMetrics(lineIndex);
	}

	public function getLineOffset(lineIndex:Int):Int {
		return nativeTextField.getLineOffset(lineIndex);
	}

	public function getLineText(lineIndex:Int):String {
		return nativeTextField.getLineText(lineIndex);
	}

	public function getParagraphLength(charIndex:Int):Int {
		return nativeTextField.getParagraphLength(charIndex);
	}

	public function getTextFormat(beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		return nativeTextField.getTextFormat(beginIndex, endIndex);
	}

	public function replaceSelectedText(value:String):Void {
		nativeTextField.replaceSelectedText(value);
		dirtyProp = true;
	}

	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void {
		nativeTextField.replaceText(beginIndex, endIndex, newText);
		dirtyProp = true;
	}

	public function setSelection(beginIndex:Int, endIndex:Int) {
		nativeTextField.setSelection(beginIndex, endIndex);
		dirtyProp = true;
	}

	// Check default values for beginIndex and endIndex on non-flash targets
	public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void {
		nativeTextField.setTextFormat(format, beginIndex, endIndex);
		dirtyProp = true;
	}

	// Getters & Setters

	function get_antiAliasType():AntiAliasType
		return nativeTextField.antiAliasType;

	function get_autoSize():TextFieldAutoSize
		return nativeTextField.autoSize;

	function get_background():Bool
		return nativeTextField.background;

	function get_backgroundColor():Int
		return nativeTextField.backgroundColor;

	function get_border():Bool
		return nativeTextField.border;

	function get_borderColor():Int
		return nativeTextField.borderColor;

	function get_bottomScrollV():Int
		return nativeTextField.bottomScrollV;

	function get_caretIndex():Int
		return nativeTextField.caretIndex;

	function get_defaultTextFormat():TextFormat
		return nativeTextField.defaultTextFormat;

	function get_displayAsPassword():Bool
		return nativeTextField.displayAsPassword;

	function get_embedFonts():Bool
		return nativeTextField.embedFonts;

	function get_gridFitType():GridFitType
		return nativeTextField.gridFitType;

	// override function get_height():Float	return nativeTextField.height;
	function get_htmlText():String
		return nativeTextField.htmlText;

	function get_length():Int
		return nativeTextField.length;

	function get_maxChars():Int
		return nativeTextField.maxChars;

	function get_maxScrollH():Int
		return nativeTextField.maxScrollH;

	function get_maxScrollV():Int
		return nativeTextField.maxScrollV;

	function get_mouseWheelEnabled():Bool
		return nativeTextField.mouseWheelEnabled;

	function get_multiline():Bool
		return nativeTextField.multiline;

	function get_numLines():Int
		return nativeTextField.numLines;

	function get_restrict():String
		return nativeTextField.restrict;

	function get_scrollH():Int
		return nativeTextField.scrollH;

	function get_scrollV():Int
		return nativeTextField.scrollV;

	function get_selectable():Bool
		return nativeTextField.selectable;

	function get_selectionBeginIndex():Int
		return nativeTextField.selectionBeginIndex;

	function get_selectionEndIndex():Int
		return nativeTextField.selectionEndIndex;

	function get_sharpness():Float
		return nativeTextField.sharpness;

	function get_text():String
		return nativeTextField.text;

	function get_textColor():Int
		return nativeTextField.textColor;

	function get_textWidth():Float
		return nativeTextField.textWidth;

	function get_textHeight():Float
		return nativeTextField.textHeight;

	function get_type():TextFieldType
		return nativeTextField.type;

	function get_wordWrap():Bool
		return nativeTextField.wordWrap;

	// override function get_width():Float		return nativeTextField.width;

	function set_antiAliasType(value:AntiAliasType):AntiAliasType {
		if (nativeTextField.antiAliasType == value)
			return value;
		nativeTextField.antiAliasType = value;
		dirtyProp = true;
		return value;
	}

	function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize {
		if (nativeTextField.autoSize == value)
			return value;
		nativeTextField.autoSize = value;
		dirtyProp = true;
		return value;
	}

	function set_background(value:Bool):Bool {
		if (nativeTextField.background == value)
			return value;
		nativeTextField.background = value;
		dirtyProp = true;
		return value;
	}

	function set_backgroundColor(value:Int):Int {
		if (nativeTextField.backgroundColor == value)
			return value;
		nativeTextField.backgroundColor = value;
		dirtyProp = true;
		return value;
	}

	function set_border(value:Bool):Bool {
		if (nativeTextField.border == value)
			return value;
		nativeTextField.border = value;
		dirtyProp = true;
		return value;
	}

	function set_borderColor(value:Int):Int {
		if (nativeTextField.borderColor == value)
			return value;
		nativeTextField.borderColor = value;
		dirtyProp = true;
		return value;
	}

	function set_defaultTextFormat(value:TextFormat):TextFormat {
		if (nativeTextField.defaultTextFormat == value)
			return value;
		nativeTextField.defaultTextFormat = value;
		dirtyProp = true;
		return value;
	}

	function set_displayAsPassword(value:Bool):Bool {
		if (nativeTextField.displayAsPassword == value)
			return value;
		nativeTextField.displayAsPassword = value;
		dirtyProp = true;
		return value;
	}

	function set_embedFonts(value:Bool):Bool {
		if (nativeTextField.embedFonts == value)
			return value;
		nativeTextField.embedFonts = value;
		dirtyProp = true;
		return value;
	}

	function set_gridFitType(value:GridFitType):GridFitType {
		if (nativeTextField.gridFitType == value)
			return value;
		nativeTextField.gridFitType = value;
		dirtyProp = true;
		return value;
	}

	override function set_height(value:Null<Int>):Null<Int> {
		super.set_height(value);
		nativeTextField.height = value;
		targetHeight = nativeTextField.height;
		var _textureHeight:Int = PowerOfTwo.getNextPowerOfTwo(Math.floor(targetHeight));
		if (textureHeight != _textureHeight) {
			textureHeight = _textureHeight;
			dirtySize = true;
		}
		return value;
	}

	function set_htmlText(value:String):String {
		if (nativeTextField.htmlText == value)
			return value;
		nativeTextField.htmlText = value;
		dirtyProp = true;
		return value;
	}

	function set_maxChars(value:Int):Int {
		if (nativeTextField.maxChars == value)
			return value;
		nativeTextField.maxChars = value;
		dirtyProp = true;
		return value;
	}

	function set_mouseWheelEnabled(value:Bool):Bool {
		if (nativeTextField.mouseWheelEnabled == value)
			return value;
		nativeTextField.mouseWheelEnabled = value;
		dirtyProp = true;
		return value;
	}

	function set_multiline(value:Bool):Bool {
		if (nativeTextField.multiline == value)
			return value;
		nativeTextField.multiline = value;
		dirtyProp = true;
		return value;
	}

	function set_scrollH(value:Int):Int {
		if (nativeTextField.scrollH == value)
			return value;
		nativeTextField.scrollH = value;
		dirtyProp = true;
		return value;
	}

	function set_restrict(value:String):String {
		if (nativeTextField.restrict == value)
			return value;
		nativeTextField.restrict = value;
		dirtyProp = true;
		return value;
	}

	function set_scrollV(value:Int):Int {
		if (nativeTextField.scrollV == value)
			return value;
		nativeTextField.scrollV = value;
		dirtyProp = true;
		return value;
	}

	function set_selectable(value:Bool):Bool {
		if (nativeTextField.selectable == value)
			return value;
		nativeTextField.selectable = value;
		dirtyProp = true;
		return value;
	}

	function set_sharpness(value:Float):Float {
		if (nativeTextField.sharpness == value)
			return value;
		nativeTextField.sharpness = value;
		dirtyProp = true;
		return value;
	}

	function set_text(value:String):String {
		if (nativeTextField.text == value)
			return value;
		nativeTextField.text = value;
		dirtyProp = true;
		return value;
	}

	function set_textColor(value:Int):Int {
		if (nativeTextField.textColor == value)
			return value;
		nativeTextField.textColor = value;
		dirtyProp = true;
		return value;
	}

	function set_wordWrap(value:Bool):Bool {
		if (nativeTextField.wordWrap == value)
			return value;
		nativeTextField.wordWrap = value;
		dirtyProp = true;
		return value;
	}

	function set_type(value:TextFieldType):TextFieldType {
		if (nativeTextField.type == value)
			return value;
		nativeTextField.type = value;
		dirtyProp = true;
		return value;
	}

	override function set_width(value:Null<Int>):Null<Int> {
		super.set_width(value);
		nativeTextField.width = value;
		targetWidth = nativeTextField.width;
		var _textureWidth:Int = PowerOfTwo.getNextPowerOfTwo(Math.floor(targetWidth));
		if (textureWidth != _textureWidth) {
			textureWidth = _textureWidth;
			dirtySize = true;
		}

		return value;
	}

	function set_dirtyProp(value:Bool):Bool {
		if (dirtyProp != value) {
			dirtyProp = value;
			if (dirtyProp)
				this.dirty = true;
		}
		return value;
	}

	function set_dirtySize(value:Bool):Bool {
		if (dirtySize != value) {
			dirtySize = value;
			if (dirtySize)
				this.dirty = true;
		}
		return value;
	}

	function set_dirty(value:Bool):Bool {
		if (dirty != value) {
			dirty = value;
			dirtyItems.push(this);
		}
		return value;
	}

	static var count:Int = 0;

	public function updateText():Void {
		if (!initialized || dirtySize == true) {
			if (bitmapdata != null)
				bitmapdata.dispose();

			// trace([this.width, this.textureWidth, this.nativeTextField.width]);
			bitmapdata = new BitmapData(textureWidth, textureHeight, true, clearColour);
			bitmapdata.drawWithQuality(nativeTextField, null, null, null, null, true, StageQuality.HIGH);
			var textureId:Null<Int> = null;
			if (this.objectId > 1) {
				textureId = this.objectId;
				// texture.dispose();
			}

			// trace("create new texture");
			this.update(bitmapdata);
			// texture = new BitmapTexture(bitmapdata, false, null, textureId);
			// texture.directRender = directRender;
			initialized = true;
			onUpdate.dispatch();
		} else if (dirtyProp == true) {
			// trace("redraw texture");
			bitmapdata.fillRect(bitmapdata.rect, clearColour);
			bitmapdata.drawWithQuality(nativeTextField, null, null, null, null, true, StageQuality.HIGH);
			this.update(bitmapdata);
			onUpdate.dispatch();
		}

		// isStatic = 0;
		// updateAll = true;
		dirtySize = false;
		dirtyProp = false;
		dirty = false;
	}

	/*function get_baseBmdTexture():BitmapTexture 
		{
			return untyped texture;
	}*/
	/*function get_directRender():Bool 
		{
			return directRender;
		}

		function set_directRender(value:Bool):Bool
		{
			if (texture != null) texture.directRender = value;
			return directRender = value;
	}*/
	override public function dispose():Void {
		super.dispose();
	}
}
