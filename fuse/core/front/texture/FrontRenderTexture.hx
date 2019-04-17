package fuse.core.front.texture;

import fuse.core.front.texture.FrontBaseTexture;
import fuse.texture.TextureId;
import fuse.utils.ObjectId;
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
class FrontRenderTexture extends FrontBaseTexture
{
	static var currentRenderTargetId:Int;
	static var conductorData:WorkerConductorData;
	var renderTextureData:IRenderTextureData;
	var renderTextureDrawData:IRenderTextureDrawData;
	
	public function new(width:Int, height:Int, directRender:Bool=true, _textureId:Null<TextureId> = null, _objectId:Null<ObjectId> = null) 
	{
		if (conductorData == null) {
			conductorData = new WorkerConductorData();
		}
		
		super(width, height, false, /*null, */true, _textureId, _objectId);
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
		
		Textures.registerTexture(textureId, this);
		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}
	
	public function clear() 
	{
		this._clear = true;
	}
}