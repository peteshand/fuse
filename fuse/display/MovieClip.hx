package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.texture.AbstractTexture;
import fuse.texture.IBaseTexture;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture)
class MovieClip extends Image
{
	var textures(default, set):Array<AbstractTexture>;
	var tick:Int = 0;
	var normalized:Float = 0;
	var fsp:Int;
	@:isVar var frame(get, set):Int = 0;
	
	public function new(textures:Array<AbstractTexture>, fsp:Int=24) 
	{
		this.fsp = fsp;
		if (textures == null || textures.length == 0) {
			throw new Error("One or more textures must be past");
		}
		this.textures = textures;
		
		super(textures[0]);
		displayType = DisplayType.MOVIECLIP;
		
		play();
	}
	
	public function play() 
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
		textures[frame].directRender = true;
		textures[frame].textureData.changeCount++;
		texture = textures[frame];
		return frame;
	}
	
	override public function dispose():Void
	{
		Fuse.current.enterFrame.remove(OnTick);
		super.dispose();
	}
	
	function set_textures(value:Array<AbstractTexture>):Array<AbstractTexture> 
	{
		textures = value;
		for (i in 0...textures.length) 
		{
			textures[i].directRender = true;
		}
		
		return textures;
	}
}