package kea.logic.buffers.atlas.renderer;
import kea.logic.buffers.atlas.packer.AtlasPartition;
import kea.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
class TextureAtlas
{
	public var texture:Texture;
	public var partitions:Array<AtlasPartition>;
	public var active:Bool = false;
	
	public function new(index:Int) 
	{
		texture = Texture.createRenderTarget(AtlasBuffer.TEMP_WIDTH, AtlasBuffer.TEMP_HEIGHT);
		texture.name = "AtlasTexture" + index;
		texture.g2.begin(true, 0x00FF0000);
		texture.g2.end();
	}
}