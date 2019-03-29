package fuse.texture;

import openfl.display.BitmapData;
import fuse.core.front.texture.FrontImageTexture;
import fuse.core.front.texture.IFrontTexture;

class ImageTexture extends BaseTexture
{
    static var cache = new Map<String, IFrontTexture>();
    var url:String;
    var imageTexture:FrontImageTexture;
    public var bitmapData(get, null):BitmapData;

    public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null, useCache:Bool=true) 
	{
        super();
        this.url = url;
        if (useCache) texture = cache.get(url);
        if (texture == null){
            texture = imageTexture = new FrontImageTexture(url, width, height, queUpload/*, onTextureUploadCompleteCallback*/);
            cache.set(url, texture);
        }
        if (onTextureUploadCompleteCallback != null){
            texture.onUpload.add(onTextureUploadCompleteCallback);
        }
    }

    function get_bitmapData():BitmapData
    {
        return imageTexture.bitmapData;
    }

    override public function dispose():Void
    {
        cache.remove(url);
        super.dispose();
    }
}