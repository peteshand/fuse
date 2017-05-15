package kea.texture;

import kha.Image;
import kha.graphics4.DepthStencilFormat;
import kha.graphics4.TextureFormat;
import flash.display.BitmapData;
import haxe.Timer;
import kha.graphics4.Usage;
import kea.display.IDisplay;
import kea.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */
@:forward(
	width, 
	height,
	name,
	g2,
	readable,
	data
)
abstract Texture(Image) from Image to Image 
{
	inline public function new(width:Int, height:Int, format:TextureFormat, renderTarget:Bool, depthStencil:DepthStencilFormat, readable:Bool) {
		this = new Image(width, height, format, renderTarget, depthStencil, readable);
	}
	
	inline public static function createRenderTarget(width:Int, height:Int, format:TextureFormat = null, depthStencil:DepthStencilFormat = DepthStencilFormat.NoDepthAndStencil, antiAliasingSamples:Int = 1, contextId:Int = 0):Texture {
		return Image.createRenderTarget(width, height, format, depthStencil, antiAliasingSamples, contextId);
	}
	
	public static function fromBitmapData(bmd:BitmapData, readable:Bool, name:String = null, queUpload:Bool=true):Texture
	{
		var texture:Texture = null;
		if (queUpload) {
			texture = Image.create(bmd.width, bmd.height, TextureFormat.RGBA32, Usage.DynamicUsage);
			TextureHelper.que.set(texture, { texture:texture, bmd:bmd, readable:readable, name:name, displays:[] } );
		}
		else {
			texture = Image.fromBitmapData(bmd, readable);
		}
		return texture;
	}
}

typedef FromBitmapData =
{
	texture:Image,
	bmd:BitmapData,
	readable:Bool,
	name:String,
	displays:Array<ChildParent>
}

typedef ChildParent =
{
	child:IDisplay,
	parent:Sprite,
	index:Int
}