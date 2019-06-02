package fuse.display.geometry;

import fuse.core.communication.data.geometry.GeometryData;
import fuse.core.communication.data.geometry.IGeometryData;

/**
 * ...
 * @author P.J.Shand
 */
class QuadMesh extends Mesh {
	public function new(width:Int, height:Int) {
		super();
		geometryData.push(new GeometryData(0, 0, 0, 0, 0));
		geometryData.push(new GeometryData(1, 0, 0, 0, 0));
		geometryData.push(new GeometryData(2, 0, 0, 0, 0));
		geometryData.push(new GeometryData(3, 0, 0, 0, 0));

		// Triangle 1
		// indices[0] = 0;
		// indices[1] = 1;
		// indices[2] = 2;

		// Triangle 2
		// indices[3] = 0;
		// indices[4] = 2;
		// indices[5] = 3;
	}
}
