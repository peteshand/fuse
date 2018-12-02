
package fuse.core.backend.display;

class CoreMask
{
    public var image:CoreImage;
    public var mask:CoreImage;
    public var u:Array<Float> = [];
    public var v:Array<Float> = [];
    
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
        var offsetBottomLeftX:Float = calcOffsetX(mask.bottomLeftX, image.bottomLeftX);
        var offsetBottomLeftY:Float = calcOffsetY(mask.bottomLeftY, image.bottomLeftY);

        var offsetTopLeftX:Float = calcOffsetX(mask.topLeftX, image.topLeftX);
        var offsetTopLeftY:Float = calcOffsetY(mask.topLeftY, image.topLeftY);

        var offsetTopRightX:Float = calcOffsetX(mask.topRightX, image.topRightX);
        var offsetTopRightY:Float = calcOffsetY(mask.topRightY, image.topRightY);

        var offsetBottomRightX:Float = calcOffsetX(mask.bottomRightX, image.bottomRightX);
        var offsetBottomRightY:Float = calcOffsetY(mask.bottomRightY, image.bottomRightY);
        
        //var imageRotated:Bool = image.coreTexture.rotate;
        var maskRotated:Bool = mask.coreTexture.rotate;
        //var rotated:Bool = imageRotated || maskRotated;
        
        var rot:Float = 0;
        if (maskRotated){
        	rot = (mask.displayData.rotation + 90) / 180 * Math.PI;
        } else {
            rot = mask.displayData.rotation / 180 * Math.PI;
        }

        
        var offsetBottomLeftX2:Float = (offsetBottomLeftX * -Math.cos(rot)) + (offsetBottomLeftY * Math.sin(rot));
        var offsetBottomLeftY2:Float = (offsetBottomLeftX * Math.sin(rot)) + (offsetBottomLeftY * Math.cos(rot));
        var offsetTopLeftX2:Float = (offsetTopLeftX * -Math.cos(rot)) + (offsetTopLeftY * Math.sin(rot));
        var offsetTopLeftY2:Float =  (offsetTopLeftX * Math.sin(rot)) + (offsetTopLeftY * Math.cos(rot));
        var offsetTopRightX2:Float = (offsetTopRightX * -Math.cos(rot)) + (offsetTopRightY * Math.sin(rot));
        var offsetTopRightY2:Float =  (offsetTopRightX * Math.sin(rot)) + (offsetTopRightY * Math.cos(rot));
        var offsetBottomRightX2:Float = (offsetBottomRightX * -Math.cos(rot)) + (offsetBottomRightY * Math.sin(rot));
        var offsetBottomRightY2:Float =  (offsetBottomRightX * Math.sin(rot)) + (offsetBottomRightY * Math.cos(rot));
        
        
        u[0] = mask.coreTexture.uvLeft - offsetBottomLeftX2;
        u[1] = mask.coreTexture.uvLeft - offsetTopLeftX2;
        u[2] = mask.coreTexture.uvRight - offsetTopRightX2;
        u[3] = mask.coreTexture.uvRight - offsetBottomRightX2;

        v[0] = mask.coreTexture.uvBottom - offsetBottomLeftY2;
        v[1] = mask.coreTexture.uvTop - offsetTopLeftY2;
        v[2] = mask.coreTexture.uvTop - offsetTopRightY2;
        v[3] = mask.coreTexture.uvBottom - offsetBottomRightY2;
    }

    inline function calcOffsetX(maskPosX:Float, posX:Float) 
	{
        //trace(mask.displayData.width / mask.coreTexture.textureData.width);
        //trace(mask.displayData.scaleX);
		return (posX - maskPosX) * 0.5 * Fuse.current.stage.stageWidth / mask.coreTexture.textureData.activeData.p2Width / (mask.displayData.width / mask.coreTexture.textureData.width);// / mask.displayData.scaleX;
	}
	
	inline function calcOffsetY(maskPosY:Float, posY:Float) 
	{
		return (posY - maskPosY) * 0.5 * Fuse.current.stage.stageHeight / mask.coreTexture.textureData.activeData.p2Height / (mask.displayData.height / mask.coreTexture.textureData.height);// / mask.displayData.scaleY;
	}
}