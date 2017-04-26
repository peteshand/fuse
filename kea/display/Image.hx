package kea.display;

import kea.model.buffers.atlas.AtlasObject;
import kha.Image;
import kha.Shaders;
import kha.graphics2.Graphics;
import kha.graphics4.BlendingFactor;
import kha.graphics4.BlendingOperation;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

class Image extends DisplayObject implements IDisplay
{
	//static var shaderPipeline:PipelineState;
	//var map = new Map<String, Array<BlendingFactor>>();
	
	private static var lastImage:kha.Image = null;
	
	public function new(base:kha.Image)
	{
		//this.renderable = true;
		this.base = base;
		
		super();
		
		this.width = base.width;
		this.height = base.height;
	}

	//override public function render(graphics:Graphics): Void
	//{
		////this.pipeline = shaderPipeline;
		///*if (graphics.pipeline != shaderPipeline) {
			//graphics.pipeline = shaderPipeline;
		//}*/
		//
		//renderLine(graphics);
	//}
	
	
	//function renderImage(graphics:Graphics): Void
	//{
		//graphics.drawImage(base, -pivotX, -pivotY);
	//}
	//
	//function renderAtlas(graphics:Graphics): Void
	//{
		//graphics.drawSubImage(atlas.texture, 
			//-pivotX, -pivotY,
			//atlas.x, atlas.y,
			//drawWidth, drawHeight
		//);
	//}
	//
	//override function set_atlas(value:AtlasObject):AtlasObject 
	//{
		//atlas = value;
		//if (atlas == null) renderLine = renderImage;
		//else renderLine = renderAtlas;
		//return atlas;
	//}
}
