package fuse.core.backend.texture;

import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.front.texture.TextureRef;

/**
 * ...
 * @author P.J.Shand
 */
class CoreRenderTexture extends CoreTexture {
	var rootDisplays = new Array<CoreDisplayObject>();

	public function new(textureRef:TextureRef) {
		super(textureRef);
	}

	public function addDisplay(display:CoreDisplayObject) {
		rootDisplays.push(display);
	}
}
