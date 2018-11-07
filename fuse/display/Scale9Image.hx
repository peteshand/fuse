package fuse.display;

import fuse.utils.Color;
import fuse.core.front.texture.Textures;
import fuse.geom.Rectangle;
import fuse.texture.ITexture;

class Scale9Image extends Sprite
{
    var uvXs:Array<Float> = [];
    var uvYs:Array<Float> = [];
    var uvWidths:Array<Float> = [];
    var uvHeights:Array<Float> = [];

    var rects:Array<Rectangle> = [];
    var uvs:Array<UVData> = [];

    var posX:Array<Float> = [];
    var posY:Array<Float> = [];
    var widths:Array<Float> = [];
    var heights:Array<Float> = [];
    
    var texture:ITexture;
	var images:Array<Image> = [];

    @:isVar public var scale9Grid(default, set):Rectangle;

    public function new(texture:ITexture, scale9Grid:Rectangle) 
	{
		super();
        for (i in 0...9) {
            uvs.push({ offsetU:0, offsetV:0, scaleU:1, scaleV:1 });
            rects.push(new Rectangle());

            var image:Image = new Image(texture);
            addChild(image);
            images.push(image);
        }
        this.texture = texture;
        this.scale9Grid = scale9Grid;

        //texture.onLayoutUpdate.add(updateRects);
        texture.onUpload.add(updateRects);
        updateRects();
    }

    override function get_width():Float {    return width; }
    override function get_height():Float {    return height; }
    

    override function set_width(value:Float):Float { 
        width = value;
        updateRects();
        return value;
	}

    override function set_height(value:Float):Float {
        height = value;
        updateRects();
        return value;
	}

    function set_scale9Grid(value:Rectangle):Rectangle
    {
        scale9Grid = value;
        updateRects();
        return scale9Grid;
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
        if (texture == null) return;
        if (texture.width == 0) return;
		if (texture.height == 0) return;
        if (width == 0) return;
		if (height == 0) return;
        
        var leftX:Float = 0;
        var leftWidth:Float = scale9Grid.x;
        var middleX:Float = leftX + leftWidth;
        var middleWidth:Float = width - (scale9Grid.x * 2);
        var rightX:Float = middleX + middleWidth;
        var rightWidth:Float = width - rightX;

        var topY:Float = 0;
        var topHeight:Float = scale9Grid.y;
        var middleY:Float = topY + topHeight;
        var middleHeight:Float = height - (scale9Grid.y * 2);
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
        
        var uvLeftWidth:Float = rects[0].width / texture.width;
        var uvRightWidth:Float = rects[2].width / texture.width;
        var uvMiddleWidth:Float = 1 - uvLeftWidth - uvRightWidth;
        
        var uvLeftX:Float = 0;
        var uvMiddleX:Float = uvLeftX + uvLeftWidth;
        var uvRightX:Float = 1 - uvRightWidth;
        
        var uvTopHeight:Float = rects[0].height / texture.height;
        var uvBottomHeight:Float = rects[6].height / texture.height;
        var uvMiddleHeight:Float = 1 - uvTopHeight - uvBottomHeight;
        
        var uvTopY:Float = 0;
        var uvMiddleY:Float = uvTopY + uvTopHeight;
        var uvBottomY:Float = 1 - uvBottomHeight;
        
        uvXs[0] = uvLeftX;
        uvXs[1] = uvMiddleX;
        uvXs[2] = uvRightX; 

        uvYs[0] = uvTopY;
        uvYs[1] = uvMiddleY;
        uvYs[2] = uvBottomY; 

        uvWidths[0] = uvLeftWidth;
        uvWidths[1] = uvMiddleWidth;
        uvWidths[2] = uvRightWidth; 

        uvHeights[0] = uvTopHeight;
        uvHeights[1] = uvMiddleHeight;
        uvHeights[2] = uvBottomHeight;

        for (i in 0...uvs.length) {
            var uvData:UVData = uvs[i];
            var xi:Int = i % 3;
            var yi:Int = Math.floor(i/3);
            
            uvData.offsetU = uvXs[xi];
            uvData.offsetV = uvYs[yi];
            uvData.scaleU = uvWidths[xi];
            uvData.scaleV = uvHeights[yi];
        }

        //updateLayout();



        



        /*var leftX:Float = 0;
        var leftWidth:Float = scale9Grid.x;
        var middleX:Float = leftX + leftWidth;
        var middleWidth:Float = width - (scale9Grid.x * 2);
        var rightX:Float = middleX + middleWidth;
        var rightWidth:Float = width - rightX;

        var topY:Float = 0;
        var topHeight:Float = scale9Grid.y;
        var middleY:Float = topY + topHeight;
        var middleHeight:Float = height - (scale9Grid.y * 2);
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
        heights[2] = bottomHeight;*/

        /*for (i in 0...rects.length) {
            var rect:Rectangle = rects[i];
            var xi:Int = i % 3;
            var yi:Int = Math.floor(i/3);
            rect.x = posX[xi];
            rect.y = posY[yi];
            rect.width = widths[xi];
            rect.height = heights[yi];
        }*/

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

            //var texture:ITexture = textures[i];
            var uvData:UVData = uvs[i];
            image.offsetU = uvData.offsetU;
            image.offsetV = uvData.offsetV;
            image.scaleU = uvData.scaleU;
            image.scaleV = uvData.scaleV;   
        }
    }
}

typedef UVData =
{
    offsetU:Float,
    offsetV:Float,
    scaleU:Float,
    scaleV:Float
}