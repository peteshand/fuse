package fuse.core.front.texture.upload;
import fuse.texture.IBaseTexture;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class TextureUploadQue
{
	public static var que:Array<IBaseTexture> = [];
	
	public function new() 
	{
		
	}
	
	static public function check() 
	{
		if (que.length > 0) {
			var texture:IBaseTexture = que.shift();
			texture.upload();
		}
	}
	
	static public function add(texture:IBaseTexture) 
	{
		que.push(texture);
	}
	
}