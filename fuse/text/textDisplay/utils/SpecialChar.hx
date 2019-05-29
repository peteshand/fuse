package fuse.text.textDisplay.utils;

/**
 * ...
 * @author Thomas Byrne
 */
@:enum
abstract SpecialChar(String) to String {
	var NewLine = "\n";
	var Return = "\r";
	var Space = " ";
	var Tab = "\t";
	public static var WhiteSpace:Array<String> = [Space, Tab, Return, NewLine];

	public inline static function isWhitespace(char:String):Bool {
		return char == Return || char == NewLine || char == Space || char == Tab;
	}

	public inline static function isLineBreak(char:String):Bool {
		return char == Return || char == NewLine;
	}
}
