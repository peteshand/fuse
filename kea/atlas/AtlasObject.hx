package kea.atlas;

import kha.Image;

class AtlasObject
{
	public var base:kha.Image;
	public var texture:kha.Image;
	public var x:Int = 0;
	public var y:Int = 0;
	
	public function new(base:kha.Image) {
		this.base = base;
	}
}
