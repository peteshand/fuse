package fuse.text.textDisplay.text.display;

import openfl.Vector;
import openfl.geom.Point;
import fuse.display.Sprite;
import fuse.text.textDisplay.events.LinkEvent;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.util.FormatParser.FormatNode;
import fuse.input.Touch;

/**
 * ...
 * @author P.J.Shand
 */
class Links extends Sprite {
	var textDisplay:TextDisplay;
	var links:Array<Link> = [];

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		super();

		update();
	}

	override public function dispose():Void {
		super.dispose();
	}

	public function update() {
		textDisplay.hitArea.onPress.remove(onHitareaPress);
		links = [];

		createLinks(textDisplay.contentModel.nodes);

		if (links.length > 0) {
			textDisplay.touchable = true;
			textDisplay.hitArea.onPress.add(onHitareaPress);
		}
	}

	function onHitareaPress(touch:Touch):Void {
		checkPosition(touch.x, touch.y);
	}

	function checkPosition(_x:Float, _y:Float) {
		trace("TODO: fix this");
		/*var pos:Point = textDisplay.globalToLocal(new Point(_x, _y));
			var char:Char = textDisplay.charLayout.getCharByPosition(pos.x, pos.y);

			for (i in 0...links.length) {
				if (char.index >= links[i].startIndex && char.index < links[i].endIndex) {
					textDisplay.dispatchEvent(new LinkEvent(LinkEvent.CLICK, links[i].href));
				}
		}*/
	}

	function createLinks(formatNodes:Array<FormatNode>) {
		if (formatNodes == null)
			return;

		for (i in 0...formatNodes.length) {
			var node:FormatNode = formatNodes[i];

			/*for (j in 0...node.attributes.length) 
				{
					var attribute:FormatAttribute = node.attributes[j];
					if (attribute.key == "href") {
						addLinkRange(attribute.value, node.startIndex, node.endIndex);
					}
			}*/

			if (node.format.href != null) {
				addLinkRange(node.format.href, node.startIndex, node.endIndex);
			}

			createLinks(node.children);
		}
	}

	function addLinkRange(href:String, startIndex:Int, endIndex:Int) {
		links.push({href: href, startIndex: startIndex, endIndex: endIndex});
	}
}

typedef Link = {
	href:String,
	startIndex:Int,
	endIndex:Int
}
