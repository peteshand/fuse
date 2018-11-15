package fuse.text;

import notifier.Signal;
import msignal.Signal.Signal0;
import openfl.events.FocusEvent;
import openfl.events.Event;
import openfl.Lib;
import mantle.delay.Delay;
import openfl.display.StageQuality;
import fuse.texture.BitmapTexture;
import fuse.utils.Align;
import fuse.utils.Color;
import fuse.display.Image;
import fuse.display.Sprite;
import fuse.utils.GcoArray;
import fuse.utils.PowerOfTwo;
import lime.text.UTF8String;
import mantle.time.EnterFrame;
import openfl.display.BitmapData;

import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField as NativeTextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;
import openfl.geom.Matrix;

/**
 * ...
 * @author P.J.Shand
 */
class TextField extends Sprite
{
	static var dirtyItems:GcoArray<TextField>;
	
	static function init():Void
	{
		if (dirtyItems != null) return;
		dirtyItems = new GcoArray<TextField>();
		EnterFrame.add(updateDirtyTextFields);
	}
	
	static function updateDirtyTextFields() 
	{
		for (i in 0...dirtyItems.length) 
		{
			dirtyItems[i].update();
		}
		dirtyItems.clear();
	}
	
	@:isVar var dirtyProp(default, set):Bool = false;
	@:isVar var dirtySize(default, set):Bool = false;
	@:isVar var dirty(default, set):Bool = false;
	
	var nativeTextField:NativeTextField;
	var image:Image;
	var bitmapdata:BitmapData;
	var targetWidth:Float;
	var targetHeight:Float;
	var textureWidth:Int;
	var textureHeight:Int;

	public var textHeight(get, never):Null<Float>;
	public var textWidth(get, never):Null<Float>;
	
	public var antiAliasType(get, set):AntiAliasType;
	@:isVar public var autoSize(default, set):TextFieldAutoSize = TextFieldAutoSize.HORIZONTAL;
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
	public var type(get, set):TextFieldType;
	public var wordWrap(get, set):Bool;
	
	public var offsetU(get, set):Float;
	public var offsetV(get, set):Float;
	public var scaleU(get, set):Float;
	public var scaleV(get, set):Float;
	
	@:isVar public var directRender(get, set):Bool = false;
	
	var debug:Bool = false;
	var clearColour:Color = 0x00000000;
	public var texture(get, never):BitmapTexture;
	var initialized:Bool = false;
	public var onUpdate = new Signal0();
	var matrix:Matrix = new Matrix();
	@:isVar public var lineOffset(default, set):Float;
	public var onTextChange = new Signal();

	public function new(width:Int, height:Int) 
	{
		TextField.init();
		nativeTextField = new NativeTextField();
		nativeTextField.addEventListener(Event.CHANGE, onNativeTextChange);
		nativeTextField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		nativeTextField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		//nativeTextField.width = width;
		//nativeTextField.height = height;
		
		//bitmapdata = new BitmapData(width, height, true, clearColour);
		dirtySize = false;
		
		super();
		image = new Image(null);
		addChild(image);

		this.width = width;// nativeTextField.width;// = width;
		this.height = height;// nativeTextField.height;// = height;
		
		update();
	}

	function set_lineOffset(value:Float):Float
	{
		lineOffset = value;
		matrix.identity();
		matrix.ty = value;
		dirtyProp = true;
		return value;
	}

	function onFocusIn(e:FocusEvent)
	{
		trace(e);
		EnterFrame.add(checkSelection);
	}

	function onFocusOut(e:FocusEvent)
	{
		trace(e);
		EnterFrame.remove(checkSelection);
	}

	function checkSelection()
	{
		//trace([nativeTextField.selectionBeginIndex, nativeTextField.selectionEndIndex]);
	}

	function onNativeTextChange(e:Event)
	{
		//trace(e);
		var hasFocus:Bool = Lib.current.stage.focus == nativeTextField;
		if (hasFocus) {
			Lib.current.stage.focus = null;
		}
		dirtyProp = true;
		Delay.nextFrame(() -> { 
			if (hasFocus) {
				Lib.current.stage.focus = nativeTextField;
			}
		});
	}
	
	public function appendText(text:String):Void
	{	
		nativeTextField.appendText(text);
		dirtyProp = true;
		onTextChange.dispatch();
	}
	
