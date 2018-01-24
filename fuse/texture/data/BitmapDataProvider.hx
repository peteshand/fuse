package fuse.texture.data;
import openfl.display.BitmapData;

/**
 * ...
 * @author P.J.Shand
 */
class BitmapDataProvider extends DataProvider<BitmapData>
{
	
	public function new(?url:String) 
	{
		super();
	}
	
	//static public function fromData(dataCallback:Void -> BitmapData):BitmapDataProvider 
	//{
		//var d:BitmapDataProvider = new BitmapDataProvider();
		//d.dataCallback = dataCallback;
		//return d;
	//}
	//
	//static public function fromURL(url:String):BitmapDataProvider
	//{
		//return new BitmapDataProvider(url);
	//}
}