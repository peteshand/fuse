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
class Quad extends DisplayObject
{
	public function new(width:Int, height:Int, colour:Color=0xFF333333) 
	{
		super();
		
		this.color = colour;
		this.width = width;
		this.height = height;
		
		displayType = DisplayType.QUAD;
		//displayData.width = width;
		//displayData.height = height;
		//displayData.color = colour;
		displayData.textureId = Textures.whiteId;
	}
}