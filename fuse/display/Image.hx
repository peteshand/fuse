package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObject;
import fuse.texture.ITexture;


/**
 * ...
 * @author P.J.Shand
 */
class Image extends DisplayObject
{

	public function new(texture:ITexture) 
	{
		super();
		displayType = DisplayType.IMAGE;
		this.width = texture.width;
		this.height = texture.height;
		displayData.textureId = texture.textureId;
	}
}