package fuse.input;

@:enum abstract TouchType(String) to String {
	public var PRESS = "press";
	public var RELEASE = "release";
	public var MOVE = "move";
	public var OVER = "over";
	public var OUT = "out";
}
