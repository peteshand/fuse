package kea2.core.atlas.renderer;
import kea2.core.atlas.packer.AtlasPartition;
import kea2.texture.ITexture;
import kea2.texture.RenderTexture;

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