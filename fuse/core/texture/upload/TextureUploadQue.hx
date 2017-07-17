package fuse.core.texture.upload;
import fuse.texture.ITexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class TextureUploadQue
{
	public static var que:Array<ITexture> = [];
	
	public function new() 
	{
		
	}
	
	static public function check() 
	{
		if (que.length > 0) {
			var texture:ITexture = que.shift();
			texture.upload();
		}
	}
	
	static public function add(texture:ITexture) 
	{
		que.push(texture);
	}
	
}