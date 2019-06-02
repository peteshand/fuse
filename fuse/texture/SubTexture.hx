package fuse.texture;

import fuse.core.front.texture.FrontSubTexture;

class SubTexture extends BaseTexture {
	var subTexture:FrontSubTexture;

	public function new(frontSubTexture:FrontSubTexture) {
		super();
		texture = subTexture = frontSubTexture;
	}
}
