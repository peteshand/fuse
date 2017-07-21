package fuse.texture;

/**
 * @author P.J.Shand
 */
interface ITexture 
{
	public var textureId:Int;
	public var width:Int;
	public var height:Int;
	private var p2Width:Int;
	private var p2Height:Int;
	public var name:String;
	
	private function upload():Void;
}