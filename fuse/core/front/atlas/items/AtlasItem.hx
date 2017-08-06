package fuse.core.front.atlas.items;

import fuse.texture.ITexture;
import fuse.display.DisplayObject;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.utils.Notifier;
//import kea.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
// An AtlasItem contains a reference to a kea texture and all 
// the kea display objects that use the base for your texture

class AtlasItem
{
	public var texture:ITexture;
	public var area(get, null):Int;
	public var atlasIndex:Null<Int>;
	public var partition = new Notifier<AtlasPartition>();
	public var atlasTexture:ITexture;
	public var rotation:Float;
	public var width(get, null):Int;
	public var height(get, null):Int;
	
	public var placed:Bool = false;
	public var rendered:Bool = false;
	
	//var displayMap = new Map<DisplayObject, Bool>();
	
	public function new(texture:ITexture) 
	{
		this.texture = texture;
		if (texture.width > texture.height) {
			rotation = 90;
		}
	}
	
	/*public function add(displayObject:DisplayObject) 
	{
		displayObject.atlasItem = this;
		displayMap.set(displayObject, true);
	}*/
	
	/*public function remove(displayObject:DisplayObject):Bool
	{
		displayObject.atlasItem = null;
		displayMap.remove(displayObject);
		return displayMap.iterator().hasNext();
	}*/
	
	function get_area():Int 
	{
		if (texture == null) return 0;
		return texture.width * texture.height;
		
		/*if (texture == null) return 0;
		if (texture.width > texture.height) return texture.width;
		else return texture.height;*/
	}
	
	inline function get_width():Int 
	{
		if (rotation == 90) return texture.height;
		return texture.width;
	}
	
	inline function get_height():Int 
	{
		if (rotation == 90) return texture.width;
		return texture.height;
	}
}