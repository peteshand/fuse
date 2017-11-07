package fuse.display;

import fuse.texture.ITexture;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture)
class MovieClip extends Image
{
	var textures:Array<ITexture>;
	var tick:Int = 0;
	var normalized:Float = 0;
	@:isVar var frame(get, set):Int = 0;
	
	public function new(textures:Array<ITexture>, fsp:Int=24) 
	{
		this.textures = textures;
		if (textures == null || textures.length == 0) {
			throw new Error("One or more textures must be past");
		}
		super(textures[0]);
		
		start();
	}
	
	public function start() 
	{
		Fuse.current.enterFrame.add(OnTick);
	}
	
	public function stop() 
	{
		Fuse.current.enterFrame.remove(OnTick);
	}
	
	function OnTick() 
	{
		tick++;
		normalized = (tick * 24 / 60);
		frame = Math.round(normalized); 
	}
	
	function get_frame():Int 
	{
		return frame;
	}
	
	function set_frame(value:Int):Int 
	{
		texture.textureData.changeCount++;
		if (frame == value % textures.length) return value;
		frame = value % textures.length;
		textures[frame].textureData.changeCount++;
		texture = textures[frame];
		return frame;
	}
}