	public function getCharBoundaries(charIndex:Int):Rectangle	{	return nativeTextField.getCharBoundaries(charIndex); }
	public function getCharIndexAtPoint(x:Float, y:Float):Int	{	return nativeTextField.getCharIndexAtPoint(x, y); }
	public function getFirstCharInParagraph(charIndex:Int):Int	{	return nativeTextField.getFirstCharInParagraph(charIndex); }
	public function getLineIndexAtPoint(x:Float, y:Float):Int	{	return nativeTextField.getLineIndexAtPoint(x, y); }
	public function getLineIndexOfChar(charIndex:Int):Int		{	return nativeTextField.getLineIndexOfChar(charIndex); }
	public function getLineLength(lineIndex:Int):Int			{	return nativeTextField.getLineLength(lineIndex); }
	public function getLineMetrics(lineIndex:Int):TextLineMetrics	{	return nativeTextField.getLineMetrics(lineIndex); }
	public function getLineOffset(lineIndex:Int):Int				{	return nativeTextField.getLineOffset(lineIndex); }
	public function getLineText(lineIndex:Int):String				{	return nativeTextField.getLineText(lineIndex); }
	public function getParagraphLength(charIndex:Int):Int			{	return nativeTextField.getParagraphLength(charIndex); }
	public function getTextFormat(beginIndex:Int = 0, endIndex:Int = 0):TextFormat	{	return nativeTextField.getTextFormat(beginIndex, endIndex); }
	
	public function replaceSelectedText(value:String):Void
	{
		nativeTextField.replaceSelectedText(value);
		dirtyProp = true;
	}
	
	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
	{
		nativeTextField.replaceText(beginIndex, endIndex, newText);
		dirtyProp = true;
	}
	
	public function setSelection(beginIndex:Int, endIndex:Int)
	{
		nativeTextField.setSelection(beginIndex, endIndex);
		dirtyProp = true;
	}
	
	// Check default values for beginIndex and endIndex on non-flash targets
	public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
	{
		nativeTextField.setTextFormat(format, beginIndex, endIndex);
		dirtyProp = true;
	}
	
	
	// Getters & Setters
	
	function get_antiAliasType():AntiAliasType	return nativeTextField.antiAliasType;
	function get_background():Bool			return nativeTextField.background;
	function get_backgroundColor():Int		return nativeTextField.backgroundColor;
	function get_border():Bool				return nativeTextField.border;
	function get_borderColor():Int			return nativeTextField.borderColor;
	function get_bottomScrollV():Int		return nativeTextField.bottomScrollV;
	function get_caretIndex():Int			return nativeTextField.caretIndex;
	function get_defaultTextFormat():TextFormat	return nativeTextField.defaultTextFormat;
	function get_displayAsPassword():Bool	return nativeTextField.displayAsPassword;
	function get_embedFonts():Bool			return nativeTextField.embedFonts;
	function get_gridFitType():GridFitType	return nativeTextField.gridFitType;
	override function get_height():Float	return nativeTextField.height * this.scaleY;
	function get_htmlText():String			return nativeTextField.htmlText;
	function get_length():Int				return nativeTextField.length;
	function get_maxChars():Int				return nativeTextField.maxChars;
	function get_maxScrollH():Int			return nativeTextField.maxScrollH;
	function get_maxScrollV():Int			return nativeTextField.maxScrollV;
	function get_mouseWheelEnabled():Bool	return nativeTextField.mouseWheelEnabled;
	function get_multiline():Bool			return nativeTextField.multiline;
	function get_numLines():Int				return nativeTextField.numLines;
	function get_restrict():String			return nativeTextField.restrict;
	function get_scrollH():Int				return nativeTextField.scrollH;
	function get_scrollV():Int				return nativeTextField.scrollV;
	function get_selectable():Bool			return nativeTextField.selectable;
	function get_selectionBeginIndex():Int	return nativeTextField.selectionBeginIndex;
	function get_selectionEndIndex():Int	return nativeTextField.selectionEndIndex;
	function get_sharpness():Float			return nativeTextField.sharpness;
	function get_text():String				return nativeTextField.text;
	function get_textColor():Int			return nativeTextField.textColor;
	function get_textWidth():Float			return nativeTextField.textWidth * this.scaleX;
	function get_textHeight():Float
	{
		var _h:Float = nativeTextField.textHeight * this.scaleY;
		if (_h > height) _h = height;
		return _h;
	}
	function get_type():TextFieldType		return nativeTextField.type;
	function get_wordWrap():Bool			return nativeTextField.wordWrap;
	override function get_width():Float		return nativeTextField.width * this.scaleX;
	
