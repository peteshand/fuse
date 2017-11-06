package fuse.core.communication.data.indices;

/**
 * @author P.J.Shand
 */
@:dox(hide)
interface IIndicesData 
{
	var i1(get, set):Int;
	var i2(get, set):Int;
	var i3(get, set):Int;
	var i4(get, set):Int;
	var i5(get, set):Int;
	var i6(get, set):Int;
	
	//function getIndex(index:Int):Int;
	function setIndex(index:Int, value:Int):Void;
	
}