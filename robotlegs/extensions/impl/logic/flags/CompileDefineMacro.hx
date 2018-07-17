package robotlegs.extensions.impl.logic.flags;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Expr;
/**
 * ...
 * @author P.J.Shand
 */
class CompileDefineMacro
{
	public static function build() 
	{
		var map:Map<String, String> = Context.getDefines();
		var defineKeys:Array<String> = [];
		//var defineValues:Array<String> = new Array<String>();
		for (key in map.keys()) {
			//trace(["key: " + key, map.get(key)]);
			defineKeys.push(key + "," + map.get(key));
			//defineValues.push(map.get(key));
		}
		
		var fields = Context.getBuildFields();
		
		var defineKeysFieldType:FieldType = FVar(macro:Array<String>, macro $v { defineKeys } );
		//var defineKeysFieldType:FieldType = FVar(macro:Array<String>, macro $v { defineKeys } );
		// for some reason as soon as i push values into defineValues, I get an error on "macro $v { defineValues }"
		//var defineValuesFieldType:FieldType = FVar(macro:Array<String>, macro $v { defineValues } );
		
		for (i in 0...fields.length) 
		{
			var field:Field = fields[i];
			if (field.name == "defineKeys"){
				fields[i].kind = defineKeysFieldType;
			}
			/*if (field.name == "defineValues"){
				fields[i].kind = defineValuesFieldType;
			}*/
		}
		return fields;
	}
	
}