package fuse.utils;

abstract ObjectId(Null<Int>) to Null<Int> from Null<Int> {
	public function new(value:Null<Int>) {
		this = value;
	}

	@:from
	static public function fromInt(value:Null<Int>) {
		return new ObjectId(value);
	}

	@:op(A >= B) static function gt(a:ObjectId, b:ObjectId):Bool;

	@:op(A > B) static function gt(a:ObjectId, b:ObjectId):Bool;

	@:op(A <= B) static function gt(a:ObjectId, b:ObjectId):Bool;

	@:op(A < B) static function gt(a:ObjectId, b:ObjectId):Bool;
}
