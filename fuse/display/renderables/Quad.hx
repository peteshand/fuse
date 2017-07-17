package fuse.display.renderables;

/**
 * ...
 * @author P.J.Shand
 */
class Quad extends Renderable
{
	public function new(width:Int, height:Int, colour:UInt) 
	{
		super();
		displayData.width = width;
		displayData.height = height;
		displayData.color = colour;
	}
}