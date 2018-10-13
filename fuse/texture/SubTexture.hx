package fuse.texture;

import fuse.core.front.texture.SubTexture as FrontSubTexture;

class SubTexture extends BaseTexture
{
    var subTexture:FrontSubTexture;

    public function new(frontSubTexture:FrontSubTexture) 
	{
        super();
        texture = subTexture = frontSubTexture;
    }
}