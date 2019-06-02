package fuse.core.backend.display;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;

/**
 * ...
 * @author P.J.Shand
 */
class CoreAtlasCopyFrameImage extends AtlasPartition {
	public function new() {
		super();

		this.x = 0;
		this.y = 0;
		this.width = Fuse.MAX_TEXTURE_SIZE;
		this.height = Fuse.MAX_TEXTURE_SIZE;

		// displayData.width = Fuse.MAX_TEXTURE_SIZE;
		// displayData.height = Fuse.MAX_TEXTURE_SIZE;
		// displayData.scaleX = 1;
		// displayData.scaleY = 1;
		// displayData.alpha = 1;
		// displayData.color = 0x33FF0000;
		// displayData.isStatic = 0;
		// displayData.textureId = this.textureId = textureId;
		// displayData.visible = 1;
		//
		// this.quadData.bottomLeftX = -1;
		// this.quadData.topLeftX = -1;
		// this.quadData.topLeftY = 1;
		// this.quadData.topRightY = 1;
	}
}
