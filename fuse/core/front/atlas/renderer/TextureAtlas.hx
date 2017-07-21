package fuse.core.front.atlas.renderer;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.texture.ITexture;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
class TextureAtlas
{
	public var texture:RenderTexture;
	public var partitions:Array<AtlasPartition>;
	public var active:Bool = false;
	
	public function new(index:Int) 
	{
		/*texture = Texture.createRenderTarget(AtlasBuffer.TEMP_WIDTH, AtlasBuffer.TEMP_HEIGHT);
		texture.name = "AtlasTexture" + index;
		texture.g2.begin(true, 0x00FF0000);
		texture.g2.end();*/
		
		texture = new RenderTexture(AtlasBuffer.TEMP_WIDTH, AtlasBuffer.TEMP_HEIGHT);
		texture.name = "AtlasTexture" + index;
		texture.begin(true, 0x00FF0000);
		texture.end();
	}
}