package fuse.texture;

import fuse.core.front.texture.ImageTexture as FrontImageTexture;
import fuse.core.front.texture.ITexture as FrontITexture;

class ImageTexture extends BaseTexture
{
    static var cache = new Map<String, FrontITexture>();

    public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
        super();
        texture = cache.get(url);
        if (texture == null){
            texture = new FrontImageTexture(url, width, height, queUpload, onTextureUploadCompleteCallback);
            cache.set(url, texture);
        }
    }
}