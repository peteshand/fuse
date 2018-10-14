package fuse.core.front.texture;

import fuse.utils.Color;
import fuse.core.front.texture.Textures;
import fuse.geom.Rectangle;
import fuse.texture.ITexture;
import msignal.Signal.Signal0;

class Scale9Texture
{
    @:isVar public var width(get, set):Float;
	@:isVar public var height(get, set):Float;
	
    @:isVar public var scale9Grid(default, set):Rectangle;
    var rects:Array<Rectangle> = [];
    var uvs:Array<UVData> = [];    
    static var stretchX:Array<Bool> = [false, true, false, false, true, false, false, true, false]; 
    static var stretchY:Array<Bool> = [false, false, false, true, true, true, false, false, false];
    public var textures:Array<ITexture> = [];
    
    var posX:Array<Float> = [];
    var posY:Array<Float> = [];
    var widths:Array<Float> = [];
    var heights:Array<Float> = [];
    
    var uvXs:Array<Float> = [];
    var uvYs:Array<Float> = [];
    var uvWidths:Array<Float> = [];
    var uvHeights:Array<Float> = [];
    var texture:ITexture;
    public var onLayoutUpdate = new Signal0();

    public function new(texture:ITexture, scale9Grid:Rectangle)
    {
        
        for (i in 0...9) rects.push(new Rectangle());
        for (i in 0...9) uvs.push({
            offsetU:0,
            offsetV:0,
            scaleU:1,
            scaleV:1
        });
        
        this.texture = texture;
        this.scale9Grid = scale9Grid;
        for (i in 0...9) {
            textures.push(texture.createSubTexture(0, 0, 1, 1));
        }
        
        texture.onUpdate.add(onTextureUpdate);
        onTextureUpdate();
    }

    function onTextureUpdate()
    {
        if (this.width == null) this.width = texture.width;
        if (this.height == null) this.height = texture.height;
        updateRects();
    }

    function get_width():Float		{	return width;			}
	function get_height():Float		{	return height;			}

    function set_width(value:Float):Float
    {
        width = value;
        updateRects();
        return width;
    }

	function set_height(value:Float):Float
    {
        height = value;
        updateRects();
        return height;
    }

    function set_scale9Grid(value:Rectangle):Rectangle
    {
        scale9Grid = value;
        updateRects();
        return scale9Grid;
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

        updateLayout();
    }

    function updateLayout()
    {
        for (i in 0...textures.length) {
            var texture:ITexture = textures[i];
            var uvData:UVData = uvs[i];
            texture.offsetU = uvData.offsetU;
            texture.offsetV = uvData.offsetV;
            texture.scaleU = uvData.scaleU;
            texture.scaleV = uvData.scaleV;    
        }

        onLayoutUpdate.dispatch();
    }
}

typedef UVData =
{
    offsetU:Float,
    offsetV:Float,
    scaleU:Float,
    scaleV:Float
}