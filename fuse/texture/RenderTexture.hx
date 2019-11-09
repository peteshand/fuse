package fuse.texture;

import fuse.display.DisplayObject;
import fuse.core.front.texture.FrontRenderTexture;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;

class RenderTexture extends BaseTexture {
	var renderTexture:FrontRenderTexture;

	public function new(width:Int, height:Int) {
		super();
		texture = renderTexture = new FrontRenderTexture(width, height);
	}

	public function draw(display:DisplayObject) {
		renderTexture.draw(display);
	}
}
