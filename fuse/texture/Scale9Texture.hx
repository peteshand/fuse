package fuse.texture;

import fuse.core.front.texture.FrontScale9Texture;
import openfl.display.BitmapData;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;
import msignal.Signal.Signal0;
import fuse.geom.Rectangle;

class Scale9Texture
{
    static var cache = new Map<String, FrontScale9Texture>();

    var frontScale9Texture:FrontScale9Texture;
    public var textures:Array<ITexture>;
    public var onLayoutUpdate:Signal0;
    public var scale9Grid(get, null):Rectangle;

    @:isVar public var width(get, set):Float;
	@:isVar public var height(get, set):Float;

    public function new(texture:ITexture, scale9Grid:Rectangle) 
	{
        var id:String = texture.textureId + "_" + scale9Grid.x + "_" + scale9Grid.y + "_" + scale9Grid.width + "_" + scale9Grid.height;
        frontScale9Texture = cache.get(id);
        if (frontScale9Texture == null){
            frontScale9Texture = new FrontScale9Texture(texture, scale9Grid);
            cache.set(id, frontScale9Texture);
        }

        textures = frontScale9Texture.textures;
        onLayoutUpdate = frontScale9Texture.onLayoutUpdate;
    }

    function get_width():Float		            {	return frontScale9Texture.width;			        }
	function get_height():Float		            {	return frontScale9Texture.height;			        }
    function get_scale9Grid():Rectangle         {   return frontScale9Texture.scale9Grid;               }

    function set_width(value:Float):Float		{	return frontScale9Texture.width = value;			}
	function set_height(value:Float):Float		{	return frontScale9Texture.height = value;			}
}