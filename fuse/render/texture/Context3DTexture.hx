package fuse.render.texture;

import fuse.utils.Notifier;
import fuse.core.front.texture.Textures;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class Context3DTexture
{
	var context3D:Context3D;
	var contextTextureId1 = new Notifier<Int>(-1);
	var contextTextureId2 = new Notifier<Int>(-1);
	var contextTextureId3 = new Notifier<Int>(-1);
	var contextTextureId4 = new Notifier<Int>(-1);
	var contextTextureIds:Array<Notifier<Int>> = [];
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		
		add(contextTextureId1, SetContextTexture1);
		add(contextTextureId2, SetContextTexture2);
		add(contextTextureId3, SetContextTexture3);
		add(contextTextureId4, SetContextTexture4);
		
		//contextTextureIds.push(contextTextureId1);
		//contextTextureIds.push(contextTextureId2);
		//contextTextureIds.push(contextTextureId3);
		//contextTextureIds.push(contextTextureId4);
		//
		//contextTextureId1.add(SetContextTexture1);
		//contextTextureId2.add(SetContextTexture2);
		//contextTextureId3.add(SetContextTexture3);
		//contextTextureId4.add(SetContextTexture4);
	}
	
	function add(notifier:Notifier<Int>, SetContextTexture:Void -> Void) 
	{
		contextTextureIds.push(notifier);
		notifier.add(SetContextTexture);
	}
	
	function SetContextTexture1():Void { context3D.setTextureAt(0, Textures.getTexture(contextTextureId1.value).nativeTexture); }
	function SetContextTexture2():Void { context3D.setTextureAt(1, Textures.getTexture(contextTextureId2.value).nativeTexture); }
	function SetContextTexture3():Void { context3D.setTextureAt(2, Textures.getTexture(contextTextureId3.value).nativeTexture); }
	function SetContextTexture4():Void { context3D.setTextureAt(3, Textures.getTexture(contextTextureId4.value).nativeTexture); }
	
	function setContextTexture(index:Int, textureId:Int) 
	{
		contextTextureIds[index].value = Textures.getTextureId(textureId);
	}
}