package fuse.core.front.texture.upload;
import fuse.texture.IBaseTexture;
import fuse.utils.FrameBudget;

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
		// Upload next texture if:
		// A: There are textures to upload
		// B: No more than 50% of the framebudget has been used
		while (que.length > 0 && FrameBudget.progress < 0.5) 
		{
			var texture:IBaseTexture = que.shift();
			texture.upload();
		}
	}
	
	static public function add(texture:IBaseTexture) 
	{
		que.push(texture);
	}
	
}