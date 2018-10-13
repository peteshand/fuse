package fuse.core.front.texture.atlas;

typedef AtlasData =
{
    frames:Array<FrameData>
}

typedef FrameData =
{
    filename: String,
	frame: RectData,
	rotated: Bool,
	trimmed: Bool,
	spriteSourceSize: RectData,
	sourceSize: SizeData,
	pivot: PointData
}

typedef PointData =
{
    x:Int,
    y:Int
}

typedef SizeData =
{
    w:Int,
    h:Int
}

typedef RectData =
{
    x:Int,
    y:Int,
    w:Int,
    h:Int
}