package fuse.core.communication.data.vertexData;

import fuse.utils.Color;

/**
 * @author P.J.Shand
 */
interface IVertexData {
	public function setRect(index:Int, x:Float, y:Float, width:Float = -1, height:Float = -1, rotation:Float = 0, edgeAA:Int = 0):Void;
	public function setUV(index:Int, u:Float, v:Float):Void;
	public function setMaskUV(index:Int, u:Float, v:Float):Void;
	public function setTexture(value:Float):Void;
	public function setMaskTexture(value:Float):Void;
	public function setAlpha(value:Float):Void;
	public function setColor(index:Int, value:Color):Void;
}
