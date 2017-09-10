package fuse.core.backend.texture;

/**
 * ...
 * @author P.J.Shand
 */
class CoreTextures
{
	var texturesMap = new Map<Int, CoreTexture>();
	
	public function new() { }
	
	public function checkForUpdates():Bool 
	{
		var texturesHaveChanged:Bool = false;
		for (texture in texturesMap) 
		{
			if (texture.checkForUpdate()) {
				texturesHaveChanged = true;
			}
		}
		return texturesHaveChanged;
	}
	
	public function create(textureId:Int) 
	{
		if (!texturesMap.exists(textureId)) {
			var texture:CoreTexture = new CoreTexture(textureId);
			texturesMap.set(textureId, texture);
		}
	}
	
	public function dispose(textureId:Int):Void
	{
		if (texturesMap.exists(textureId)) {
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