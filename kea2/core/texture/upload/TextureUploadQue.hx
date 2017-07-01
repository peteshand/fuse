package kea2.core.texture.upload;
import kea2.texture.ITexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
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