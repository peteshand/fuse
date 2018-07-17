package robotlegs.extensions.impl.logic.config.html;
import js.Browser;
import robotlegs.extensions.api.model.config.IConfigModel;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class QueryConfigLogic
{
	@inject public var configModel:IConfigModel;
	
	public function new() 
	{
		
	}
	
	public function init() 
	{
		var query = Browser.location.search.substr(1);
		if (query != null && query != ""){
			var pairs:Array<String> = query.split('&');
			
			for ( pair in pairs){
				var parts = pair.split('=');
				if (parts.length == 2){
					var name = parts[0];
					var value = parseVal(StringTools.urlDecode(parts[1]));
					Reflect.setProperty(configModel, name, value);
					trace("Query prop: " + name + " = " + value);
				}
			}
		}
	}
	
	function parseVal(val:String) : Dynamic
	{
		if(val == "true") return true;
		if (val == "false") return false;
		
		var numVal = Std.parseFloat(val);
		if (numVal + "" == val) return numVal;
		
		return val;
	}
}