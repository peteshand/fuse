package fuse.display;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.front.texture.Textures;
import fuse.display.DisplayObject;
import fuse.utils.Color;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.front.texture.Textures)
class Quad extends Image
{
	public function new(width:Int, height:Int, colour:Color=0xFFFFFFFF) 
	{
		super(null);
		
		this.color = colour;
		this.width = width;
		this.height = height;
		
		displayType = DisplayType.QUAD;
		displayData.textureId = Textures.whiteId;
	}
}