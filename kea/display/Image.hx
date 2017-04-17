package kea.display;

import kea.atlas.AtlasObject;
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
	static var shaderPipeline:PipelineState;
	var map = new Map<String, Array<BlendingFactor>>();
	
	private static var lastImage:kha.Image = null;
	
	public function new(base:kha.Image)
	{
		this.renderable = true;
		this.base = base;
		
		
		
		
		
		// "multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
		// "none"     => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
		
		/*if (shaderPipeline == null){
			var random:Int = Math.floor(Math.random() * 2);
			
			shaderPipeline = new PipelineState();
			shaderPipeline.fragmentShader = Shaders.painter_image_frag;
			shaderPipeline.vertexShader = Shaders.painter_image_vert;

			var structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("vertexColor", VertexData.Float4);
			shaderPipeline.inputLayout = [structure];
			
			map.set("none", [BlendingFactor.BlendOne, BlendingFactor.BlendZero]);
			map.set("normal", [BlendingFactor.SourceAlpha, BlendingFactor.InverseSourceAlpha]);
			map.set("add", [BlendingFactor.SourceAlpha, BlendingFactor.DestinationAlpha]);
			map.set("multiply", [BlendingFactor.DestinationColor, BlendingFactor.InverseSourceAlpha]);
			map.set("screen", [BlendingFactor.SourceAlpha, BlendingFactor.BlendOne]);
			map.set("erase", [BlendingFactor.BlendZero, BlendingFactor.InverseSourceAlpha]);
			map.set("mask", [BlendingFactor.BlendZero, BlendingFactor.SourceAlpha]);
			map.set("below", [BlendingFactor.InverseDestinationAlpha, BlendingFactor.DestinationAlpha]);
			
			var blendingFactors:Array<BlendingFactor> = map.get("screen");
			
			shaderPipeline.blendSource = blendingFactors[0];
			shaderPipeline.blendDestination = blendingFactors[1];
			
			shaderPipeline.compile();
		}*/
		
		super();
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
