package fuse.utils;

abstract ObjectId(Int) to Int from Int
{
    public function new(value:Int)
    {
        this = value;
    }

    @:from
    static public function fromInt(value:Int) {
        return new ObjectId(value);
    }

    @:op(A >= B) static function gt( a:ObjectId, b:ObjectId ) : Bool;
    @:op(A > B) static function gt( a:ObjectId, b:ObjectId ) : Bool;
    @:op(A <= B) static function gt( a:ObjectId, b:ObjectId ) : Bool;
    @:op(A < B) static function gt( a:ObjectId, b:ObjectId ) : Bool;
}