package robotlegs.extensions.impl.model.flags;

import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

import StringTools;

/**
 * ...
 * @author P.J.Shand
 */
class FlagsModel
{
	public var keys:StringMap<String> = new StringMap<String>();
	public var values:Array<String> = [];
	
	public function add(key:String, value:String):Void
	{
		keys.set(key, value);
		values.push(value);
	}
	public function valueExists(value:String):Bool
	{
		return values.indexOf(value) != -1;
	}
	public function valueOrKeyExists(value:String):Bool
	{
		return valueExists(value) || keys.exists(value);
	}
	
	/**
	 * Allows the use of '&' or '|' in flag matching expressions
	 */
	public function match(value:String):Bool
	{
		var hasAnd = value.indexOf("&") != -1;
		var hasOr = value.indexOf("|") != -1;
		#if debug
		if (hasAnd && hasOr){
			throw "Mixing '&' with '|' in flags not yet supported"; 
		}
		if (value.indexOf("(") != -1 || value.indexOf(")") != -1){
			throw "Use of parenthesis in flags not yet supported"; 
		}
		#end
		
		if (hasAnd){
			var parts = value.split("&");
			for (part in parts){
				if (!valueOrKeyExists(StringTools.trim(part))){
					return false;
				}
			}
			return true;
			
		}else if (hasOr){
			var parts = value.split("|");
			for (part in parts){
				if (valueOrKeyExists(StringTools.trim(part))){
					return true;
				}
			}
			return false;
			
		}else{
			return valueOrKeyExists(StringTools.trim(value));
		}
		
	}
	
	public function get(key:String):Null<String>
	{
		return keys.get(key);
	}
}