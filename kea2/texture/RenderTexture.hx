package kea2.texture;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.core.memory.data.renderTextureData.IRenderTextureData;
import kea2.core.memory.data.renderTextureData.IRenderTextureDrawData;
import kea2.core.memory.data.renderTextureData.RenderTextureData;
import kea2.core.memory.data.renderTextureData.RenderTextureDrawData;
import kea2.core.texture.Textures;
import kea2.display.containers.IDisplay;
import kea2.display.renderables.Image;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
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
	
	public function draw(display:IDisplay) 
	{
		RenderTextureDrawData.OBJECT_POSITION = conductorData.renderTextureCountIndex++;
		renderTextureDrawData.renderTextureId = textureId;
		renderTextureDrawData.displayObjectId = display.objectId;
		
	}
	
	override function upload() 
	{
		nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false, 0);
		//nativeTexture.uploadFromBitmapData(new BitmapData(512, 512, false, 0xFF0000));
		
		//Textures.context3D.setRenderToTexture(nativeTexture, true);
		//Textures.context3D.clear(0, 0, 0, 0);
		clear();
		
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
	}
	
	public function clear(/*clear:Bool, colour:UInt*/) 
	{
		this._clear = true;
		//Textures.context3D.setRenderToTexture(nativeTexture, true);
		//Textures.context3D.clear(0, 0, 0, 0);
		//Textures.context3D.present();
		//Textures.context3D.setRenderToBackBuffer();
	}
	
	/*public function end() 
	{
		
	}*/
}