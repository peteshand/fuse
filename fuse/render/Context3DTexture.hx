package fuse.render;

import openfl.display3D.Context3D;
import fuse.core.front.texture.Textures;
import openfl.display3D.textures.TextureBase;

//#if air||flash
import fuse.utils.Notifier;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.utils.Notifier)
@:access(openfl.display3D.Context3D)
class Context3DTexture
{
	static var context3D:Context3D;
	static var contextTextureId1 = new Notifier<TextureBase>();
	static var contextTextureId2 = new Notifier<TextureBase>();
	static var contextTextureId3 = new Notifier<TextureBase>();
	static var contextTextureId4 = new Notifier<TextureBase>();
	static var contextTextureId5 = new Notifier<TextureBase>();
	static var contextTextureId6 = new Notifier<TextureBase>();
	static var contextTextureId7 = new Notifier<TextureBase>();
	static var contextTextureId8 = new Notifier<TextureBase>();
	static var contextTextureIds:Array<Notifier<TextureBase>> = [];
	
	public static function init(context3D:Context3D) 
	{
		Context3DTexture.context3D = context3D;
		add(contextTextureId1, SetContextTexture1);
		add(contextTextureId2, SetContextTexture2);
		add(contextTextureId3, SetContextTexture3);
		add(contextTextureId4, SetContextTexture4);
		add(contextTextureId5, SetContextTexture5);
		add(contextTextureId6, SetContextTexture6);
		add(contextTextureId7, SetContextTexture7);
		add(contextTextureId8, SetContextTexture8);
	}
	
	public static function clear() 
	{
		contextTextureId1._value = null;
		contextTextureId2._value = null;
		contextTextureId3._value = null;
		contextTextureId4._value = null;
		contextTextureId4._value = null;
		contextTextureId5._value = null;
		contextTextureId6._value = null;
		contextTextureId7._value = null;
	}
	
	static function add(notifier:Notifier<TextureBase>, SetContextTexture:Void -> Void) 
	{
		contextTextureIds.push(notifier);
		notifier.add(SetContextTexture);
	}
	
	static function SetContextTexture1():Void { context3D.setTextureAt(0, contextTextureId1.value); }
	static function SetContextTexture2():Void { context3D.setTextureAt(1, contextTextureId2.value); }
	static function SetContextTexture3():Void { context3D.setTextureAt(2, contextTextureId3.value); }
	static function SetContextTexture4():Void { context3D.setTextureAt(3, contextTextureId4.value); }
	static function SetContextTexture5():Void { context3D.setTextureAt(4, contextTextureId5.value); }
	static function SetContextTexture6():Void { context3D.setTextureAt(5, contextTextureId6.value); }
	static function SetContextTexture7():Void { context3D.setTextureAt(6, contextTextureId7.value); }
	static function SetContextTexture8():Void { context3D.setTextureAt(7, contextTextureId8.value); }
	
	public static function setContextTexture(index:Int, textureId:Int) 
	{
		var id:Null<Int> = Textures.getTextureId(textureId);
		var sampler = Textures.getTextureBase(id);
		contextTextureIds[index].value = sampler;
		#if html5
			// Hack to get around a bug in lime/openfl where video textures don't update
			context3D.__samplerDirty |= (1 << untyped sampler);
		#end
	}
}
//#else
//class Context3DTexture
//{
	//static var context3D:Context3D;
	//
	//public static function init(context3D:Context3D) 
	//{
		//Context3DTexture.context3D = context3D;
	//}
	//
	//public static function clear() 
	//{
		//
	//}
	//
	//public static function setContextTexture(index:Int, textureId:Int) 
	//{
		//var id:Null<Int> = Textures.getTextureId(textureId);
		//context3D.setTextureAt(index, Textures.getTextureBase(id));
	//}
//}
//#end