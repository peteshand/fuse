package kea.model.buffers.atlas;

import kea.Kea;
import kea.display.DisplayObject;
import kea.display.IDisplay;
import kea.texture.Texture;
import kha.graphics2.Graphics;

class TextureAtlas
{
	private var positionX:Int = 0;
	private var positionY:Int = 0;
	public var texture: Texture;
	private var images = new Map<Int, IDisplay>();
	public var changeAvailable:Bool = false;
	
	private var atlasObjects = new Map<Texture, AtlasObject>();
	
	public function new() {
		texture = Texture.createRenderTarget(Buffer.bufferWidth, Buffer.bufferHeight);
		texture.g2.begin(true, 0x00000000);
		texture.g2.end();
		
		positionX = 0;
		positionY = 0;
	}

	public function update():Void
	{
		if (changeAvailable) {
			draw();
			changeAvailable = false;
		}
	}
	
	public function setTexture(id:Int, displayObject:DisplayObject) 
	{
		if (!images.exists(id)) {
			images.set(id, displayObject);
			add(displayObject);
		}
	}

	function add(display:IDisplay):Void
	{
		if (display.base == null) return;
		display.atlas = atlasObjects.get(display.base);
		if (display.atlas == null){
			atlasObjects.set(display.base, new AtlasObject(display.base));
			display.atlas = atlasObjects.get(display.base);
			changeAvailable = true;
		}
	}
	
	function draw():Void
	{
		positionX = 0;
		positionY = 0;
		
		texture.g2.begin(true, 0x00000000);
		for (key in atlasObjects.keys()){
			var atlas:AtlasObject = atlasObjects.get(key);
			var base:Texture = atlas.base;
			if (base != null){
				texture.g2.drawImage(base, positionX, positionY);
				atlas.x = positionX;
				atlas.y = positionY;
				atlas.texture = texture;
				positionX += base.width;
			}
		}
		texture.g2.end();
	}
}
