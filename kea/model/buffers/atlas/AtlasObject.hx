package kea.model.buffers.atlas;
import kea.texture.Texture;


class AtlasObject
{
	public var base:Texture;
	public var texture:Texture;
	public var x:Int = 0;
	public var y:Int = 0;
	
	public function new(base:Texture) {
		this.base = base;
	}
}
