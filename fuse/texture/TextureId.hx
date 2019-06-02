package fuse.texture;

abstract TextureId(Int) to Int {
	public function new(value:Int) {
		this = value;
	}

	@:from
	static public function fromInt(value:Int) {
		return new TextureId(value);
	}

	@:op(A >= B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A > B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A <= B) static function gt(a:TextureId, b:TextureId):Bool;

	@:op(A < B) static function gt(a:TextureId, b:TextureId):Bool;
}
