package robotlegs.extensions.impl.utils.types;

/**
 * ...
 * @author P.J.Shand
 */
class CastUtils
{

	public function new() 
	{
		
	}
	
	
	public static function castValue(value:Dynamic):Dynamic
	{
		if (!Std.is(value, String)) return value;
		
		var str:String = cast value;
		
		if (str == null) return null;
		if (str.toLowerCase() == "true") return true;
		if (str.toLowerCase() == "false") return false;
		
		/*var p1 = ~/\D/;
		var p2 = ~/[.]/;
		var p3 = ~/[a-z]|[A-Z]/;
		
		var isP1:Bool = p1.match(value);
		var isP2:Bool = p2.match(value);
		var isP3:Bool = p3.match(value);
		
		var isInt:Bool = isP1 == false;
		var isFloat:Bool = isP2 && isP3 == false;*/
		
		var numVal = Std.parseFloat(str);
		var isFloat:Bool = Std.string(numVal) == str;
		var isInt:Bool = (numVal % 1 == 0);
		
		if (isInt) return Std.int(numVal);
		else if (isFloat) return numVal;
		else if (str.substr(0, 1) == "[" && value.substr(str.length - 1, 1) == "]") {
			str = str.substr(1, str.length - 2);
			var split:Array<String> = str.split(", ").join(",").split(",");
			var dynamicArray:Array<Dynamic> = [];
			for (j in 0...split.length) 
			{
				dynamicArray.push(CastUtils.castValue(split[j]));
			}
			return dynamicArray;
		}
		return str;
	}
}