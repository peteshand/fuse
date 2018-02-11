package fuse.render;

import fuse.utils.Notifier;
import fuse.core.front.texture.Textures;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.utils.Notifier)
class Context3DTexture
{
	static var context3D:Context3D;
	static var contextTextureId1 = new Notifier<Int>(-1);
	static var contextTextureId2 = new Notifier<Int>(-1);
	static var contextTextureId3 = new Notifier<Int>(-1);
	static var contextTextureId4 = new Notifier<Int>(-1);
	static var contextTextureId5 = new Notifier<Int>(-1);
	static var contextTextureId6 = new Notifier<Int>(-1);
	static var contextTextureId7 = new Notifier<Int>(-1);
	static var contextTextureId8 = new Notifier<Int>(-1);
	static var contextTextureIds:Array<Notifier<Int>> = [];
	
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
		contextTextureId1._value = -1;
		contextTextureId2._value = -1;
		contextTextureId3._value = -1;
		contextTextureId4._value = -1;
		contextTextureId4._value = -1;
		contextTextureId5._value = -1;
		contextTextureId6._value = -1;
		contextTextureId7._value = -1;
		
		context3D.setTextureAt(0, null);
		context3D.setTextureAt(1, null);
		context3D.setTextureAt(2, null);
		context3D.setTextureAt(3, null);
		context3D.setTextureAt(4, null);
		context3D.setTextureAt(5, null);
		context3D.setTextureAt(6, null);
		context3D.setTextureAt(7, null);
	}
	
	static function add(notifier:Notifier<Int>, SetContextTexture:Void -> Void) 
	{
		contextTextureIds.push(notifier);
		notifier.add(SetContextTexture);
	}
	
	static function SetContextTexture1():Void { context3D.setTextureAt(0, Textures.getTextureBase(contextTextureId1.value)); }
	static function SetContextTexture2():Void { context3D.setTextureAt(1, Textures.getTextureBase(contextTextureId2.value)); }
	static function SetContextTexture3():Void { context3D.setTextureAt(2, Textures.getTextureBase(contextTextureId3.value)); }
	static function SetContextTexture4():Void { context3D.setTextureAt(3, Textures.getTextureBase(contextTextureId4.value)); }
	static function SetContextTexture5():Void { context3D.setTextureAt(4, Textures.getTextureBase(contextTextureId5.value)); }
	static function SetContextTexture6():Void { context3D.setTextureAt(5, Textures.getTextureBase(contextTextureId6.value)); }
	static function SetContextTexture7():Void { context3D.setTextureAt(6, Textures.getTextureBase(contextTextureId7.value)); }
	static function SetContextTexture8():Void { context3D.setTextureAt(7, Textures.getTextureBase(contextTextureId8.value)); }
	
	public static function setContextTexture(index:Int, textureId:Int) 
	{
		//trace(["setContextTexture", index, textureId]);
		var id:Int = Textures.getTextureId(textureId);
		//trace("id = " + id);
		contextTextureIds[index].value = id;
	}
}