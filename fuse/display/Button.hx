package fuse.display;

import fuse.utils.Align;
import fuse.input.Touch;
import fuse.texture.ITexture;

class Button extends Sprite
{
    public var hitArea:Quad;
    var normalImage:Image;
    var overImage:Image;
    var downImage:Image;

    var pressing:Bool = false;
    var over:Bool = false;
    
    public function new(normalTexture:ITexture, ?overTexture:ITexture, ?downTexture:ITexture)
    {
        super();
        
        normalImage = new Image(normalTexture);
        addChild(normalImage);

        hitArea = new Quad(50, 50, 0xFFFFFFFF);
        //hitArea.touchable = true;

        if (overTexture != null) {
            overImage = new Image(overTexture);
            addChild(overImage);
            overImage.visible = false;

            //hitArea.onRollover.add((touch:Touch) -> { trace("onRollover"); over = true; updateButtonTexture(); });
            //hitArea.onRollout.add((touch:Touch) -> { trace("onRollout"); over = false; updateButtonTexture(); });
        }
        if (downTexture != null) {
            downImage = new Image(downTexture);
            addChild(downImage);
            downImage.visible = false;
            
            //hitArea.onPress.add((touch:Touch) -> { pressing = true; updateButtonTexture(); });
            //hitArea.onRelease.add((touch:Touch) -> { pressing = false; updateButtonTexture(); });
        }

        
        //addChild(hitArea);
        
    }

    function updateButtonTexture()
    {
        trace("pressing = " + pressing);
        trace("over = " + over);
        
        if (pressing && downImage != null){
            show(downImage);
        }
        else {
            if (over && overImage != null) {
                show(overImage);
            }
            else {
                show(normalImage);
            }
        }
    }

    function show(image:Image)
    {
        normalImage.alpha = 0;
        if (overImage != null) overImage.visible = false;
        if (downImage != null) downImage.visible = false;
        image.alpha = 1;
        image.visible = true;
    }

    override public function alignPivotX(horizontalAlign:Align = Align.CENTER) 
	{
		normalImage.alignPivotX(horizontalAlign);
        if (overImage != null) overImage.alignPivotX(horizontalAlign);
        if (downImage != null) downImage.alignPivotX(horizontalAlign);
	}
	
	override public function alignPivotY(verticalAlign:Align = Align.CENTER) 
	{
		normalImage.alignPivotY(verticalAlign);
        if (overImage != null) overImage.alignPivotY(verticalAlign);
        if (downImage != null) downImage.alignPivotY(verticalAlign);
	}
}