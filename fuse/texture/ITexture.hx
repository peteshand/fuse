package fuse.texture;
import fuse.core.communication.data.textureData.ITextureData;
import openfl.display.BitmapData;

/**
 * @author P.J.Shand
 */
interface ITexture 
{
	private var textureData:ITextureData;
	public var textureId:Int;
	public var width:Int;
	public var height:Int;
	private var p2Width:Int;
	private var p2Height:Int;
	public var name:String;
	
	private function upload():Void;
	
	function dispose():Void;
}