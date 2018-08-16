package fuse.texture.atlas;

typedef PhaserData =
{
    textures:Array<PhaserTextureData>
}

typedef PhaserTextureData =
{
    image:String,
    format:String,
    size:PhaserSizeData,
    scale:String,
    frames:Array<PhaserFrameData>
}

typedef PhaserFrameData =
{
    filename:String,
    rotated:Bool,
    trimmed:Bool,
    sourceSize:PhaserSizeData,
    spriteSourceSize:PhaserRectData,
    frame:PhaserRectData,
    anchor:PhaserPointData
}

typedef PhaserPointData =
{
    x:Float,
    y:Float
}

typedef PhaserSizeData =
{
    w:Float,
    h:Float
}

typedef PhaserRectData =
{
    x:Float,
    y:Float,
    w:Float,
    h:Float
}