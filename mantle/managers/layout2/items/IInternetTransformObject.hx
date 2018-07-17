package mantle.managers.layout2.items;

/**
 * @author P.J.Shand
 */
interface IInternetTransformObject 
{
	#if swc @:extern #end
	public var scaleContainerScaleX(null, set):Float;
	#if swc @:extern #end
	public var scaleContainerScaleY(null, set):Float;
	#if swc @:extern #end
	public var alignX(null, set):Float;
	#if swc @:extern #end
	public var alignY(null, set):Float;
	#if swc @:extern #end
	public var anchorX(null, set):Float;
	#if swc @:extern #end
	public var anchorY(null, set):Float;
	
	/*#if swc @:setter(scaleContainerScaleX) #end*/
	private function set_scaleContainerScaleX(value:Float):Float;
	/*#if swc @:setter(scaleContainerScaleY) #end*/
	private function set_scaleContainerScaleY(value:Float):Float;
	/*#if swc @:setter(alignX) #end*/
	private function set_alignX(value:Float):Float;
	/*#if swc @:setter(alignY) #end*/
	private function set_alignY(value:Float):Float;
	/*#if swc @:setter(anchorX) #end*/
	private function set_anchorX(value:Float):Float;
	/*#if swc @:setter(anchorY) #end*/
	private function set_anchorY(value:Float):Float;
}