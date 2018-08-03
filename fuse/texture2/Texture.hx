package fuse.texture2;
import fuse.texture2.animated.AnimatedTexture;
import fuse.texture2.color.ColorTexture;
import fuse.texture2.image.BitmapTexture;
import fuse.texture2.image.ImageTexture;
import fuse.texture2.render.RenderTexture;
import fuse.texture2.video.VideoTexture;
import fuse.utils.Color;
import openfl.display.BitmapData;
import openfl.net.NetStream;

/**
 * ...
 * @author P.J.Shand
 */
class Texture implements ITexture
{
	///////////////////////////////////////////////////////////////////////////////////////
	// ATLAS TEXTURES /////////////////////////////////////////////////////////////////////
	
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// IMAGE TEXTURES /////////////////////////////////////////////////////////////////////
	
	static public function fromImage(url:String) 
	{
		return createImageTexture(url);
	}
	
	static public function fromBitmapData(bitmapData:BitmapData) 
	{
		var texture = new BitmapTexture(bitmapData);
		return texture;
	}
	
	static function createImageTexture(url:String):ImageTexture
	{
		var texture = new ImageTexture(url);
		return texture;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	// COLOR TEXTURES /////////////////////////////////////////////////////////////////////
	
	
	static public function fromColor(color:Color) 
	{
		var texture = new ColorTexture(color);
		return texture;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	// RENDER TEXTURES ////////////////////////////////////////////////////////////////////
	
	// Creates a RenderTexture
	public static function createRenderTexture():RenderTexture
	{
		return new RenderTexture();
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	// VIDEO TEXTURES /////////////////////////////////////////////////////////////////////
	
	static function createVideoTexture():VideoTexture
	{
		return new VideoTexture();
	}
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// ANIMATED TEXTURES //////////////////////////////////////////////////////////////////
	static function createAnimatedTexture(frames:Array<ITexture>):AnimatedTexture
	{
		return new AnimatedTexture();
	}
	
	
	
	
	public var textureId:TextureId;
	public var width:Int;
	public var height:Int;
	
	public function new(textureId:TextureId=null) 
	{
		if (textureId == null) this.textureId = TextureId.next;
		else this.textureId = textureId;
		trace("textureId = " + this.textureId);
		
	}
}