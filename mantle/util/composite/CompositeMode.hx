package mantle.util.composite;

@:enum abstract CompositeMode(Int) from Int to Int
{	
	public static var LETTERBOX:Int = 0;
	public static var CROP:Int = 1;
	public static var FIT_WIDTH:Int = 2;
	public static var FIT_HEIGHT:Int = 3;
	public static var ORIGINAL:Int = 4;
	public static var STRETCH:Int = 5;
}