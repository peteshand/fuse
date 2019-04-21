package fuse.display;

import mantle.util.composite.Composite;
import mantle.util.composite.CompositeMode;
import fuse.texture.ITexture;
import fuse.utils.Align;

class Frame extends Sprite
{
    var background:Quad;
    var image:Image;
    var frameWidth:Float = 100;
    var frameHeight:Float = 100;
    var frameX:Float = 0;
    var frameY:Float = 0;
    
    @:isVar public var mode(default, set):CompositeMode = CompositeMode.LETTERBOX;
    @:isVar public var contentAlignH(default, set):Align = Align.CENTER;
    @:isVar public var contentAlignV(default, set):Align = Align.CENTER;
    
    public function new(width:Int, height:Int, texture:ITexture, backgroundColor:Null<UInt>=null) 
	{
		super();

        if (backgroundColor != null){
            background = new Quad(width, height, backgroundColor);
		    addChild(background);
        }

        image = new Image(texture);
        addChild(image);
        
        texture.onUpdate.add(updateLayout);

        frameWidth = width;
        frameHeight = height;
    }

    override function get_width():Float { return frameWidth; }
    override function get_height():Float { return frameHeight; }

    override function set_width(value:Float):Float
    { 
        background.width = frameWidth = value;
        updateLayout();
        return frameWidth;
    }

    override function set_height(value:Float):Float
    { 
        background.height = frameHeight = value;
        updateLayout();
        return frameHeight;
    }

    function set_mode(value:CompositeMode):CompositeMode
    {
        mode = value;
        updateLayout();
        return mode;
    }
    
    function set_contentAlignH(value:Align):Align
    {
        contentAlignH = value;
        updateLayout();
        return contentAlignH;
    }
    
    function set_contentAlignV(value:Align):Align
    {
        contentAlignV = value;
        updateLayout();
        return contentAlignV;
    }
    
    function updateLayout()
    {
        var rect = Composite.fit(frameWidth, frameHeight, image.texture.width, image.texture.height, mode, contentAlignH, contentAlignV);
        
        image.width = rect.width;
		image.height = rect.height;
		image.x = rect.x;
		image.y = rect.y;
        image.offsetU = 0;
        image.offsetV = 0;
        
        if (rect.width > frameWidth){
            if (rect.x < 0) {
                image.x = 0;
                image.offsetU = -rect.x / rect.width;
            }
            if (rect.width > frameWidth) image.width = frameWidth;
            image.scaleU = frameWidth / rect.width;
        } else {
            image.scaleU = 1;
        }

        if (rect.height > frameHeight){
            if (rect.y < 0) {
                image.y = 0;
                image.offsetV = -rect.y / rect.height;
            }
            if (rect.height > frameHeight) image.height = frameHeight;
            image.scaleV = frameHeight / rect.height;
        } else {
            image.scaleV = 1;
        }
    }
}