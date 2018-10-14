package fuse.texture;

import fuse.core.front.texture.Scale9Texture as FrontScale9Texture;
import openfl.display.BitmapData;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;

class Scale9Texture extends BaseTexture
{
    var frontScale9Texture:FrontScale9Texture;

    public function new(texture:ITexture, scale9Grid:Rectangle) 
	{
        super();
        texture = frontScale9Texture = new FrontScale9Texture(texture, scale9Grid);
    }
}