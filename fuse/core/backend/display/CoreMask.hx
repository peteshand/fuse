package fuse.core.backend.display;

import fuse.geom.Point;

class CoreMask
{
    public var image:CoreImage;
    public var mask:CoreImage;
    public var u:Array<Float> = [];
    public var v:Array<Float> = [];
    public var pu:Array<Float> = [];
    public var pv:Array<Float> = [];
    
    var tempBounds = new TempBounds();

    public function new(image:CoreImage, mask:CoreImage)
    {
        this.image = image;
        this.mask = mask;

        //mask.addMaskOf(image);
    }

    public function dispose()
    {
        if (mask != null) mask.removeMaskOf(image);

        image = null;
        mask = null;
    }

    public function updateUVs()
    {
        //var imageRotated:Bool = image.coreTexture.rotate;
        var maskRotated:Bool = mask.coreTexture.rotate;
        //var rotated:Bool = imageRotated || maskRotated;
        
        var rot:Float = 0;
        if (maskRotated){
        	rot = (mask.displayData.rotation + 90) / 180 * Math.PI;
        } else {
            rot = mask.displayData.rotation / 180 * Math.PI;
        }
        //trace([mask.bottomLeftX, image.bottomLeftY]);
        
        tempBounds.bottomLeft.x = mask.bottomLeftX;
        tempBounds.bottomLeft.y = mask.bottomLeftY;
        tempBounds.topLeft.x = mask.topLeftX;
        tempBounds.topLeft.y = mask.topLeftY;
        tempBounds.topRight.x = mask.topRightX;
        tempBounds.topRight.y = mask.topRightY;
        tempBounds.bottomRight.x = mask.bottomRightX;
        tempBounds.bottomRight.y = mask.bottomRightY;

        //trace("removeRotation");
        removeRotation(tempBounds.bottomLeft);
        removeRotation(tempBounds.topLeft);
        removeRotation(tempBounds.topRight);
        removeRotation(tempBounds.bottomRight);
        
        var offsetBottomLeftX:Float = calcOffsetX(tempBounds.bottomLeft.x, image.bottomLeftX, rot);
        var offsetBottomLeftY:Float = calcOffsetY(tempBounds.bottomLeft.y, image.bottomLeftY, rot);

        var offsetTopLeftX:Float = calcOffsetX(tempBounds.topLeft.x, image.topLeftX, rot);
        var offsetTopLeftY:Float = calcOffsetY(tempBounds.topLeft.y, image.topLeftY, rot);

        var offsetTopRightX:Float = calcOffsetX(tempBounds.topRight.x, image.topRightX, rot);
        var offsetTopRightY:Float = calcOffsetY(tempBounds.topRight.y, image.topRightY, rot);

        var offsetBottomRightX:Float = calcOffsetX(tempBounds.bottomRight.x, image.bottomRightX, rot);
        var offsetBottomRightY:Float = calcOffsetY(tempBounds.bottomRight.y, image.bottomRightY, rot);
        
        trace('------');
        /*trace([offsetBottomLeftX, offsetBottomLeftX]);
        trace([offsetTopLeftX, offsetTopLeftY]);
        trace([offsetTopRightX, offsetTopRightY]);
        trace([offsetBottomRightX, offsetBottomRightY]);*/
        
        u[0] = mask.coreTexture.uvLeft + offsetBottomLeftX;
        u[1] = mask.coreTexture.uvLeft + offsetTopLeftX;
        u[2] = mask.coreTexture.uvRight + offsetTopRightX;
        u[3] = mask.coreTexture.uvRight + offsetBottomRightX;

        v[0] = mask.coreTexture.uvBottom - offsetBottomLeftY;
        v[1] = mask.coreTexture.uvTop - offsetTopLeftY;
        v[2] = mask.coreTexture.uvTop - offsetTopRightY;
        v[3] = mask.coreTexture.uvBottom - offsetBottomRightY;

        /*for (i in 0...u.length){
            //pu[i] = u[i];
            //pv[i] = v[i];

            trace(u[i], v[i]);

            pu[i] = vertexToPixelSpaceX(u[i]);
            pv[i] = vertexToPixelSpaceY(v[i]);

            trace(pu[i], pv[i]);
            
            pu[i] = pixelToVertexSpaceX(pu[i]);
            pv[i] = pixelToVertexSpaceY(pv[i]);
            

            u[i] = pu[i];
            v[i] = pv[i];
        }*/
    }

    inline function calcOffsetX(maskPosX:Float, posX:Float, rotation:Float) 
	{
        //var base:Float = (posX - maskPosX) * 0.5;
        //var width:Float = Fuse.current.stage.stageWidth / mask.coreTexture.textureData.activeData.p2Width / (mask.displayData.width / mask.coreTexture.textureData.width);// / mask.displayData.scaleX;
        //var height:Float = Fuse.current.stage.stageHeight / mask.coreTexture.textureData.activeData.p2Height / (mask.displayData.height / mask.coreTexture.textureData.height);// / mask.displayData.scaleY;
        //return (base * Math.cos(rotation / 180 * Math.PI) * width) + (base * Math.sin(rotation / 180 * Math.PI) * height); 

        var difX:Float = posX - maskPosX;
        return difX * 0.5 * Fuse.current.stage.stageWidth / mask.coreTexture.textureData.activeData.p2Width / (mask.displayData.width / mask.coreTexture.textureData.width);// / mask.displayData.scaleX;
	}
	
