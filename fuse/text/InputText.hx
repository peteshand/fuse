package fuse.text;

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

    public function new(width:Int, height:Int)
    {
        super(width, height);

        hitArea = new Quad(width, height, 0xFF00FF00);
        addChild(hitArea);
        hitArea.touchable = true;
        hitArea.onPress.add(onPressHitarea);
        hitArea.alpha = 0;

        caret = new Caret(this);
        addChild(caret);
    }

    function onPressHitarea(touch:Touch)
    {
        if (stage != null){
            stage.focus.value = this;
        }
    }
}

class Caret extends Sprite
{
    var quad:Quad;
    var inputText:InputText;
    var count:Int = 0;

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
            EnterFrame.remove(tick);
            inputText.onUpdate.remove(onTextUpdate);
        }
    }

    function onTextUpdate()
    {
        var v = inputText.text;
        inputText.text = "A";
        quad.height = inputText.textHeight * 0.75;
        inputText.text = v;

        if (inputText.defaultTextFormat.align == TextFormatAlign.LEFT){
            this.x = 0;
            quad.x = Math.round(inputText.textWidth + (quad.height * 0.2));
        } else if (inputText.defaultTextFormat.align == TextFormatAlign.CENTER){
            this.x = inputText.width / 2;
            quad.x = Math.round((inputText.textWidth / 2) + (quad.height * 0.2));
        } else if (inputText.defaultTextFormat.align == TextFormatAlign.RIGHT){
            this.x = inputText.width;
            quad.x = 0;
        }
        quad.y = Math.round(quad.height * 0.25);
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