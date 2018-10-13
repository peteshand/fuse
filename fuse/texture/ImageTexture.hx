package fuse.texture;

import fuse.core.front.texture.ImageTexture as FrontImageTexture;

class ImageTexture extends BaseTexture
{
    public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
        super();
        trace("url = " + url);
        texture = new FrontImageTexture(url, width, height, queUpload, onTextureUploadCompleteCallback);
        texture.onUpload.add(() -> {
            trace("onUpload: " + url);
        });
    }
}