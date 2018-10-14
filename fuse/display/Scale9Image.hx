package fuse.display;

import fuse.utils.Color;
import fuse.core.front.texture.Textures;
import fuse.geom.Rectangle;
import fuse.texture.ITexture;
import fuse.texture.Scale9Texture;

class Scale9Image extends Sprite
{
    var scale9Texture:Scale9Texture;
	var images:Array<Image> = [];

    public function new(scale9Texture:Scale9Texture) 
	{
		super();
        this.scale9Texture = scale9Texture;
        
        for (i in 0...scale9Texture.textures.length){
            var image:Image = new Image(scale9Texture.textures[i]);
            addChild(image);
            images.push(image);
        }

        scale9Texture.onLayoutUpdate.add(onLayoutUpdate);
        onLayoutUpdate();
    }

    function onLayoutUpdate()
    {
        for (i in 0...images.length){
            var rect:Rectangle = scale9Texture.rects[i];
            var image:Image = images[i];
            image.x = rect.x;
            image.y = rect.y;
            image.width = rect.width;
            image.height = rect.height;
        }
    }

    override function get_width():Float {    return scale9Texture.width; }
    override function get_height():Float {    return scale9Texture.height; }
    

    override function set_width(value:Float):Float { 
        return scale9Texture.width = value;
	}

    override function set_height(value:Float):Float {
        return scale9Texture.height = value;
	}
	
    override function set_color(value:Color):Color { 
		for (i in 0...images.length) {
            var image:Image = images[i];
            image.color = value;
        }
		return super.set_color(value);
	}

    override function set_renderLayer(value:Null<Int>):Null<Int> 
	{
		for (i in 0...images.length) {
            var image:Image = images[i];
            image.renderLayer = value;
        }
		return renderLayer = value;
	}   
}