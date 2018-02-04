package fuse.core.backend.display;
import fuse.core.communication.data.displayData.DisplayData;

/**
 * ...
 * @author P.J.Shand
 */
class CoreCacheLayerImage extends CoreImage
{

	public function new(textureId:Int) 
	{
		super();
		
		displayData = new DisplayData( -1);
		displayData.width = Fuse.MAX_TEXTURE_SIZE;
		displayData.height = Fuse.MAX_TEXTURE_SIZE;
		displayData.scaleX = 1;
		displayData.scaleY = 1;
		displayData.alpha = 1;
		displayData.color = 0x33FF0000;
		displayData.isStatic = 0;
		displayData.textureId = this.textureId = textureId;
		displayData.visible = 1;
		
		this.quadData.bottomLeftX = -1;
		this.quadData.topLeftX = -1;
		this.quadData.topLeftY = 1;
		this.quadData.topRightY = 1;
	}
	
	public function update() 
	{
		this.isStatic = 0;
		
		this.quadData.bottomLeftY = -minY();
		this.quadData.topRightX = maxX();
		this.quadData.bottomRightX = maxX();
		this.quadData.bottomRightY = -minY();
	}
	
	inline function maxX():Float
	{
		return (Fuse.MAX_TEXTURE_SIZE / Fuse.current.stage.stageWidth * 2) - 1;
	}
	
	inline function minY():Float
	{
		return (Fuse.MAX_TEXTURE_SIZE / Fuse.current.stage.stageHeight * 2) - 1;
	}
}