package fuse.display.geometry;

import fuse.core.communication.data.geometry.IGeometryData;
import openfl.Vector;

/**
 * ...
 * @author P.J.Shand
 */
class Mesh {
	// var indices:Vector<UInt>;
	var geometryData:Array<IGeometryData> = [];

	public function new() {
		indices = new Vector<UInt>(6);
	}
}
