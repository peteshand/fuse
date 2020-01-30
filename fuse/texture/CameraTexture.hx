#if html5
package fuse.texture;

import openfl.media.Camera;
import fuse.core.front.texture.FrontCameraTexture;

class CameraTexture extends BaseTexture {
	var cameraTexture:FrontCameraTexture;

	public function new(camera:Camera) {
		super();
		texture = cameraTexture = new FrontCameraTexture(camera);
	}

	public function update() {
		cameraTexture.update();
	}
}
#end
