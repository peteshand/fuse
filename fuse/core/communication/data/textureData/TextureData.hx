package fuse.core.communication.data.textureData;

/**
 * ...
 * @author P.J.Shand
 */

class TextureData
{
	public var textureId:Int;
	
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var p2Width:Int;
	public var p2Height:Int;
	
	public var baseX:Int;
	public var baseY:Int;
	public var baseWidth:Int;
	public var baseHeight:Int;
	public var baseP2Width:Int;
	public var baseP2Height:Int;
	
	public var textureAvailable:Int;
	public var placed:Int;
	public var persistent:Int;
	public var directRender:Int;
	
	public var atlasTextureId:Int;
	public var atlasBatchTextureIndex:Int;
	
	public var changeCount:Int = 0;
	
	public var area(get, null):Float;
	
	public function new(objectOffset:Int) 
	{
		textureId = objectOffset;
		atlasTextureId = textureId;
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