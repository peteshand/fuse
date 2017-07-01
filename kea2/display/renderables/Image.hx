package kea2.display.renderables;

import kea2.texture.ITexture;


/**
 * ...
 * @author P.J.Shand
 */
class Image extends Renderable
{

	public function new(texture:ITexture) 
	{
		super();
		this.width = texture.width;
		this.height = texture.height;
		this.color = 0xFFFF0000;
		displayData.textureId = texture.textureId;
	}
}