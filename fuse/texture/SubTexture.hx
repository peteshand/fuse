package fuse.texture;

import fuse.texture.atlas.AtlasData.FrameData;
import fuse.texture.BaseTexture;
/**
 * ...
 * @author P.J.Shand
 */

class SubTexture extends BaseTexture
{
    public function new(parentTexture:IBaseTexture, frame:FrameData)
    {
        super(frame.sourceSize.w, frame.sourceSize.h, false, null, true, parentTexture.textureId);
    }
}