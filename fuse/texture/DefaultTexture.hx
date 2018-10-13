package fuse.texture;

import fuse.core.front.texture.DefaultTexture as FrontDefaultTexture;
import openfl.display.BitmapData;

class DefaultTexture extends BaseTexture
{
    public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
        super();
        texture = new FrontDefaultTexture(bitmapData, queUpload, onTextureUploadCompleteCallback);
    }
}