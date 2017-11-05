package fuse.core.front.buffers;

import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
class BufferTexture extends RenderTexture
{

	public function new(width:Int, height:Int) 
	{
		super(width, height);
		this.directRender = true;
	}
}