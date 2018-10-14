package fuse.display;

import fuse.utils.Color;
import fuse.core.front.texture.Textures;
import fuse.geom.Rectangle;
import fuse.texture.ITexture;
import fuse.texture.Scale9Texture;

class Scale9Image extends Sprite
{
    var rects:Array<Rectangle> = [];
    var posX:Array<Float> = [];
    var posY:Array<Float> = [];
    var widths:Array<Float> = [];
    var heights:Array<Float> = [];
    
    var scale9Texture:Scale9Texture;
	var images:Array<Image> = [];

    public function new(scale9Texture:Scale9Texture) 
	{
		super();
        for (i in 0...9) rects.push(new Rectangle());
        this.scale9Texture = scale9Texture;
        
        for (i in 0...scale9Texture.textures.length){
            var image:Image = new Image(scale9Texture.textures[i]);
            addChild(image);
            images.push(image);
        }

        scale9Texture.onLayoutUpdate.add(onLayoutUpdate);
        onLayoutUpdate();
    }

    function onLayoutUpdate()
    {
        for (i in 0...images.length){
            var rect:Rectangle = rects[i];
            var image:Image = images[i];
            image.x = rect.x;
            image.y = rect.y;
            image.width = rect.width;
            image.height = rect.height;
        }
    }

    override function get_width():Float {    return width; }
    override function get_height():Float {    return height; }
    

    override function set_width(value:Float):Float { 
        scale9Texture.width = width = value;
        updateRects();
        return scale9Texture.width;
	}

    override function set_height(value:Float):Float {
        scale9Texture.height = height = value;
        updateRects();
        return scale9Texture.height;
	}
	
    override function set_color(value:Color):Color { 
		for (i in 0...images.length) {
            var image:Image = images[i];
            image.color = value;
        }
		return super.set_color(value);
	}

    override function set_renderLayer(value:Null<Int>):Null<Int> 
	{
		for (i in 0...images.length) {
            var image:Image = images[i];
            image.renderLayer = value;
        }
		return renderLayer = value;
	}   

    function updateRects()
    {
        var leftX:Float = 0;
        var leftWidth:Float = scale9Texture.scale9Grid.x;
        var middleX:Float = leftX + leftWidth;
        var middleWidth:Float = width - (scale9Texture.scale9Grid.x * 2);
        var rightX:Float = middleX + middleWidth;
        var rightWidth:Float = width - rightX;

        var topY:Float = 0;
        var topHeight:Float = scale9Texture.scale9Grid.y;
        var middleY:Float = topY + topHeight;
        var middleHeight:Float = height - (scale9Texture.scale9Grid.y * 2);
        var bottomY:Float = middleY + middleHeight;
        var bottomHeight:Float = height - bottomY;

        posX[0] = leftX;
        posX[1] = middleX;
        posX[2] = rightX; 

        posY[0] = topY;
        posY[1] = middleY;
        posY[2] = bottomY; 

        widths[0] = leftWidth;
        widths[1] = middleWidth;
        widths[2] = rightWidth; 

        heights[0] = topHeight;
        heights[1] = middleHeight;
        heights[2] = bottomHeight;

        for (i in 0...rects.length) {
            var rect:Rectangle = rects[i];
            var xi:Int = i % 3;
            var yi:Int = Math.floor(i/3);
            
            rect.x = posX[xi];
            rect.y = posY[yi];
            rect.width = widths[xi];
            rect.height = heights[yi];
        }
    }
}