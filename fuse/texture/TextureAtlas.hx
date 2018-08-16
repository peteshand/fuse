package fuse.texture;

import fuse.texture.atlas.AtlasData
/**
 * ...
 * @author P.J.Shand
 */
class TextureAtlas
{
	var parent:IBaseTexture;
	var data:AtlasData;
	var subTextures = new Map<String, IBaseTexture>();
	public function new(texture:IBaseTexture, data:AtlasData) 
	{
		this.parent = texture;
		this.data = data;
	}

	public function getTexture(name:String):IBaseTexture
	{
		for (i in 0...data.frames.length) {
			var frame = data.frames[i];
			if (frame.filename == name) {
				var subTexture = subTextures.get(name);
				if (subTexture == null) {
					subTexture = new SubTexture(parent, frame);
					subTextures.set(name, subTexture);
				}
				return subTexture;
			}
		}
		return null;
	}

	public function getTextures(prefix:String):IBaseTexture
	{
		return null;
	}
}