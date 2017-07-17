package fuse.render.texture;
import fuse.core.texture.Textures;
import fuse.utils.Notifier;
import openfl.display3D.Context3D;
import openfl.display3D.textures.Texture;

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
		
		contextTextureIds.push(contextTextureId1);
		contextTextureIds.push(contextTextureId2);
		contextTextureIds.push(contextTextureId3);
		contextTextureIds.push(contextTextureId4);
		
		contextTextureId1.add(SetContextTexture1);
		contextTextureId2.add(SetContextTexture2);
		contextTextureId3.add(SetContextTexture3);
		contextTextureId4.add(SetContextTexture4);
	}
	
	function SetContextTexture1() {
		//trace("SetContextTexture1 = " + contextTextureId1.value);
		context3D.setTextureAt(0, Textures.getTexture(contextTextureId1.value).nativeTexture);
	}
	
	function SetContextTexture2() {
		//trace("SetContextTexture2 = " + contextTextureId2.value);
		context3D.setTextureAt(1, Textures.getTexture(contextTextureId2.value).nativeTexture);
	}
	
	function SetContextTexture3() {
		//trace("SetContextTexture3 = " + contextTextureId3.value);
		context3D.setTextureAt(2, Textures.getTexture(contextTextureId3.value).nativeTexture);
	}
	
	function SetContextTexture4() {
		//trace("SetContextTexture4 = " + contextTextureId4.value);
		context3D.setTextureAt(3, Textures.getTexture(contextTextureId4.value).nativeTexture);
	}
	
	function setContextTexture(index:Int, textureId:Int) 
	{
		contextTextureIds[index].value = Textures.getTextureId(textureId);
	}
}