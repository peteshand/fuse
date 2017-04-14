package kea.display.text;
import kha.Color;

class TextFormat
{
	@:isVar public static var defaultFormat(get, null):TextFormat;
	public var fontSize:Int = 40;
	public var color:Color = Color.White;

	public function new() {
		
	}

	static function get_defaultFormat():TextFormat
	{
		if (defaultFormat == null){
			defaultFormat = new TextFormat();
			defaultFormat.fontSize = 40;
			defaultFormat.color = 0xFFFF0000;
		}
		return defaultFormat;
	}
}
