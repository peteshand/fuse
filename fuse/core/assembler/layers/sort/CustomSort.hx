package fuse.core.assembler.layers.sort;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class CustomSort<T>
{
	var temp:T;
	
	public function new() 
	{
		
	}
	
	public function sort(arr:GcoArray<T>, prop:String, sortType:SortType=null):GcoArray<T>
	{ 
		if (sortType == null) sortType = SortType.ASCENDING;
		if(sortType == SortType.DESCENDING)
		{
			for(i in 0...arr.length)
			{
				var j:Int = arr.length - 1;
				while (j > i)
				{
					var v1 = getValue(arr[j - 1], prop);
					var v2 = getValue(arr[j], prop);
					
					if (v1 < v2)
					{
						temp = arr[j-1];
						arr[j-1] = arr[j];  
						arr[j] = temp;      
					}
					j--;
				}
			}
		}
		else {
			for(k in 0...arr.length)
			{
				var l:Int = arr.length - 1;
				while (l > k)
				{
					var v1 = getValue(arr[l - 1], prop);
					var v2 = getValue(arr[l], prop);
					
					if (v1 > v2)
					{
						temp = arr[l-1];
						arr[l-1] = arr[l];  
						arr[l] = temp;              
					}
					l--;
				}
			}
		}
		
		return arr;
	}
	
	inline function getValue(object:Dynamic, prop:String) 
	{
		#if air
			return untyped object[prop];
		#else
			return Reflect.getProperty(object, prop);
		#end
	}
}


@:enum abstract SortType(String) from String to String
{
	public static inline var DESCENDING:String = "descending";
	public static inline var ASCENDING:String = "ascending";
}