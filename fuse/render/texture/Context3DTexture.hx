package fuse.render.texture;

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
	var context3D:Context3D;
	var contextTextureId1 = new Notifier<Int>(-1);
	var contextTextureId2 = new Notifier<Int>(-1);
	var contextTextureId3 = new Notifier<Int>(-1);
	var contextTextureId4 = new Notifier<Int>(-1);
	var contextTextureId5 = new Notifier<Int>(-1);
	var contextTextureId6 = new Notifier<Int>(-1);
	var contextTextureId7 = new Notifier<Int>(-1);
	var contextTextureId8 = new Notifier<Int>(-1);
	var contextTextureIds:Array<Notifier<Int>> = [];
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		
		add(contextTextureId1, SetContextTexture1);
		add(contextTextureId2, SetContextTexture2);
		add(contextTextureId3, SetContextTexture3);
		add(contextTextureId4, SetContextTexture4);
		add(contextTextureId5, SetContextTexture5);
		add(contextTextureId6, SetContextTexture6);
		add(contextTextureId7, SetContextTexture7);
		add(contextTextureId8, SetContextTexture8);
	}
	
	public function clear() 
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
	
	function add(notifier:Notifier<Int>, SetContextTexture:Void -> Void) 
	{
		contextTextureIds.push(notifier);
		notifier.add(SetContextTexture);
	}
	
	function SetContextTexture1():Void { context3D.setTextureAt(0, Textures.getTextureBase(contextTextureId1.value)); }
	function SetContextTexture2():Void { context3D.setTextureAt(1, Textures.getTextureBase(contextTextureId2.value)); }
	function SetContextTexture3():Void { context3D.setTextureAt(2, Textures.getTextureBase(contextTextureId3.value)); }
	function SetContextTexture4():Void { context3D.setTextureAt(3, Textures.getTextureBase(contextTextureId4.value)); }
	function SetContextTexture5():Void { context3D.setTextureAt(4, Textures.getTextureBase(contextTextureId5.value)); }
	function SetContextTexture6():Void { context3D.setTextureAt(5, Textures.getTextureBase(contextTextureId6.value)); }
	function SetContextTexture7():Void { context3D.setTextureAt(6, Textures.getTextureBase(contextTextureId7.value)); }
	function SetContextTexture8():Void { context3D.setTextureAt(7, Textures.getTextureBase(contextTextureId8.value)); }
	
	function setContextTexture(index:Int, textureId:Int) 
	{
		//trace(["setContextTexture", index, textureId]);
		var id:Int = Textures.getTextureId(textureId);
		//trace("id = " + id);
		contextTextureIds[index].value = id;
	}
}