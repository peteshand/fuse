package fuse.core.backend.texture;

/**
 * ...
 * @author P.J.Shand
 */
class CoreTextures
{
	var texturesMap = new Map<Int, CoreTexture>();
	var textures = new Array<CoreTexture>();
	var count:Int = 0;
	
	public var texturesHaveChanged(get, null):Bool;
	
	public function new() { }
	
	function get_texturesHaveChanged():Bool 
	{
		for (i in 0...textures.length) 
		{
			if (textures[i].textureHasChanged) {
				count = -1;
			}
		}
		count++;
		if (count <= 2) {
			return true;
		}
		return false;
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
}