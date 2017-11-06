package fuse.core.communication.data.textureData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;
import fuse.core.backend.atlas.partition.AtlasPartition;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class TextureData implements ITextureData
{
	public var textureId:Int;
	
	@:isVar public var x(get, set):Int;
	@:isVar public var y(get, set):Int;
	@:isVar public var width(get, set):Int;
	@:isVar public var height(get, set):Int;
	@:isVar public var p2Width(get, set):Int;
	@:isVar public var p2Height(get, set):Int;
	
	@:isVar public var baseX(get, set):Int;
	@:isVar public var baseY(get, set):Int;
	@:isVar public var baseWidth(get, set):Int;
	@:isVar public var baseHeight(get, set):Int;
	@:isVar public var baseP2Width(get, set):Int;
	@:isVar public var baseP2Height(get, set):Int;
	
	@:isVar public var textureAvailable(get, set):Int;
	@:isVar public var placed(get, set):Int;
	@:isVar public var persistent(get, set):Int;
	@:isVar public var directRender(get, set):Int;
	
	@:isVar public var atlasTextureId(get, set):Int;
	@:isVar public var atlasBatchTextureIndex(get, set):Int;
	
	public var area(get, null):Float;
	public var partition = new Notifier<AtlasPartition>();
	
	public function new(objectOffset:Int) 
	{
		textureId = objectOffset;
		atlasTextureId = textureId;
	}
	
	inline function get_x():Int { 
		return x;
	}
	
	inline function get_y():Int { 
		return y;
	}
	
	inline function get_width():Int { 
		return width;
	}
	
	inline function get_height():Int { 
		return height;
	}
	
	inline function get_p2Width():Int { 
		return p2Width;
	}
	
	inline function get_p2Height():Int { 
		return p2Height;
	}
	
	inline function get_baseX():Int { 
		return baseX;
	}
	
	inline function get_baseY():Int { 
		return baseY;
	}
	
	inline function get_baseWidth():Int { 
		return baseWidth;
	}
	
	inline function get_baseHeight():Int { 
		return baseHeight;
	}
	
	inline function get_baseP2Width():Int { 
		return baseP2Width;
	}
	
	inline function get_baseP2Height():Int { 
		return baseP2Height;
	}
	
	
	inline function get_textureAvailable():Int { 
		return textureAvailable;
	}
		
	inline function get_placed():Int { 
		return placed;
	}
		
	inline function get_persistent():Int { 
		return persistent;
	}
		
	inline function get_directRender():Int { 
		return directRender;
	}
	
	inline function get_atlasTextureId():Int { 
		return atlasTextureId;
	}
	
	inline function get_atlasBatchTextureIndex():Int { 
		return atlasBatchTextureIndex;
	}
	
	
	
	
	inline function set_x(value:Int):Int { 
		return x = value;
	}
	
	inline function set_y(value:Int):Int { 
		return y = value;
	}
	
	inline function set_width(value:Int):Int { 
		return width = value;
	}
	
	inline function set_height(value:Int):Int { 
		return height = value;
	}
	
	inline function set_p2Width(value:Int):Int { 
		return p2Width = value;
	}
	
	inline function set_p2Height(value:Int):Int { 
		return p2Height = value;
	}
	
	inline function set_baseX(value:Int):Int { 
		return baseX = value;
	}
	
	inline function set_baseY(value:Int):Int { 
		return baseY = value;
	}
	
	inline function set_baseWidth(value:Int):Int { 
		return baseWidth = value;
	}
	
	inline function set_baseHeight(value:Int):Int { 
		return baseHeight = value;
	}
	
	inline function set_baseP2Width(value:Int):Int { 
		return baseP2Width = value;
	}
	
	inline function set_baseP2Height(value:Int):Int { 
		return baseP2Height = value;
	}
	
	inline function set_textureAvailable(value:Int):Int { 
		return textureAvailable = value;
	}
	
	inline function set_placed(value:Int):Int { 
		return placed = value;
	}
	
	inline function set_persistent(value:Int):Int { 
		return persistent = value;
	}
	
	inline function set_directRender(value:Int):Int { 
		return directRender = value;
	}
	
	inline function set_atlasTextureId(value:Int):Int { 
		return atlasTextureId = value;
	}
	
	inline function set_atlasBatchTextureIndex(value:Int):Int { 
		return atlasBatchTextureIndex = value;
	}
	
	
	
	public function toString():String
	{
		return "textureId = " + textureId + ", atlasIndex = " + atlasTextureId + " - (" + x + ", " + y + ", " + width + ", " + height + ")";
	}
	
	
	function get_area():Float 
	{
		return this.width * this.height;
	}
}