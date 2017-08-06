package fuse.texture;

import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.renderTextureData.IRenderTextureData;
import fuse.core.communication.data.renderTextureData.IRenderTextureDrawData;
import fuse.core.communication.data.renderTextureData.RenderTextureData;
import fuse.core.communication.data.renderTextureData.RenderTextureDrawData;
import fuse.core.front.texture.Textures;
import fuse.display.DisplayObject;
import openfl.display3D.Context3DTextureFormat;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class RenderTexture extends Texture
{
	static var currentRenderTargetId:Int;
	static var conductorData:ConductorData;
	var renderTextureData:IRenderTextureData;
	var renderTextureDrawData:IRenderTextureDrawData;
	
	public function new(width:Int, height:Int) 
	{
		if (conductorData == null) {
			conductorData = new ConductorData();
		}
		
		this.width = width;
		this.height = height;
		
		super(false);
		
		renderTextureData = new RenderTextureData(textureId);
		renderTextureDrawData = new RenderTextureDrawData(0);
	}
	
	public function draw(display:DisplayObject) 
	{
		RenderTextureDrawData.OBJECT_POSITION = conductorData.renderTextureCountIndex++;
		renderTextureDrawData.renderTextureId = textureId;
		renderTextureDrawData.displayObjectId = display.objectId;
		
	}
	
	override function upload() 
	{
		nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false, 0);
		
		clear();
		
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
	}
	
	public function clear() 
	{
		this._clear = true;
	}
}