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

@:forward(textureData, nativeTexture, textureBase, textureId, width, height, onUpdate, clearColour, _clear, _alreadyClear, upload, dispose, directRender)
abstract RenderTexture(AbstractTexture) to Int from Int 
{
	var baseRenderTexture(get, never):BaseRenderTexture;
	
	public function new(width:Int, height:Int, directRender:Bool=true) 
	{
		var baseRenderTexture = new BaseRenderTexture(AbstractTexture.textureIdCount++, width, height, directRender);
		this = new AbstractTexture(baseRenderTexture, baseRenderTexture.textureId);
	}
	
	function upload():Void										{ baseRenderTexture.upload(); 					}
	function get_baseRenderTexture():BaseRenderTexture			{ return untyped this.coreTexture; 				}
	@:to public function toAbstractTexture():AbstractTexture	{ return this; 									}
}


@:access(fuse)
class BaseRenderTexture extends BaseTexture
{
	static var currentRenderTargetId:Int;
	static var conductorData:WorkerConductorData;
	var renderTextureData:IRenderTextureData;
	var renderTextureDrawData:IRenderTextureDrawData;
	
	public function new(textureId:Int, width:Int, height:Int, directRender:Bool=true) 
	{
		if (conductorData == null) {
			conductorData = new WorkerConductorData();
		}
		
		super(textureId, width, height, false);
		this.directRender = directRender;
		
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
		setTextureData();
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, true, 0);
		
		clear();
		
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
	}
	
	public function clear() 
	{
		this._clear = true;
	}
}