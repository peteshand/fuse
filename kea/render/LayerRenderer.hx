package kea.render;

import kea.display.IDisplay;
import kea.display.Stage;
import kea.util.RenderUtils;
import kha.graphics2.Graphics;
import kea.render.layers.LayerBuffer;
import kea.render.layers.ILayerBuffer;
import kea.render.layers.DynamicLayerBuffer;
import kea.Kea;

class LayerRenderer
{
	private var stage:Stage;
	private var root:IDisplay;
	public var renderList:Array<IDisplay> = [];
	public var justAdded:Array<IDisplay> = [];
	public var changeAvailable:Bool = false;

	public var layerbuffers:Array<ILayerBuffer> = [];
	public var lowestChange:Int = 0;

	//var font:Font;

	public function new(stage:Stage, root:IDisplay) {
		this.stage = stage;
		this.root = root;

		for (i in 0...5){
			layerbuffers.push(new DynamicLayerBuffer(i*2));
			layerbuffers.push(new LayerBuffer((i*2) + 1));
		}
		var j:Int = layerbuffers.length-2;
		while (j >= 0){
			layerbuffers[j].next = layerbuffers[j+1];
			j--;
		}

		/*Assets.loadFont("arial", function(_font:Font):Void
		{
			font = _font;
		});*/
	}

	public function drawToAtlas():Void
	{
		if (changeAvailable){
			for (i in 0...justAdded.length){
				stage.textureAtlas.add(justAdded[i]);
			}
			stage.textureAtlas.draw();
			/*for (i in 0...justAdded.length){
				Kea.current.stage.textureAtlas.add(justAdded[i]);
			}
			Kea.current.stage.textureAtlas.draw();*/

			justAdded = [];
		}
	}

	public function add(index:Int, display:IDisplay):Void
	{
		/*for (i in 0...renderList.length){
			if (renderList[i] == display) return;
		}*/
		if (display.parent != null) return;

		if (index >= renderList.length) pushToRenderList(display);
		else insertToRenderList(index, display);

		justAdded.push(display);
		if (lowestChange > index-1){
			lowestChange = index-1;
		}
		changeAvailable = true;
	}

	public function pushToRenderList(display:IDisplay):Void
	{
		renderList.push(display);
	}

	public function insertToRenderList(index:Int, display:IDisplay):Void
	{
		renderList[index].previous = display;
		renderList[index]._renderIndex++;
		renderList.insert(index, display);
	}

	

	public function remove(display:IDisplay):Void
	{
		renderList.remove(display);
		changeAvailable = true;
	}

	public function drawToBuffers(graphics:Graphics):Void
	{
		/*for (i in 0...layerbuffers.length){
			layerbuffers[i].copying.value = null;
		}*/
		//trace("changeAvailable = " + changeAvailable);
		//if (changeAvailable){
			for (i in 0...layerbuffers.length){
				layerbuffers[i].reset();
			}
			RenderUtils.calculateIndices(root, layerbuffers);
		//}
		
		var activeBuffer:ILayerBuffer = layerbuffers[0];
		activeBuffer.active.value = true;
		
		var i:Int = 0;
		var len:Int = renderList.length;
		while (i < len){
			//trace(i);
			//trace("activeBuffer.endIndex.value = " + activeBuffer.endIndex.value);
			if (activeBuffer.endIndex.value != null){
				//trace("draw" + i);
				i = activeBuffer.draw(graphics, renderList[i], i);
			}
			else {
				i = renderList.length;
			}
			
			if (i > activeBuffer.endIndex.value){
				activeBuffer.active.value = false;
				
				if (activeBuffer.next != null){
					if (activeBuffer.next.endIndex.value != null){
						activeBuffer = activeBuffer.next;
						activeBuffer.drawIndex.value = i+1;
						activeBuffer.active.value = true;
					}
				}
			}

		}
		activeBuffer.active.value = false;

		
		graphics.begin(true, stage.color.value);
		for (i in 0...layerbuffers.length) {
			layerbuffers[i].copy(graphics);
		}

		/*if (font != null){
			graphics.font = font;
			graphics.fontSize = 40;
			graphics.color = 0xFF000000;
			graphics.drawString(renderList.length + " images", 0, 0);
			graphics.color = 0xFFFFFFFF;
		}*/
		graphics.end();

		changeAvailable = false;
		lowestChange = renderList.length;
		//trace("--");
	}
}

