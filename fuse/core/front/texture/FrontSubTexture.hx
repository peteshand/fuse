package fuse.core.front.texture;

import fuse.core.front.texture.atlas.AtlasData;
import fuse.core.front.texture.IFrontTexture;
import fuse.core.front.texture.atlas.AtlasData.FrameData;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.display.Image;
import fuse.utils.PowerOfTwo;

/**
 * ...
 * @author P.J.Shand
 */
class FrontSubTexture extends FrontBaseTexture {
	var parentTexture:IFrontTexture;

	// var scaleU:Float;
	// var scaleV:Float;

	public function new(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float, parentTexture:IFrontTexture) {
		super(parentTexture.width, parentTexture.height, false, /*null, */ true, parentTexture.textureId);

		this.parentTexture = parentTexture;
		this.offsetU = offsetU;
		this.offsetV = offsetV;
		this.scaleU = scaleU;
		this.scaleV = scaleV;

		parentTexture.onUpdate.add(onUpdate.dispatch);
		parentTexture.onUpload.add(onUpload.dispatch);
		parentTexture.onUpload.add(onParentUpdate);
		onParentUpdate();
	}

	function onParentUpdate() {
		// textureData.changeCount++;
		// this.width = Math.floor(parentTexture.width * scaleU);
		// this.height = Math.floor(parentTexture.height * scaleV);

		setTextureData();
		// textureData.textureAvailable = parentTexture.textureData.textureAvailable;

		Fuse.current.workerSetup.updateTexture(objectId);
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}

	override function get_width():Null<Int> {
		return Math.floor(width * scaleU);
	}

	override function get_height():Null<Int> {
		return Math.floor(height * scaleV);
	}

	override function setTextureData() {
		textureData.x = 0;
		textureData.y = 0;
		textureData.width = Math.floor(width / scaleU);
		textureData.height = Math.floor(height / scaleV);

		if (p2Texture) {
			textureData.p2Width = PowerOfTwo.getNextPowerOfTwo(Math.floor(width / scaleU));
			textureData.p2Height = PowerOfTwo.getNextPowerOfTwo(Math.floor(height / scaleV));
		} else {
			textureData.p2Width = Math.floor(width / scaleU);
			textureData.p2Height = Math.floor(height / scaleV);
		}

		textureData.offsetU = offsetU;
		textureData.offsetV = offsetV;
		textureData.scaleU = scaleU;
		textureData.scaleV = scaleV;

		// textureData.textureAvailable = 0;
		textureData.persistent = persistent;
		Fuse.current.workerSetup.updateTexture(objectId);
		onUpdate.dispatch();
	}

	override public function upload() {
		// parent texture will take care of upload
	}
}
