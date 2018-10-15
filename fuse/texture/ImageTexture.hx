package fuse.texture;

import fuse.core.front.texture.FrontImageTexture;
import fuse.core.front.texture.IFrontTexture;

class ImageTexture extends BaseTexture
{
    static var cache = new Map<String, IFrontTexture>();

    public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null, useCache:Bool=true) 
	{
        super();
        if (useCache) texture = cache.get(url);
        if (texture == null){
            texture = new FrontImageTexture(url, width, height, queUpload, onTextureUploadCompleteCallback);
            cache.set(url, texture);
        }
    }
}