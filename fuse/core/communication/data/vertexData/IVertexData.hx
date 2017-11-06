package fuse.core.communication.data.vertexData;
import fuse.utils.Color;

/**
 * @author P.J.Shand
 */
@:dox(hide)
interface IVertexData 
{
	public function setXY(index:Int, x:Float, y:Float):Void;
	//public function setX(index:Int, value:Float):Void;
	//public function setY(index:Int, value:Float):Void;
	
	public function setUV(index:Int, u:Float, v:Float):Void;
	//public function setU(index:Int, value:Float):Void;
	//public function setV(index:Int, value:Float):Void;
	public function setMaskUV(index:Int, u:Float, v:Float):Void;
	//public function setMaskU(index:Int, value:Float):Void;
	//public function setMaskV(index:Int, value:Float):Void;
	
	public function setTexture(value:Float):Void;
	public function setMaskTexture(value:Float):Void;
	//public function setMaskBaseValue(value:Float):Void;
	public function setAlpha(value:Float):Void;
	
	//public function setR(index:Int, value:Float):Void;
	//public function setG(index:Int, value:Float):Void;
	//public function setB(index:Int, value:Float):Void;
	//public function setA(index:Int, value:Float):Void;
	
	public function setColor(value:Color):Void;
	
	
}