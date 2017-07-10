package net.peteshand.keaOpenFL.view.kea.old.imageDemo;

import kea.display.Sprite;
import kha.graphics2.Graphics;
import kha.Assets;
import kha.Video;

class DemoVideo extends Sprite
{
	var video:Video;

	public function new()
	{
		super();

		/*Assets.loadVideo("ge2", function(_video:Video):Void
		{
			video = _video;
		});*/
	}

	override public function render(graphics:Graphics): Void
	{
		/*if (atlas != null){
			if (atlas.texture != null){
				graphics.drawSubImage(atlas.texture, 
					-pivotX, -pivotY, // draw x/y
					0, 0, // sample x/y
					this.base.width, this.base.height // draw width/height
				);
			}
		}*/

		if (video != null){
			//graphics.drawVideo(video, 0, 0, 300, 300);
		}
	}
}
