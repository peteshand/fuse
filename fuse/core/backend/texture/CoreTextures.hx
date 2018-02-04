package fuse.core.backend.texture;

/**
 * ...
 * @author P.J.Shand
 */

class CoreTextures
{
	public static var texturesHaveChanged:Bool = false;
	
	var texturesMap = new Map<Int, CoreTexture>();
	var textures = new Array<CoreTexture>();
	//var count:Int = 0;
	
	public function new() { }
	
	public function checkForTextureChanges():Void 
	{
		texturesHaveChanged = false;
		for (i in 0...textures.length) {
			if (textures[i].textureHasChanged) {
				//count = -1;
				texturesHaveChanged = true;
			}
		}
		
		//count++;
		//if (count <= 2) {
			//texturesHaveChanged = true;
		//}
		//else {
			//texturesHaveChanged = false;
		//}
	}
	
	public function create(textureId:Int) 
	{
		if (!texturesMap.exists(textureId)) {
			var texture:CoreTexture = new CoreTexture(textureId);
			texturesMap.set(textureId, texture);
			textures.push(texture);
		}
	}
	
	public function dispose(textureId:Int):Void
	{
		if (texturesMap.exists(textureId)) {
			var i:Int = textures.length - 1;
			while (i >= 0) 
			{
				if (textures[i].textureId == textureId) {
					textures.splice(i, 1);
				}
				i--;
			}
			texturesMap.remove(textureId);
		}
	}
	
	public function register(textureId:Int):CoreTexture
	{
		var texture:CoreTexture = texturesMap.get(textureId);
		texture.activeCount++;
		return texture;
	}
	
	public function deregister(textureId:Int) 
	{
		if (texturesMap.exists(textureId)) {
			var texture:CoreTexture = texturesMap.get(textureId);
			texture.activeCount--;
		}
	}
	
	public function clearTextureChanges() 
	{
		for (i in 0...textures.length) 
		{
			textures[i].clearTextureChange();
		}
	}
	
	public function reset() 
	{
		for (i in 0...textures.length) {
			textures[i].uvsHaveChanged = false;
		}
	}
}