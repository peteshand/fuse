package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
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
	var fsp:Int;
	@:isVar var frame(get, set):Int = 0;
	
	public function new(textures:Array<ITexture>, fsp:Int=24) 
	{
		this.fsp = fsp;
		this.textures = textures;
		if (textures == null || textures.length == 0) {
			throw new Error("One or more textures must be past");
		}
		super(textures[0]);
		displayType = DisplayType.MOVIECLIP;
		
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
		if (stage == null) return;
		
		tick++;
		normalized = (tick * fsp / 60);
		frame = Math.round(normalized); 
	}
	
	function get_frame():Int 
	{
		return frame;
	}
	
	function set_frame(value:Int):Int 
	{
		if (frame == value % textures.length) return value;
		texture.textureData.changeCount++;
		frame = value % textures.length;
		textures[frame].textureData.changeCount++;
		texture = textures[frame];
		return frame;
	}
	
	override public function dispose():Void
	{
		Fuse.current.enterFrame.remove(OnTick);
		super.dispose();
	}
}