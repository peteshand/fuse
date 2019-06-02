package fuse.text;

@:enum abstract TextFieldAutoSize(String) from String to String {
	public var BOTH_DIRECTIONS:String = "BOTH_DIRECTIONS";
	public var HORIZONTAL:String = "HORIZONTAL";
	public var NONE:String = "NONE";
	public var VERTICAL:String = "VERTICAL";
}
