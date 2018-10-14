package fuse.core.front.texture;
import fuse.core.front.texture.atlas.AtlasData;

import fuse.core.front.texture.ITexture;
import fuse.core.front.texture.atlas.AtlasData.FrameData;
import fuse.core.front.texture.BaseTexture;
import fuse.display.Image;
/**
 * ...
 * @author P.J.Shand
 */

class SubTexture extends BaseTexture
{
    var parentTexture:ITexture;

    public function new(width:Int, height:Int, parentTexture:ITexture)
    {
        super(width, height, false, null, true, parentTexture.textureId);
        this.parentTexture = parentTexture;
        parentTexture.onUpdate.add(onUpdate.dispatch);
        parentTexture.onUpload.add(onUpload.dispatch);
        parentTexture.onUpload.add(onParentUpdate);
        onParentUpdate();
    }

    function onParentUpdate()
    {
        textureData.changeCount++;
		this.width = parentTexture.width;
        this.height = parentTexture.height;
		
        setTextureData();
        textureData.textureAvailable = parentTexture.textureData.textureAvailable;
        Fuse.current.workerSetup.updateTexture(objectId);
    }

    override public function upload() {
		// parent texture will take care of upload
	}
}