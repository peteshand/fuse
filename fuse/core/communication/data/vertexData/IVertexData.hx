package fuse.core.communication.data.vertexData;

/**
 * @author P.J.Shand
 */
interface IVertexData 
{
	public function setX(index:Int, value:Float):Void;
	public function setY(index:Int, value:Float):Void;
	public function setU(index:Int, value:Float):Void;
	public function setV(index:Int, value:Float):Void;
	public function setT(index:Int, value:Float):Void;
	public function setR(index:Int, value:Float):Void;
	public function setG(index:Int, value:Float):Void;
	public function setB(index:Int, value:Float):Void;
	public function setA(index:Int, value:Float):Void;
	
	public function setColor(value:Color):Void;
	public function setAlpha(value:Float):Void;
}