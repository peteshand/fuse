package robotlegs.extensions.impl.utils.json;

/**
 * ...
 * @author P.J.Shand
 */
class JsonFormatter
{

	public function new() 
	{
		
	}
	
	public static function formatJsonString(strData:String):String
	{
		var returnVal:String = "";
		var actions = new Array<Action>();
		var tabIndex:Int = 0;
		var tabs:Array<String> = 
		[
			"", 
			"\t", 
			"\t\t", 
			"\t\t\t", 
			"\t\t\t\t", 
			"\t\t\t\t\t", 
			"\t\t\t\t\t\t", 
			"\t\t\t\t\t\t\t", 
			"\t\t\t\t\t\t\t\t", 
			"\t\t\t\t\t\t\t\t\t",
			"\t\t\t\t\t\t\t\t\t\t",
			"\t\t\t\t\t\t\t\t\t\t\t",
			"\t\t\t\t\t\t\t\t\t\t\t\t",
			"\t\t\t\t\t\t\t\t\t\t\t\t\t"
		];
		actions.push({key:"{", replace:["{\n$tabs$"], tabOffset:[1]});
		actions.push({key:"}", replace:["\n$tabs$}"], tabOffset:[-1]});
		actions.push({key:"[", replace:["\n$tabs$[","[\n$tabs$"], tabOffset:[0,1]});
		actions.push({key:"]", replace:["\n$tabs$]"], tabOffset:[-1]});
		actions.push({key:",", replace:[",\n$tabs$"], tabOffset:[0]});
		
		var split:Array<String> = strData.split("");
		var withinQuotes:Bool = false;
		var withinDoubleQuotes:Bool = false;
		
		for (i in 0...split.length) 
		{
			var value:String = split[i];
			if (value == "'") withinQuotes = withinQuotes ? false : true;
			if (value == '"') withinDoubleQuotes = withinDoubleQuotes ? false : true;
			
			if (!withinQuotes && !withinDoubleQuotes) {
				for (j in 0...actions.length) 
				{
					var action:Action = actions[j];
					if (value == action.key) {
						for (k in 0...action.replace.length) 
						{
							var replace:String = action.replace[k];
							var tabOffset:UInt = action.tabOffset[k];
							tabIndex += tabOffset;
							replace= replace.split("$tabs$").join(tabs[tabIndex]);
							value = value.split(action.key).join(replace);
						}
						
					}
				}
			}
			returnVal += value;
		}
		return returnVal;
	}
}

typedef Action =
{
	key:String,
	replace:Array<String>,
	tabOffset:Array<UInt>
}