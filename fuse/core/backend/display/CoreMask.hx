
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

        //mask.addMaskOf(display2);
    }

    public function dispose()
    {
        if (mask != null) mask.removeMaskOf(image);

        image = null;
        mask = null;
    }

    public function updateUVs()
    {
        //trace(mask.quadData);
        //trace(image.quadData);
        var offsetBottomLeftX:Float = calcOffsetX(mask.bottomLeftX, image.bottomLeftX);
        var offsetBottomLeftY:Float = calcOffsetY(image.bottomLeftY, mask.bottomLeftY);

        var offsetTopLeftX:Float = calcOffsetX(mask.topLeftX, image.topLeftX);
        var offsetTopLeftY:Float = calcOffsetY(image.topLeftY, mask.topLeftY);

        var offsetTopRightX:Float = calcOffsetX(mask.topRightX, image.topRightX);
        var offsetTopRightY:Float = calcOffsetY(image.topRightY, mask.topRightY);

        var offsetBottomRightX:Float = calcOffsetX(mask.bottomRightX, image.bottomRightX);
        var offsetBottomRightY:Float = calcOffsetY(image.bottomRightY, mask.bottomRightY);
        
        var imageRotated:Bool = image.coreTexture.rotate;
        var maskRotated:Bool = mask.coreTexture.rotate;
        var rotated:Bool = imageRotated || maskRotated;

        trace("imageRotated = " + imageRotated);
        trace("maskRotated = " + maskRotated);
        trace("rotated = " + rotated);
        
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
        
        //trace([mask.coreTexture.uvLeft - offsetBottomLeftX2,	mask.coreTexture.uvBottom - offsetBottomLeftY2]);
        //trace([mask.coreTexture.uvLeft - offsetTopLeftX2,	mask.coreTexture.uvTop - offsetTopLeftY2]);
        //trace([mask.coreTexture.uvRight - offsetTopRightX2, mask.coreTexture.uvTop - offsetTopRightY2]);
        //trace([mask.coreTexture.uvRight - offsetBottomRightX2, mask.coreTexture.uvBottom - offsetBottomRightY2]);
        
        /*if (image.coreTexture.rotate) {
            vertexData.setMaskUV(0, mask.coreTexture.uvLeft - offsetBottomLeftX2,	mask.coreTexture.uvTop - offsetBottomLeftY2);	// bottom left
            vertexData.setMaskUV(1, mask.coreTexture.uvRight - offsetTopLeftX2,	mask.coreTexture.uvTop - offsetTopLeftY2);	// top left
            vertexData.setMaskUV(2, mask.coreTexture.uvRight - offsetTopRightX2, mask.coreTexture.uvBottom - offsetTopRightY2);	// top right
            vertexData.setMaskUV(3, mask.coreTexture.uvLeft - offsetBottomRightX2, mask.coreTexture.uvBottom - offsetBottomRightY2);	// bottom right
        } else {*/
            //vertexData.setMaskUV(0, mask.coreTexture.uvLeft - offsetBottomLeftX2,	mask.coreTexture.uvBottom - offsetBottomLeftY2);	// bottom left
            //vertexData.setMaskUV(1, mask.coreTexture.uvLeft - offsetTopLeftX2,	mask.coreTexture.uvTop - offsetTopLeftY2);	// top left
            //vertexData.setMaskUV(2, mask.coreTexture.uvRight - offsetTopRightX2, mask.coreTexture.uvTop - offsetTopRightY2);	// top right
            //vertexData.setMaskUV(3, mask.coreTexture.uvRight - offsetBottomRightX2, mask.coreTexture.uvBottom - offsetBottomRightY2);	// bottom right
        //}

        /*if (rotated){
        	u[1] = mask.coreTexture.uvLeft - offsetBottomLeftX2;
            u[2] = mask.coreTexture.uvLeft - offsetTopLeftX2;
            u[3] = mask.coreTexture.uvRight - offsetTopRightX2;
            u[0] = mask.coreTexture.uvRight - offsetBottomRightX2;

            v[1] = mask.coreTexture.uvBottom - offsetBottomLeftY2;
            v[2] = mask.coreTexture.uvTop - offsetTopLeftY2;
            v[3] = mask.coreTexture.uvTop - offsetTopRightY2;
            v[0] = mask.coreTexture.uvBottom - offsetBottomRightY2;
        } else {*/
            u[0] = mask.coreTexture.uvLeft - offsetBottomLeftX2;
            u[1] = mask.coreTexture.uvLeft - offsetTopLeftX2;
            u[2] = mask.coreTexture.uvRight - offsetTopRightX2;
            u[3] = mask.coreTexture.uvRight - offsetBottomRightX2;

            v[0] = mask.coreTexture.uvBottom - offsetBottomLeftY2;
            v[1] = mask.coreTexture.uvTop - offsetTopLeftY2;
            v[2] = mask.coreTexture.uvTop - offsetTopRightY2;
            v[3] = mask.coreTexture.uvBottom - offsetBottomRightY2;
        //}

        
        
        
    }

    function calcOffsetX(maskPosX:Float, posX:Float) 
	{
		return (posX - maskPosX) * 0.5 * Fuse.current.stage.stageWidth / mask.coreTexture.textureData.activeData.p2Width / mask.displayData.scaleX;
	}
	
	function calcOffsetY(posY:Float, maskPosY:Float) 
	{
		return (posY - maskPosY) * 0.5 * Fuse.current.stage.stageHeight / mask.coreTexture.textureData.activeData.p2Height / mask.displayData.scaleY;
	}
}