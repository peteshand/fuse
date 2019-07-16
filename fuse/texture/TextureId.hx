package fuse.texture;

abstract TextureId(Null<Int>) to Null<Int> {
	public function new(value:Null<Int>) {
		this = value;
	}

	@:from
	static public function fromInt(value:Null<Int>) {
		return new TextureId(value);
	}

	@:op(A >= B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A > B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A <= B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A < B) static function gt(a:TextureId, b:TextureId):Bool;
}
