package fuse.texture;

import fuse.core.front.texture.FrontDefaultTexture;
import openfl.display.BitmapData;
import fuse.texture.BaseTexture;

class DefaultTexture extends BaseTexture
{
    public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
        super();
        texture = new FrontDefaultTexture(bitmapData, queUpload, onTextureUploadCompleteCallback);
    }
}