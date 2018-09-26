package fuse.texture;

import fuse.texture.atlas.AtlasData.FrameData;
import fuse.texture.BaseTexture;
/**
 * ...
 * @author P.J.Shand
 */

class SubTexture extends BaseTexture
{
    var parentTexture:ITexture;

    public function new(width:Int, height:Int, parentTexture:ITexture/*, frame:FrameData*/)
    {
        //super(frame.sourceSize.w, frame.sourceSize.h, false, null, true, parentTexture.objectId);
        super(width, height, false, null, true, parentTexture.textureId);
        parentTexture.onUpload.add(onParentUpdate);
        this.parentTexture = parentTexture;
    }

    function onParentUpdate()
    {
        textureData.changeCount++;
		//textureData.placed = 0;
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