package fuse.core.front.texture;
import fuse.core.front.texture.atlas.AtlasData;

import fuse.core.front.texture.IFrontTexture;
import fuse.core.front.texture.atlas.AtlasData.FrameData;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.display.Image;
/**
 * ...
 * @author P.J.Shand
 */

class FrontSubTexture extends FrontBaseTexture
{
    var parentTexture:IFrontTexture;

    public function new(width:Int, height:Int, parentTexture:IFrontTexture)
    {
        super(width, height, false, /*null, */true, parentTexture.textureId);
        this.parentTexture = parentTexture;
        parentTexture.onUpdate.add(onUpdate.dispatch);
        parentTexture.onUpload.add(onUpload.dispatch);
        parentTexture.onUpload.add(onParentUpdate);
        onParentUpdate();
    }

    function onParentUpdate()
    {
        //textureData.changeCount++;
		this.width = parentTexture.width;
        this.height = parentTexture.height;
		
        setTextureData();
        //textureData.textureAvailable = parentTexture.textureData.textureAvailable;
        
        Fuse.current.workerSetup.updateTexture(objectId);
        Fuse.current.workerSetup.updateTextureSurface(objectId);
    }

    override public function upload() {
		// parent texture will take care of upload
	}
}