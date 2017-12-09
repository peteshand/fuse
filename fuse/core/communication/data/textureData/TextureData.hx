package fuse.core.communication.data.textureData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;
//import fuse.core.backend.atlas.partition.AtlasPartition;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */

class TextureData implements ITextureData
{
	public var textureId:Int;
	
	public var _x:Int;
	public var _y:Int;
	public var _width:Int;
	public var _height:Int;
	public var _p2Width:Int;
	public var _p2Height:Int;
	
	public var _baseX:Int;
	public var _baseY:Int;
	public var _baseWidth:Int;
	public var _baseHeight:Int;
	public var _baseP2Width:Int;
	public var _baseP2Height:Int;
	
	public var _textureAvailable:Int;
	public var _placed:Int;
	public var _persistent:Int;
	public var _directRender:Int;
	
	public var _atlasTextureId:Int;
	public var _atlasBatchTextureIndex:Int;
	
	public var _changeCount:Int = 0;
	
	
	
	
	public var x(get, set):Int;
	public var y(get, set):Int;
	public var width(get, set):Int;
	public var height(get, set):Int;
	public var p2Width(get, set):Int;
	public var p2Height(get, set):Int;
	
	public var baseX(get, set):Int;
	public var baseY(get, set):Int;
	public var baseWidth(get, set):Int;
	public var baseHeight(get, set):Int;
	public var baseP2Width(get, set):Int;
	public var baseP2Height(get, set):Int;
	
	public var textureAvailable(get, set):Int;
	public var placed(get, set):Int;
	public var persistent(get, set):Int;
	public var directRender(get, set):Int;
	
	public var atlasTextureId(get, set):Int;
	public var atlasBatchTextureIndex(get, set):Int;
	
	public var changeCount(get, set):Int;
	
	public var area(get, null):Float;
	//public var partition = new Notifier<AtlasPartition>();
	
	public function new(objectOffset:Int) 
	{
		textureId = objectOffset;
		atlasTextureId = textureId;
	}
	
	inline function get_x():Int { 
		return _x;
	}
	
	inline function get_y():Int { 
		return _y;
	}
	
	inline function get_width():Int { 
		return _width;
	}
	
	inline function get_height():Int { 
		return _height;
	}
	
	inline function get_p2Width():Int { 
		return _p2Width;
	}
	
	inline function get_p2Height():Int { 
		return _p2Height;
	}
	
	inline function get_baseX():Int { 
		return _baseX;
	}
	
	inline function get_baseY():Int { 
		return _baseY;
	}
	
	inline function get_baseWidth():Int { 
		return _baseWidth;
	}
	
	inline function get_baseHeight():Int { 
		return _baseHeight;
	}
	
	inline function get_baseP2Width():Int { 
		return _baseP2Width;
	}
	
	inline function get_baseP2Height():Int { 
		return _baseP2Height;
	}
	
	
	inline function get_textureAvailable():Int { 
		return _textureAvailable;
	}
		
	inline function get_placed():Int { 
		return _placed;
	}
		
	inline function get_persistent():Int { 
		return _persistent;
	}
		
	inline function get_directRender():Int { 
		return _directRender;
	}
	
	inline function get_atlasTextureId():Int { 
		return _atlasTextureId;
	}
	
	inline function get_atlasBatchTextureIndex():Int { 
		return _atlasBatchTextureIndex;
	}
	
	inline function get_changeCount():Int { 
		return _changeCount;
	}
	
	
	
	
	inline function set_x(value:Int):Int { 
		return _x = value;
	}
	
	inline function set_y(value:Int):Int { 
		return _y = value;
	}
	
	inline function set_width(value:Int):Int { 
		return _width = value;
	}
	
	inline function set_height(value:Int):Int { 
		return _height = value;
	}
	
	inline function set_p2Width(value:Int):Int { 
		return _p2Width = value;
	}
	
	inline function set_p2Height(value:Int):Int { 
		return _p2Height = value;
	}
	
	inline function set_baseX(value:Int):Int { 
		return _baseX = value;
	}
	
	inline function set_baseY(value:Int):Int { 
		return _baseY = value;
	}
	
	inline function set_baseWidth(value:Int):Int { 
		return _baseWidth = value;
	}
	
	inline function set_baseHeight(value:Int):Int { 
		return _baseHeight = value;
	}
	
	inline function set_baseP2Width(value:Int):Int { 
		return _baseP2Width = value;
	}
	
	inline function set_baseP2Height(value:Int):Int { 
		return _baseP2Height = value;
	}
	
	inline function set_textureAvailable(value:Int):Int { 
		return _textureAvailable = value;
	}
	
	inline function set_placed(value:Int):Int { 
		return _placed = value;
	}
	
	inline function set_persistent(value:Int):Int { 
		return _persistent = value;
	}
	
	inline function set_directRender(value:Int):Int { 
		return _directRender = value;
	}
	
	inline function set_atlasTextureId(value:Int):Int { 
		return _atlasTextureId = value;
	}
	
	inline function set_atlasBatchTextureIndex(value:Int):Int { 
		return _atlasBatchTextureIndex = value;
	}
	
	inline function set_changeCount(value:Int):Int { 
		return _changeCount = value;
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