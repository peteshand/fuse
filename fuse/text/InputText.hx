package fuse.text;

import mantle.delay.Delay;
import fuse.geom.Rectangle;
import mantle.time.EnterFrame;
import fuse.display.Stage;
import fuse.input.Touch;
import fuse.display.Quad;
import fuse.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */
class InputText extends TextField
{
    var hitArea:Quad;
    var caret:Caret;
    var active:Bool = false;
    public var editable:Bool = true;

    public function new(width:Int, height:Int)
    {
        super(width, height);

        hitArea = new Quad(10, 10, 0xFF00FF00);
        addChild(hitArea);
        hitArea.touchable = true;
        hitArea.onPress.add(onPressHitarea);
        hitArea.alpha = 0;

        caret = new Caret(this);
        addChild(caret);

        stage.focus.add(onFocusChange);
        onUpdate.add(onTextUpdate);
    }

    function onTextUpdate()
    {
        hitArea.width = width;
        hitArea.height = textHeight;
    }

    override function setStage(value:Stage):Stage 
	{
        super.setStage(value);
        onFocusChange();
        
        return value;
    }

    function onFocusChange()
    {
        if (stage != null){
            if (stage.focus.value == this) stage.onPress.add(onPressStage);
            else stage.onPress.remove(onPressStage);
        }
    }

    function onPressHitarea(touch:Touch)
    {
        active = true;
        Delay.nextFrame(updateOnNextFrame);
    }

    function onPressStage(touch:Touch)
    {
        active = false;
    }

    function updateOnNextFrame()
    {
        if (stage != null && editable){
            if (active) stage.focus.value = this;
            else if (stage.focus.value == this) stage.focus.value = null;
        }
    }
}
@:access(fuse.text.InputText)
class Caret extends Sprite
{
    var quad:Quad;
    var inputText:InputText;
    var count:Int = 0;
    var lastCharBounds:Rectangle = null;

    public function new(inputText:InputText)
    {
        super();
        this.inputText = inputText;

        quad = new Quad(2, 37, 0xFFFFFFFF);
        addChild(quad);
        quad.visible = false;
    }

    override function setStage(value:Stage):Stage 
	{
        if (stage != null){
            stage.focus.remove(onFocusChange);
        }
        super.setStage(value);
        if (stage != null){
            stage.focus.add(onFocusChange);
            onFocusChange();
        }
		return value;
	}

    function onFocusChange()
    {
        if (stage.focus.value == inputText){
            count = 0;
            EnterFrame.add(tick);
            inputText.onUpdate.add(onTextUpdate);
            onTextUpdate();
        } else {
            lastCharBounds = null;
            quad.visible = false;
            EnterFrame.remove(tick);
            inputText.onUpdate.remove(onTextUpdate);
        }
    }

    function onTextUpdate()
    {
        var _lastCharBounds:Rectangle = null;
        var currentLen:Int = inputText.text.length;
        if (currentLen > 0){
            _lastCharBounds = inputText.nativeTextField.getCharBoundaries(currentLen-1);
        } else {
            if (lastCharBounds == null){
                inputText.text = "A";
                //quad.height = inputText.textHeight * 0.75;
                _lastCharBounds = inputText.nativeTextField.getCharBoundaries(0);
                inputText.text = "";
            } else {
                _lastCharBounds = lastCharBounds;
            }
            _lastCharBounds.width = 0;
        }
        
        lastCharBounds = _lastCharBounds;

        if (lastCharBounds != null){
            quad.x = lastCharBounds.x + lastCharBounds.width;
            quad.y = lastCharBounds.y - (lastCharBounds.height * 0.05);
            quad.height = lastCharBounds.height * 0.8;
        }
        
    }

    function tick()
    {
        count++;
        if (count == 20){
            count = 0;
            quad.visible = quad.visible == false;
        }
    }
}