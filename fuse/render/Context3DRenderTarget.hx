package fuse.render;
import fuse.core.front.texture.Textures;
import fuse.texture.IBaseTexture;
import fuse.utils.Notifier;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class Context3DRenderTarget
{
	static private var context3D:Context3D;
	public static var targetTextureId:Notifier<Int>;
	@:isVar public static var value(default, set):Int;
	
	static function init(context3D:Context3D) 
	{
		Context3DRenderTarget.context3D = context3D;
		targetTextureId = new Notifier<Int>(-2);
		targetTextureId.add(OnTargetTextureIdChange);
	}
	
	static public function begin() 
	{
		targetTextureId.value = -1;
	}
	
	static function OnTargetTextureIdChange() 
	{
		//trace("targetTextureId.value = " + targetTextureId.value);
		if (targetTextureId.value == -1) {
			#if air
				context3D.setRenderToTexture(null, false, 0, 0, 0);
			#else
				context3D.setRenderToBackBuffer();
			#end
		}
		else {
			var texture:IBaseTexture = Textures.getTexture(targetTextureId.value);
			#if air
				context3D.setRenderToTexture(texture.textureBase, false, 0, 0, 0);
			#else
				context3D.setRenderToTexture(texture.textureBase, false, 0, 0);
			#end
			
			//if (texture._clear || texture._alreadyClear || currentBatchData.clearRenderTarget == 1) {
				texture._clear = false;
				//context3D.clear(texture.clearColour.red, texture.clearColour.green, texture.clearColour.blue, 0);
				context3D.clear(0, 0, 0, 0);
			//}
			//else {
				//context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.DEPTH);
			//}
			
			//context3D.clear(Math.random(), Math.random(), Math.random(), 1);
		}
	}
	
	static public function clear() 
	{
		targetTextureId.value = -2;
	}
	
	static function set_value(v:Int):Int 
	{
		return targetTextureId.value = value = v;
	}
}