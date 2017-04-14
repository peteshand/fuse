package kea.display;

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
	private var drawWidth:Float;
	private var drawHeight:Float;
	static var shaderPipeline:PipelineState;
	var map = new Map<String, Array<BlendingFactor>>();
	
	public function new(base:kha.Image)
	{
		super();
		this.base = base;
		drawWidth = this.base.width;
		drawHeight = this.base.height;
		
		// "multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
		// "none"     => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
		
		if (shaderPipeline == null){
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
			
			//map.set("none"     => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
			/*"normal"   => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
			"add"      => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ],
			"multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
			"screen"   => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE ],
			"erase"    => [ Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
			"mask"     => [ Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA ],
			"below"    => [ Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ]*/
			
			/*var blendingFactors:Array<BlendingFactor> = [
				BlendingFactor.BlendOne,
				BlendingFactor.BlendZero,
				BlendingFactor.DestinationAlpha,
				BlendingFactor.DestinationColor,
				BlendingFactor.InverseDestinationAlpha,
				BlendingFactor.InverseDestinationColor,
				BlendingFactor.InverseSourceAlpha,
				BlendingFactor.InverseSourceColor,
				BlendingFactor.SourceAlpha,
				BlendingFactor.SourceColor
			];
			
			shaderPipeline.blendSource = blendingFactors[Math.floor(Math.random() * blendingFactors.length)];
			shaderPipeline.blendDestination = blendingFactors[Math.floor(Math.random() * blendingFactors.length)];
			shaderPipeline.alphaBlendSource = blendingFactors[Math.floor(Math.random() * blendingFactors.length)];
			shaderPipeline.alphaBlendDestination = blendingFactors[Math.floor(Math.random() * blendingFactors.length)];*/
			
			//if (random == 0) {
				//shaderPipeline.blendSource = BlendingFactor.BlendOne;
				//shaderPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
				//shaderPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
				//shaderPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
			//}
			//else {
				//"multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
				
				//"add"      => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ],
				
				//shaderPipeline.blendSource = BlendingFactor.SourceAlpha;
				//shaderPipeline.blendDestination = BlendingFactor.DestinationAlpha;
				
				//shaderPipeline.blendSource = BlendingFactor.BlendZero;
				//shaderPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
				/*shaderPipeline.blendOperation = BlendingOperation.Min;
				shaderPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
				shaderPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
				shaderPipeline.alphaBlendOperation = BlendingOperation.Min;*/
				
				/*shaderPipeline.blendOperation = 
				shaderPipeline.blendSource = BlendingFactor.BlendOne;
				shaderPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
				shaderPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
				shaderPipeline.alphaBlendDestination = BlendingFactor.BlendZero;*/
			//}
			shaderPipeline.compile();
		}
	}

	override public function render(graphics:Graphics): Void
	{
		//this.pipeline = shaderPipeline;
		/*if (graphics.pipeline != shaderPipeline) {
			graphics.pipeline = shaderPipeline;
		}*/
		
		if (atlas != null){
			if (atlas.texture != null){
				graphics.drawSubImage(atlas.texture, 
					-pivotX, -pivotY, // draw x/y
					0, 0, // sample x/y
					drawWidth, drawHeight // draw width/height
				);
			}
		}
	}
}
