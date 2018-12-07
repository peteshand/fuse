package fuse.core.backend.display;

import fuse.geom.Point;

class CoreMask
{
    public var image:CoreImage;
    public var mask:CoreImage;
    public var uv:Array<Point> = [];
    public var alpha(get, null):Float;

    var tempBounds = new TempBounds();

    public function new(image:CoreImage, mask:CoreImage)
    {
        this.image = image;
        this.mask = mask;

        for (i in 0...4){
            uv.push(new Point());
        }
        mask.addMaskOf(image);
    }

    public function dispose()
    {
        if (mask != null) mask.removeMaskOf(image);
        uv = null;
        image = null;
        mask = null;
    }

    public function updateUVs()
    {
        uv[0].x = mask.coreTexture.uvLeft;
        uv[1].x = mask.coreTexture.uvLeft;
        uv[2].x = mask.coreTexture.uvRight;
        uv[3].x = mask.coreTexture.uvRight;

        uv[0].y = mask.coreTexture.uvBottom;
        uv[1].y = mask.coreTexture.uvTop;
        uv[2].y = mask.coreTexture.uvTop ;
        uv[3].y = mask.coreTexture.uvBottom;

        var absoluteRotation = mask.absoluteRotation();
        var rotation = mask.displayData.rotation;
        var scaleX = mask.displayData.scaleX / image.displayData.scaleX;
        var scaleY = mask.displayData.scaleX / image.displayData.scaleY;
        
        var offsetX:Float = (mask.absoluteX - image.absoluteX) / image.displayData.width / image.displayData.scaleX;
        var offsetY:Float = (mask.absoluteY - image.absoluteY) / image.displayData.height / image.displayData.scaleY;

        rotate(uv[0], mask.uvPivot.x, mask.uvPivot.y, rotation, scaleX, scaleY, offsetX, offsetY, absoluteRotation);
        rotate(uv[1], mask.uvPivot.x, mask.uvPivot.y, rotation, scaleX, scaleY, offsetX, offsetY, absoluteRotation);
        rotate(uv[2], mask.uvPivot.x, mask.uvPivot.y, rotation, scaleX, scaleY, offsetX, offsetY, absoluteRotation);
        rotate(uv[3], mask.uvPivot.x, mask.uvPivot.y, rotation, scaleX, scaleY, offsetX, offsetY, absoluteRotation);
        
    }

    function rotate(p:Point, pivotX:Float, pivotY:Float, rotation:Float, scaleX:Float, scaleY:Float, offsetX:Float, offsetY:Float, absoluteRotation:Float)
    {
        var _x:Float = p.x - pivotX;
        var _y:Float = p.y - pivotY;
        var h:Float = Math.sqrt(Math.pow(_x, 2) + Math.pow(_y, 2));
        var currentRot:Float = Math.atan2(_y, _x) * 180 / Math.PI;
        var newRotation:Float = currentRot - rotation;
        p.x = pivotX + (Math.cos(newRotation / 180 * Math.PI) * h / scaleX);
        p.y = pivotY + (Math.sin(newRotation / 180 * Math.PI) * h / scaleY);

        p.x -= Math.cos(absoluteRotation / 180 * Math.PI) * offsetX / scaleX;
        p.x -= Math.sin(absoluteRotation / 180 * Math.PI) * offsetY / scaleY;

        p.y -= Math.cos(absoluteRotation / 180 * Math.PI) * offsetY / scaleY;
        p.y += Math.sin(absoluteRotation / 180 * Math.PI) * offsetX / scaleX;
    }
    
    function removeRotation(p:Point)
    {
        var r:Float = Core.WINDOW_WIDTH / Core.WINDOW_HEIGHT;
        
        vertexToPixelSpace(p);
        
        p.x -= mask.absoluteX;
        p.y -= mask.absoluteY;
        
        var h:Float = Math.sqrt(Math.pow(p.x, 2) + Math.pow(p.y, 2));
        var currentRot:Float = Math.atan2(p.y, p.x) * 180 / Math.PI;
        var absoluteRotation = mask.absoluteRotation();
        var newRotation:Float = currentRot - absoluteRotation;
        
        p.x = Math.cos(newRotation / 180 * Math.PI) * h;
        p.y = Math.sin(newRotation / 180 * Math.PI) * h;
        
        p.x += mask.absoluteX;
        p.y += mask.absoluteY;

        pixelToVertexSpace(p);
    }

    function vertexToPixelSpace(p:Point)
    {
        p.x = vertexToPixelSpaceX(p.x);
        p.y = vertexToPixelSpaceY(p.y);
    }

    inline function vertexToPixelSpaceX(v:Float)
    {
        return ((v + 1) * 0.5) * Core.WINDOW_WIDTH;
    }

    inline function vertexToPixelSpaceY(v:Float)
    {
        return ((v - 1) * -0.5) * Core.WINDOW_HEIGHT;
    }


    function pixelToVertexSpace(p:Point)
    {
        p.x = pixelToVertexSpaceX(p.x);
        p.y = pixelToVertexSpaceY(p.y);
    }

    inline function pixelToVertexSpaceX(v:Float)
    {
        return (v / Core.WINDOW_WIDTH / 0.5) - 1;
    }

    inline function pixelToVertexSpaceY(v:Float)
    {
        return (v / Core.WINDOW_HEIGHT / -0.5) + 1;
    }

    function get_alpha():Float
    {
        return mask.alpha;
    }

}

class TempBounds
{
    public var bottomLeft = new Point();
	public var topLeft = new Point();
	public var topRight = new Point();
	public var bottomRight = new Point();
	
    public function new()
    {

    }
}