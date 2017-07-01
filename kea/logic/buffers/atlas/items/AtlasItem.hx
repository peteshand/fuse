package kea.logic.buffers.atlas.items;

import kea2.display.containers.DisplayObject;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.packer.AtlasPartition;
import kea2.utils.Notifier;
import kea.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
// An AtlasItem contains a reference to a base kha image and all 
// the kea display objects that use the base for your texture

class AtlasItem
{
	public var base:Texture;
	public var area(get, null):Int;
	public var atlasIndex:Null<Int>;
	public var partition = new Notifier<AtlasPartition>();
	public var atlasTexture:Texture;
	public var rotation:Float;
	public var width(get, null):Int;
	public var height(get, null):Int;
	
	public var placed:Bool = false;
	public var rendered:Bool = false;
	
	var displayMap = new Map<DisplayObject, Bool>();
	
	public function new(base:Texture) 
	{
		this.base = base;
		if (base.width > base.height) {
			rotation = 90;
		}
	}
	
	public function add(displayObject:DisplayObject) 
	{
		displayObject.atlasItem = this;
		displayMap.set(displayObject, true);
	}
	
	public function remove(displayObject:DisplayObject):Bool
	{
		displayObject.atlasItem = null;
		displayMap.remove(displayObject);
		return displayMap.iterator().hasNext();
	}
	
	function get_area():Int 
	{
		if (base == null) return 0;
		return base.width * base.height;
		
		/*if (base == null) return 0;
		if (base.width > base.height) return base.width;
		else return base.height;*/
	}
	
	inline function get_width():Int 
	{
		if (rotation == 90) return base.height;
		return base.width;
	}
	
	inline function get_height():Int 
	{
		if (rotation == 90) return base.width;
		return base.height;
	}
}