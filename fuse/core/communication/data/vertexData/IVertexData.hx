package fuse.core.communication.data.vertexData;
import fuse.utils.Color;

/**
 * @author P.J.Shand
 */

interface IVertexData 
{
	public function setXY(index:Int, x:Float, y:Float):Void;
	public function setUV(index:Int, u:Float, v:Float):Void;
	public function setMaskUV(index:Int, u:Float, v:Float):Void;
	public function setTexture(value:Float):Void;
	public function setMaskTexture(value:Float):Void;
	public function setAlpha(value:Float):Void;
	public function setColor(index:Int, value:Color):Void;
	
	//public function setR(index:Int, value:Float):Void;
	//public function setG(index:Int, value:Float):Void;
	//public function setB(index:Int, value:Float):Void;
	//public function setA(index:Int, value:Float):Void;
}