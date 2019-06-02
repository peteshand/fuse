package fuse.text;

import delay.Delay;
import fuse.geom.Rectangle;
import time.EnterFrame;
import fuse.display.Stage;
import fuse.input.Touch;
import fuse.display.Quad;
import fuse.display.Sprite;
import notifier.Notifier;
import fuse.geom.Point;
import keyboard.Key;
import keyboard.Keyboard;
import fuse.display.DisplayObjectContainer;

/**
 * ...
 * @author P.J.Shand
 */
class InputText extends TextField {
	var hitArea:Quad;
	var caret:Caret;
	var active:Bool = false;

	public var editable:Bool = true;

	var charIndex = new Notifier<Int>(0);
	var selectEnd:Bool;

	public var ignoreKeyCodes:Array<Int>;

	public function new(width:Int, height:Int) {
		super(width, height);

		hitArea = new Quad(10, 10, 0xFF000000);
		addChild(hitArea);
		hitArea.touchable = true;
		hitArea.y = -5;
		hitArea.onPress.add(onPressHitarea);
		hitArea.alpha = 0;

		caret = new Caret(this);
		addChild(caret);

		stage.focus.add(onFocusChange);
		onUpdate.add(onTextUpdate);

		ignoreKeyCodes = [
			Key.LEFT,
			Key.RIGHT,
			Key.UP,
			Key.DOWN,
			Key.COMMAND,
			Key.CONTROL,
			Key.ALTERNATE,
			-1
		];

		Keyboard.onPress(onKeyPress);
	}

	function onTextUpdate() {
		hitArea.width = width;
		if (textHeight == 0)
			hitArea.height = height + 10;
		else
			hitArea.height = textHeight + 10;
	}

	override function setStage(value:Stage):Stage {
		super.setStage(value);
		onFocusChange();

		return value;
	}

	function onFocusChange() {
		if (stage != null) {
			if (stage.focus.value == this) {
				stage.onPress.add(onPressStage);
			} else {
				stage.onPress.remove(onPressStage);
			}
		}
	}

	function onKeyPress() {
		if (stage.focus.value != this)
			return;

		var text:String = this.text;
		var charCode:Int = Keyboard.event.charCode;
		var keyCode:Int = Keyboard.event.keyCode;
		var _charIndex:Int = charIndex.value;

		if (keyCode == Key.LEFT) {
			var c = charIndex.value - 1;
			if (c < 0)
				c = 0;
			charIndex.value = c;
			selectEnd = false;
			return;
		} else if (keyCode == Key.RIGHT) {
			var c = charIndex.value + 1;
			if (c > text.length) {
				c = text.length;
			}
			charIndex.value = c;
			return;
		} else if (charCode == Key.BACKSPACE) {
			if (text.length == 0 || _charIndex == 0)
				return;
			text = text.substr(0, _charIndex - 1) + text.substring(_charIndex, text.length);
		} else if (charCode == Key.SHIFT || keyCode == Key.SHIFT) {
			return;
		} else if (!multiline && keyCode == Key.ENTER) {
			return;
		} else {
			for (i in 0...ignoreKeyCodes.length) {
				if ( /*charCode == ignoreKeyCodes[i] ||*/ keyCode == ignoreKeyCodes[i])
					return;
			}
			var letter:String = String.fromCharCode(charCode);
			// var letter2:String = String.fromCharCode(keyCode);
			text = text.substr(0, _charIndex) + letter + text.substring(_charIndex, text.length);
		}

		this.text = text;
	}

	function onPressHitarea(touch:Touch) {
		active = true;
		var p:Point = new Point(touch.x - image.bounds.x, touch.y - image.bounds.y);
		var _charIndex:Int = -1;
		selectEnd = false;

		var smallestDis:Float = Math.POSITIVE_INFINITY;
		for (i in 0...text.length) {
			var charBounds = getCharBoundaries(i);
			if (charBounds != null) {
				var disX:Float = p.x - charBounds.x;
				var disY:Float = p.y - charBounds.y;
				var dis:Float = Math.sqrt(Math.pow(disX, 2) + Math.pow(disY, 2));
				if (smallestDis > dis) {
					smallestDis = dis;
					_charIndex = i;
				}
				if (i == text.length - 1) {
					if (disX > charBounds.width / 2) {
						_charIndex++;
					}
				}
			}
		}
		charIndex.value = _charIndex;
		Delay.nextFrame(updateOnNextFrame);
	}

	override function set_text(value:String):String {
		if (value == null)
			value = "";
		var currentText:String = text;
		if (currentText == "")
			selectEnd = true;
		var offset:Int = value.length - currentText.length;
		super.set_text(value);
		if (charIndex.value < 0)
			charIndex.value = 0 + offset;
		else
			charIndex.value += offset;
		return value;
	}

	function onPressStage(touch:Touch) {
		active = false;
	}

	function updateOnNextFrame() {
		if (stage != null && editable) {
			if (active)
				stage.focus.value = this;
			// else if (stage.focus.value == this) stage.focus.value = null;
		}
	}

	override public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void {
		super.setTextFormat(format, beginIndex, endIndex);
		charIndex.dispatch();
	}
}

@:access(fuse.text.InputText)
class Caret extends Sprite {
	var quad:Quad;
	var inputText:InputText;
	var count:Int = 0;
	var cursorCharBounds:Rectangle = null;

	public function new(inputText:InputText) {
		super();
		this.inputText = inputText;

		quad = new Quad(2, 37, 0xFFFFFFFF);
		addChild(quad);
		quad.visible = false;

		inputText.charIndex.add(onCharIndexChange);
	}

	function onCharIndexChange() {
		var _cursorCharBounds:Rectangle = null;
		var currentLen:Int = inputText.text.length;
		if (currentLen > 0) {
			var i:Int = inputText.charIndex.value;
			if (i > inputText.text.length - 1) {
				i = inputText.text.length - 1;
				inputText.selectEnd = true;
			}
			_cursorCharBounds = inputText.nativeTextField.getCharBoundaries(i);
		} else {
			if (cursorCharBounds == null) {
				inputText.text = "A";
				// quad.height = inputText.textHeight * 0.75;
				_cursorCharBounds = inputText.nativeTextField.getCharBoundaries(0);
				inputText.text = "";
			} else {
				_cursorCharBounds = cursorCharBounds;
			}
			_cursorCharBounds.width = 0;
		}
		cursorCharBounds = _cursorCharBounds;
		if (cursorCharBounds != null) {
			if (inputText.selectEnd) {
				quad.x = cursorCharBounds.x + cursorCharBounds.width;
			} else {
				quad.x = cursorCharBounds.x;
			}

			quad.y = cursorCharBounds.y - (cursorCharBounds.height * 0.05);
			quad.height = cursorCharBounds.height * 0.8;
		}
		inputText.selectEnd = false;
	}

	override function setStage(value:Stage):Stage {
		if (stage != null) {
			stage.focus.remove(onFocusChange);
		}
		super.setStage(value);
		if (stage != null) {
			stage.focus.add(onFocusChange);
			onFocusChange();
		}
		return value;
	}

	function onFocusChange() {
		if (stage.focus.value == inputText) {
			count = 0;
			EnterFrame.add(tick);
			inputText.onUpdate.add(onTextUpdate);
			onTextUpdate();
		} else {
			cursorCharBounds = null;
			quad.visible = false;
			EnterFrame.remove(tick);
			inputText.onUpdate.remove(onTextUpdate);
		}
	}

	function onTextUpdate() {}

	function tick() {
		count++;
		if (count == 20) {
			count = 0;
			quad.visible = quad.visible == false;
		}
	}
}
