package fuse.texture;

import fuse.core.front.texture.FrontBitmapTexture;
import openfl.display.BitmapData;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;

class BitmapTexture extends BaseTexture
{
    var bitmapTexture:FrontBitmapTexture;

    public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null, _textureId:Null<TextureId> = null, _objectId:Null<ObjectId> = null) 
	{
        super();
        texture = bitmapTexture = new FrontBitmapTexture(bitmapData, width, height, queUpload, onTextureUploadCompleteCallback, _textureId, _objectId);
    }

    public function update(source:BitmapData)
    {
        bitmapTexture.update(source);
    }
}