	function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		nativeTextField.antiAliasType = value;
		dirtyProp = true;
		return value;
	}
	
	function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		autoSize = value;
		dirtyProp = true;
		return value;
	}
	
	function set_background(value:Bool):Bool
	{
		nativeTextField.background = value;
		dirtyProp = true;
		return value;
	}
	
	function set_backgroundColor(value:Int):Int
	{
		nativeTextField.backgroundColor = value;
		dirtyProp = true;
		return value;
	}
	
	function set_border(value:Bool):Bool
	{
		nativeTextField.border = value;
		dirtyProp = true;
		return value;
	}
	
	function set_borderColor(value:Int):Int
	{
		nativeTextField.borderColor = value;
		dirtyProp = true;
		return value;
	}
	
	function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		nativeTextField.defaultTextFormat = value;
		dirtyProp = true;
		return value;
	}
	
	function set_displayAsPassword(value:Bool):Bool
	{
		nativeTextField.displayAsPassword = value;
		dirtyProp = true;
		return value;
	}
	
	function set_embedFonts(value:Bool):Bool
	{
		nativeTextField.embedFonts = value;
		dirtyProp = true;
		return value;
	}
	
	function set_gridFitType(value:GridFitType):GridFitType
	{
		nativeTextField.gridFitType = value;
		dirtyProp = true;
		return value;
	}
	
	private override function set_height(value:Float):Float
	{
		image.set_height(value);
		nativeTextField.height = value;
		targetHeight = nativeTextField.height;
		var _textureHeight:Int = PowerOfTwo.getNextPowerOfTwo(Math.floor(targetHeight));
		if (textureHeight != _textureHeight) {
			textureHeight = _textureHeight;
			dirtySize = true;
		}
		dirtyProp = true;
		return value;
	}
	
	function set_htmlText(value:String):String
	{
		nativeTextField.htmlText = value;
		dirtyProp = true;
		return value;
	}
	
	function set_maxChars(value:Int):Int
	{
		nativeTextField.maxChars = value;
		dirtyProp = true;
		return value;
	}
	
	function set_mouseWheelEnabled(value:Bool):Bool
	{
		nativeTextField.mouseWheelEnabled = value;
		dirtyProp = true;
		return value;
	}
	
	function set_multiline(value:Bool):Bool
	{
		nativeTextField.multiline = value;
		dirtyProp = true;
		return value;
	}
	
	function set_scrollH(value:Int):Int
	{
		nativeTextField.scrollH = value;
		dirtyProp = true;
		return value;
	}
	
	function set_restrict(value:String):String
	{
		nativeTextField.restrict = value;
		dirtyProp = true;
		return value;
	}
	
	function set_scrollV(value:Int):Int
	{
		nativeTextField.scrollV = value;
		dirtyProp = true;
		return value;
	}
	
	function set_selectable(value:Bool):Bool
	{
		nativeTextField.selectable = value;
		dirtyProp = true;
		return value;
	}
	
	function set_sharpness(value:Float):Float
	{
		nativeTextField.sharpness = value;
		dirtyProp = true;
		return value;
	}
	
	function set_text(value:String):String
	{
		if (value == null) value = "";
		if (nativeTextField.text == value) return value;

		nativeTextField.text = value;
		if (nativeTextField.maxChars > 0 && nativeTextField.text.length > nativeTextField.maxChars){
			nativeTextField.text = nativeTextField.text.substr(0, nativeTextField.maxChars);
		}
		dirtyProp = true;
		onTextChange.dispatch();
		return value;
	}
	
	function set_textColor(value:Int):Int
	{
		nativeTextField.textColor = value;
		dirtyProp = true;
		return value;
	}
	
	function set_wordWrap(value:Bool):Bool
	{
		nativeTextField.wordWrap = value;
		dirtyProp = true;
		return value;
	}
	
	function set_type(value:TextFieldType):TextFieldType
	{
		nativeTextField.type = value;
		dirtyProp = true;
		return value;
	}

	override function get_pivotX():Float { return image.pivotX; }
	override function get_pivotY():Float { return image.pivotY; }
	override function set_pivotX(value:Float):Float { return image.pivotX = value; }
	override function set_pivotY(value:Float):Float { return image.pivotY = value; }

	function get_offsetU():Float { return image.offsetU; }
	function get_offsetV():Float { return image.offsetV; }
	function get_scaleU():Float { return image.scaleU; }
	function get_scaleV():Float { return image.scaleV; }
	
	function set_offsetU(value:Float):Float { return image.offsetU = value; }
	function set_offsetV(value:Float):Float { return image.offsetV = value; }
	function set_scaleU(value:Float):Float { return image.scaleU = value; }
	function set_scaleV(value:Float):Float { return image.scaleV = value; }
	
	override public function alignPivot(horizontalAlign:Align = Align.CENTER, verticalAlign:Align = Align.CENTER) 
	{
		image.alignPivot(horizontalAlign, verticalAlign);
	}
	
	override public function alignPivotX(horizontalAlign:Align = Align.CENTER) 
	{
		image.alignPivotX(horizontalAlign);
	}
	
	override public function alignPivotY(verticalAlign:Align = Align.CENTER) 
	{
		image.alignPivotY(verticalAlign);
	}
	
	override function set_width(value:Float):Float
	{
		image.set_width(value);
		nativeTextField.width = value;
		targetWidth = nativeTextField.width;
		var _textureWidth:Int = PowerOfTwo.getNextPowerOfTwo(Math.floor(targetWidth));
		if (textureWidth != _textureWidth) {
			textureWidth = _textureWidth;
			dirtySize = true;
		}
		
		
		//trace("textureWidth: " + textureWidth);
		
		dirtyProp = true;
		return value;
	}
	
	function set_dirtyProp(value:Bool):Bool 
	{
		if (dirtyProp != value) {
			dirtyProp = value;
			if (dirtyProp) this.dirty = true;
		}
		return value;
	}
	
	function set_dirtySize(value:Bool):Bool 
	{
		if (dirtySize != value) {
			dirtySize = value;
			if (dirtySize) this.dirty = true;
		}
		return value;
	}
	
	function set_dirty(value:Bool):Bool 
	{
		if (dirty != value) {
			dirty = value;
			dirtyItems.push(this);
		}
		return value;
	}
	
	public function update():Void
	{
		/*if (debug){
			trace(nativeTextField.getCharBoundaries(0));
			if (nativeTextField.parent != null) trace(nativeTextField.getRect(nativeTextField.parent));
			trace(nativeTextField.getRect(nativeTextField));
			if (nativeTextField.parent != null) trace(nativeTextField.getBounds(nativeTextField.parent));
			trace(nativeTextField.getBounds(nativeTextField));
		}*/
		
		if (!initialized || dirtySize == true) {
			if (bitmapdata != null) bitmapdata.dispose();
			//trace([this.width, this.textureWidth, this.nativeTextField.width]);
			bitmapdata = new BitmapData(textureWidth, textureHeight, true, clearColour);
			bitmapdata.drawWithQuality(nativeTextField, matrix, null, null, null, false, StageQuality.HIGH);
			var textureId:Null<Int> = null;
			if (image.texture != null && image.texture.objectId > 1) {
				textureId = image.texture.objectId;
				image.texture.dispose();
			}
			//trace("create new texture");
			image.texture = new BitmapTexture(bitmapdata, false, null, textureId);
			image.texture.directRender = directRender;
			initialized = true;
			texture.scaleU = targetWidth / textureWidth;
			texture.scaleV = targetHeight / textureHeight;
			onUpdate.dispatch();
		}
		else if (dirtyProp == true) {
			//trace("redraw texture");
			bitmapdata.fillRect(bitmapdata.rect, clearColour);
			bitmapdata.drawWithQuality(nativeTextField, matrix, null, null, null, false, StageQuality.HIGH);
			texture.update(bitmapdata);
			texture.scaleU = targetWidth / textureWidth;
			texture.scaleV = targetHeight / textureHeight;
			onUpdate.dispatch();
		}

		//isStatic = 0;
		//updateAll = true;
		dirtySize = false;
		dirtyProp = false;
		dirty = false;
	}
	
	function get_texture():BitmapTexture 
	{
		return untyped image.texture;
	}
	
	function get_directRender():Bool 
	{
		return directRender;
	}
	
	function set_directRender(value:Bool):Bool 
	{
		if (texture != null) texture.directRender = value;
		return directRender = value;
	}
	
	override function updateAlignment() 
	{
		image.updateAlignment();
	}
	
	override public function dispose():Void
	{
		super.dispose();
		texture.dispose();
	}
}