	inline function calcOffsetY(maskPosY:Float, posY:Float, rotation:Float) 
	{
		//var base:Float = (posY - maskPosY) * 0.5;
        //var width:Float = Fuse.current.stage.stageWidth / mask.coreTexture.textureData.activeData.p2Width / (mask.displayData.width / mask.coreTexture.textureData.width);// / mask.displayData.scaleX;
        //var height:Float = Fuse.current.stage.stageHeight / mask.coreTexture.textureData.activeData.p2Height / (mask.displayData.height / mask.coreTexture.textureData.height);// / mask.displayData.scaleY;
        //return (base * Math.sin(rotation / 180 * Math.PI) * width) + (base * Math.cos(rotation / 180 * Math.PI) * height); 
        
        var difY:Float = posY - maskPosY;
        return difY * 0.5 * Fuse.current.stage.stageHeight / mask.coreTexture.textureData.activeData.p2Height / (mask.displayData.height / mask.coreTexture.textureData.height);// / mask.displayData.scaleY;
	}

    function removeRotation(p:Point)
    {
        var r:Float = Fuse.current.stage.stageWidth / Fuse.current.stage.stageHeight;
        
        vertexToPixelSpace(p);
        
        //trace(p);
        //trace([mask.absoluteX, mask.absoluteY]);

        p.x -= mask.absoluteX;
        p.y -= mask.absoluteY;
        
        //trace(p);
        var h:Float = Math.sqrt(Math.pow(p.x, 2) + Math.pow(p.y, 2));
        //trace(h);
        var currentRot:Float = Math.atan2(p.y, p.x) * 180 / Math.PI;
        //trace("currentRot = " + currentRot);
        var absoluteRotation = mask.absoluteRotation();
        //trace("absoluteRotation = " + absoluteRotation);

        var newRotation:Float = currentRot - absoluteRotation;

        p.x = Math.cos(newRotation / 180 * Math.PI) * h;
        p.y = Math.sin(newRotation / 180 * Math.PI) * h;
        
        p.x += mask.absoluteX;
        p.y += mask.absoluteY;

        pixelToVertexSpace(p);
        
        
        /*
        //trace("r = " + r);
        trace([p.x + 1, p.y - 1]);
        var h:Float = Math.sqrt(Math.pow(p.x + 1, 2) + Math.pow(p.y - 1, 2));
        trace("h = " + h);

        

        var h1:Float = Math.sin(absoluteRotation / 180 * Math.PI) * r * h;
        var h2:Float = Math.cos(absoluteRotation / 180 * Math.PI) * 1 * h;
        trace("h1 = " + h1);
        trace("h2 = " + h2);

        h = h1 + h2;

        trace("h = " + h);
        //trace(h * r);
        
        var currentRot:Float = Math.atan2(p.y - 1, p.x + 1) * 180 / Math.PI;
        trace("currentRot = " + currentRot);
        var offsetX:Float = Math.cos(currentRot / 180 * Math.PI) * h;
        var offsetY:Float = Math.sin(currentRot / 180 * Math.PI) * h;
        trace([offsetX, offsetY]);

        
        var offsetX2:Float = Math.cos((currentRot - absoluteRotation) / 180 * Math.PI) * h;
        var offsetY2:Float = Math.sin((currentRot - absoluteRotation) / 180 * Math.PI) * h;
        trace([offsetX2, offsetY2]);
        
        p.x = (offsetX2 - 1) * 1;
        p.y = (offsetY2 + 1) * 1;
        trace([p.x + 1, p.y - 1]);
        trace('-----');

        // [0,-0.5805128205128205]
        // h = 0.5805128205128205
        */
    }

    function vertexToPixelSpace(p:Point)
    {
        p.x = vertexToPixelSpaceX(p.x);
        p.y = vertexToPixelSpaceY(p.y);
    }

    function vertexToPixelSpaceX(v:Float)
    {
        return ((v + 1) * 0.5) * Fuse.current.stage.stageWidth;
    }

    function vertexToPixelSpaceY(v:Float)
    {
        return ((v - 1) * -0.5) * Fuse.current.stage.stageHeight;
    }


    function pixelToVertexSpace(p:Point)
    {
        p.x = pixelToVertexSpaceX(p.x);
        p.y = pixelToVertexSpaceY(p.y);
    }

    function pixelToVertexSpaceX(v:Float)
    {
        return (v / Fuse.current.stage.stageWidth / 0.5) - 1;
    }

    function pixelToVertexSpaceY(v:Float)
    {
        return (v / Fuse.current.stage.stageHeight / -0.5) + 1;
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