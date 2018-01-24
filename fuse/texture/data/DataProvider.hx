package fuse.texture.data;
import fuse.utils.FileType;
import openfl.display.BitmapData;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.data)
class DataProvider<T>
{
	public var data:T;
	var requestData:Void -> T;
	
	public function new() 
	{
		
	}
	
	static public function fromData<S>(requestData:Void -> S):DataProvider<S>
	{
		var data = requestData();
		var dataProvider:DataProvider<S> = null;
		
		if (Std.is(data, BitmapData)) dataProvider = untyped new BitmapDataProvider();
		
		dataProvider.data = data;
		dataProvider.requestData = requestData;
		return untyped dataProvider;
	}
	
	static public function fromURL<S>(url:String):DataProvider<S>
	{
		var dataType:DataType = FileType.dataType(url);
		switch dataType {
			case DataType.IMAGE: return untyped new BitmapDataProvider(url);
			case DataType.VIDEO: return untyped new BitmapDataProvider(url);
			case DataType.ATF: return untyped new BitmapDataProvider(url);
		}
		return null;
	}
}