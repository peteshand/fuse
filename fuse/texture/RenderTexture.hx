package fuse.texture;

import fuse.core.communication.data.conductorData.WorkerConductorData;
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
class RenderTexture extends BaseTexture
{
	static var currentRenderTargetId:Int;
	static var conductorData:WorkerConductorData;
	var renderTextureData:IRenderTextureData;
	var renderTextureDrawData:IRenderTextureDrawData;
	
	public function new(width:Int, height:Int, directRender:Bool=true, overTextureId:Null<Int>=null) 
	{
		if (conductorData == null) {
			conductorData = new WorkerConductorData();
		}
		
		super(width, height, false, null, true, overTextureId);
		this.directRender = directRender;
		
		renderTextureData = new RenderTextureData(objectId);
		renderTextureDrawData = new RenderTextureDrawData(0);
	}
	
	public function draw(display:DisplayObject) 
	{
		RenderTextureDrawData.OBJECT_POSITION = conductorData.renderTextureCountIndex++;
		renderTextureDrawData.renderTextureId = objectId;
		renderTextureDrawData.displayObjectId = display.objectId;
		
	}
	
	override function upload() 
	{
		setTextureData();
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(textureData.p2Width, textureData.p2Height, Context3DTextureFormat.BGRA, true, 0);
		
		clear();
		
		Textures.registerTexture(objectId, this);
		textureData.textureAvailable = 1;
	}
	
	public function clear() 
	{
		this._clear = true;
	}
}