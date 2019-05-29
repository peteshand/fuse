package fuse.text.textDisplay.text.util;

import haxe.ds.List;
import haxe.ds.Map;
import openfl.Vector;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import fuse.display.Quad;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.display.Image;
import openfl.events.Event;
import fuse.text.BitmapChar;
import fuse.text.textDisplay.text.TextDisplay;
import fuse.texture.SubTexture;

/**
 * ...
 * @author P.J.Shand
 */
class CharRenderer {
	static var charImageMap:Map<BitmapChar, Image> = new Map();

	private var textDisplay:TextDisplay;
	// private var batches:Map<String, MeshBatch> = new Map();
	var characters:Array<Char>;
	var color:Null<UInt>;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		textDisplay.charLayout.layoutChanged.add(render);
	}

	public function setColor(color:Null<UInt>):Void {
		this.color = color;

		if (color == null)
			color = 0;
		// #if (starling >= "2.0.0")
		// for (quadBatch in batches) {
		//	quadBatch.color = color;
		// }
		// #end
	}

	public function render() {
		this.characters = textDisplay.contentModel.characters;
		clearBatches();

		for (j in 0...characters.length) {
			var char:Char = characters[j];

			if (textDisplay.maxLines != null && char.lineNumber >= textDisplay.maxLines)
				break;
			// if (char.line.outsizeBounds) break; // needs a bit of a rethink

			if (!char.visible)
				continue;
			if (char.bitmapChar != null) {
				if (char.bitmapChar.texture != null) {
					if (char.bitmapChar.texture.height != 0 && char.bitmapChar.texture.width != 0) {
						// var image:Image = textDisplay.defaultFormat.

						var image:Image = char.bitmapChar.createImage();
						/*var image:Image = charImageMap.get(char.bitmapChar);
							if (image == null) {
								image = char.bitmapChar.createImage();
								image.touchable = false;
								charImageMap.set(char.bitmapChar, image);
						}*/
						/*
							if (char.scale != image.scaleX)
								image.scaleX = image.scaleY = char.scale;

							var smoothing:String = textDisplay.textureSmoothing;
							if (smoothing == null)
								smoothing = char.font.smoothing;
							// image.textureSmoothing = smoothing;
						 */

						image.x = char.x;
						image.y = char.y;
						/*
							if (image.rotation != char.rotation)
								image.rotation = char.rotation;

							var color:UInt;
							if (char.color != null)
								color = char.color;
							else if (this.color == null)
								color = char.format.color;
							else
								color = this.color;

							if (image.color != color)
								image.color = color;
						 */
						/*
							var quadBatch = batches[char.format.face];
							if (quadBatch == null) {
								quadBatch = new MeshBatch();
								quadBatch.batchable = true;
								quadBatch.touchable = false;
								if (textDisplay.numChildren > 0)
									textDisplay.addChildAt(quadBatch, 1);
								else
									textDisplay.addChild(quadBatch);
								batches[char.format.face] = quadBatch;
							}
						 */

						// #if (starling >= "2.0.0")
						// quadBatch.addMesh(image);
						// #else
						// quadBatch.addImage(image);
						// #end

						textDisplay.addChild(image);

						// image.width = 100;
						// image.height = 100;
						/*trace("image.width = " + image.width);
							trace("image.height = " + image.height);
							trace("char.visible = " + char.visible);
							trace("char.x = " + char.x);
							trace("char.y = " + char.y);
							trace("char.rotation = " + char.rotation);
							trace("char.color = " + char.color);
							trace("char.lineNumber = " + char.lineNumber);
							trace("char.charLinePositionX = " + char.charLinePositionX);
							trace("char.character = " + char.character);
							trace("char.id = " + char.id);
							trace("char.index = " + char.index);
							trace("char.isEndChar = " + char.isEndChar);
							trace("char.scale = " + char.scale); */
					}
				}
			}
		}

		// if (textDisplay.color != -1 && textDisplay.color != null)
		//	setColor(textDisplay.color);
	}

	public function dispose() {
		// clearBatches();
		// batches = new Map();
	}

	function clearBatches() {
		// for (quadBatch in batches) {
		// #if (starling >= "2.0.0")
		// quadBatch.clear();
		// #else
		// quadBatch.reset();
		// #end
		// }
	}
}
