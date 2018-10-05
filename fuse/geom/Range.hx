package fuse.geom;

class Range
{
    public var start:Float;
    public var end:Float;
    
    public var length(get, never):Float;

    public function new(start:Float, end:Float)
    {
        this.start = start;
        this.end = end;
    }

    function get_length():Float
    {
        return end - start;
    }

    public function toString():String
    {
        return "start: " + start + ", end: " + end + ", length: " + length;
    }
}