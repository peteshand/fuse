package kea.atlas;

import kea.core.Kea;
import kea.display.IDisplay;
import kha.Image;
import kha.graphics2.Graphics;

class TextureAtlas
{
	public static inline var screenWidth = 1024;
	public static inline var screenHeight = 1024;
	
	private var positionX:Int = 0;
	private var positionY:Int = 0;
	private var texture: Image;
	private var images = new Map<Image, IDisplay>();
	public var changeAvailable:Bool = false;
	
	private var atlasObjects = new Map<kha.Image, AtlasObject>();
	
	public function new() {
		texture = Image.createRenderTarget(screenWidth, screenHeight);
		texture.g2.begin(true, 0x00000000);
		texture.g2.end();

		positionX = 0;
		positionY = 0;
	}

	public function update():Void
	{
		var justAdded:Array<IDisplay> = Kea.current.updateList.justAdded;
		if (justAdded.length > 0){
			for (i in 0...justAdded.length){
				add(justAdded[i]);
			}
			draw();

			Kea.current.updateList.justAdded = [];
		}
	}

	function add(display:IDisplay):Void
	{
		if (display.base == null) return;
		display.atlas = atlasObjects.get(display.base);
		if (display.atlas == null){
			atlasObjects.set(display.base, new AtlasObject(display.base));
			display.atlas = atlasObjects.get(display.base);
		}
	}
	
	//public function clear(){
	//	texture.g2.begin(true, 0x00000000);
	//}

	function draw():Void
	{	
		texture.g2.begin(false);
		for (key in atlasObjects.keys()){
			var atlas:AtlasObject = atlasObjects.get(key);
			var base:kha.Image = atlas.base;
			if (base != null){
				texture.g2.drawImage(base, positionX, positionY);
				//texture.g2.drawImage(atlas.base, positionX, positionY);
				atlas.x = positionX;
				atlas.y = positionY;
				atlas.texture = texture;
				//atlas.display.atlas = atlas;

				positionX += base.width;
			}
		}
		texture.g2.end();

		/*if (display.atlas != null){
			var atlas = display.atlas;
			if (!images.exists(atlas.base)){
				images.set(atlas.base, display);

				texture.g2.begin(false);
				
				texture.g2.fillRect(positionX, positionY, atlas.base.width, atlas.base.height);
				texture.g2.drawImage(atlas.base, positionX, positionY);
				
				texture.g2.end();

				atlas.x = positionX;
				atlas.y = positionY;
				atlas.texture = texture;

				positionX += atlas.base.width;

				changeAvailable = true;
			}
		}*/
	}

	/*public function render(graphics:Graphics): Void
	{
		//graphics.scissor(0, 0, 100, 100);
		graphics.drawImage(texture, 0, 0);
		//graphics.disableScissor();
	}*/
}
