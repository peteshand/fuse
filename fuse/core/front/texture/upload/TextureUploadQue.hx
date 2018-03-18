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
	static var count:Int;
	
	public function new() 
	{
		
	}
	
	static public function check() 
	{
		// Upload next texture if:
		// A: There are textures to upload
		// B: No more than 50% of the framebudget has been used, or No textures have been updated in current frame
		count = 0;
		
		//trace("FrameBudget.progress = " + FrameBudget.progress);
		
		while (que.length > 0 && (FrameBudget.progress < 0.5 || count == 0)) 
		{
			//trace(count);
			var texture:IBaseTexture = que.shift();
			texture.upload();
			count++;
		}
	}
	
	static public function add(texture:IBaseTexture) 
	{
		que.push(texture);
	}
	
}