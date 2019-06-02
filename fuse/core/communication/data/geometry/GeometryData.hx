package fuse.core.communication.data.geometry;

/**
 * ...
 * @author P.J.Shand
 */
class GeometryData implements IGeometryData {
	public var id:Int;
	public var x:Float;
	public var y:Float;
	public var u:Float;
	public var v:Float;

	public function new(id:Int, x:Float, y:Float, u:Float, v:Float) {
		this.id = id;
		this.x = x;
		this.y = y;
		this.u = u;
		this.v = v;
	}
}
