package kea.display;
//import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.BlendingOperation;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract BlendMode(String) {
	var NONE = "none";
	var NORMAL = "normal";
	var ADD = "add";
	var MULTIPLY = "multiply";
	var SCREEN = "screen";
	var ERASE = "erase";
	var MASK = "mask";
	var BELOW = "below";
}

class BlendModeUtil
{
	static var shaderPipelines:Map<BlendMode, PipelineState>;
	static var blendFactors:Map<BlendMode, FactorData>;
	
	static function __init__()
	{
		//use sourceFactor = Context3DBlendFactor.SOURCE_ALPHA and destinationFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA
		
		shaderPipelines = new Map<BlendMode, PipelineState>();
		blendFactors = new Map<BlendMode, FactorData>();
		blendFactors.set(BlendMode.NONE, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.BlendOne, 
			alphaBlendDestination	:BlendingFactor.BlendZero
		});
		blendFactors.set(BlendMode.NORMAL, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.SourceAlpha, 
			alphaBlendDestination	:BlendingFactor.InverseSourceAlpha
		});
		
		
		/*shaderPipeline.blendSource = BlendingFactor.BlendOne;
		shaderPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		shaderPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
		shaderPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;*/
		
		blendFactors.set(BlendMode.ADD, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.BlendOne,
			alphaBlendSource		:BlendingFactor.SourceAlpha, 
			alphaBlendDestination	:BlendingFactor.DestinationAlpha
		});
		blendFactors.set(BlendMode.MULTIPLY, {
			blendSource				:BlendingFactor.BlendZero, 
			blendDestination		:BlendingFactor.SourceColor,
			alphaBlendSource		:BlendingFactor.BlendZero, 
			alphaBlendDestination	:BlendingFactor.SourceColor
		});
		
		//GL_ZERO, GL_SRC_COLOR
		
		blendFactors.set(BlendMode.SCREEN, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.SourceAlpha, 
			alphaBlendDestination	:BlendingFactor.BlendOne
		});
		blendFactors.set(BlendMode.ERASE, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.BlendZero, 
			alphaBlendDestination	:BlendingFactor.InverseSourceAlpha
		});
		/*blendFactors.set(BlendMode.MASK, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.BlendZero, 
			alphaBlendDestination	:BlendingFactor.SourceAlpha
		});*/
		blendFactors.set(BlendMode.MASK, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.SourceColor, 
			alphaBlendDestination	:BlendingFactor.InverseSourceAlpha
		});
		blendFactors.set(BlendMode.BELOW, {
			blendSource				:BlendingFactor.BlendOne, 
			blendDestination		:BlendingFactor.InverseSourceAlpha,
			alphaBlendSource		:BlendingFactor.InverseDestinationAlpha, 
			alphaBlendDestination	:BlendingFactor.DestinationAlpha
		});
	}
	
	public function new() 
	{
		
	}
	
	public static function applyBlend(blendMode:BlendMode):PipelineState
	{
		if (!shaderPipelines.exists(blendMode)) {
			var shaderPipeline:PipelineState = new PipelineState();
			//shaderPipeline.fragmentShader = Shaders.painter_image_frag;
			//shaderPipeline.vertexShader = Shaders.painter_image_vert;
			
			var structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("vertexColor", VertexData.Float4);
			shaderPipeline.inputLayout = [structure];
			
			var factors:FactorData = blendFactors.get(blendMode);
			shaderPipeline.blendSource = factors.blendSource;
			shaderPipeline.blendDestination = factors.blendDestination;
			//shaderPipeline.colorWriteMask = true;
			shaderPipeline.alphaBlendSource = factors.alphaBlendSource;
			shaderPipeline.alphaBlendDestination = factors.alphaBlendDestination;
			
			
			//shaderPipeline.blendSource = BlendingFactor.BlendOne;
			//shaderPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			//shaderPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
			//shaderPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
			
			
			shaderPipeline.compile();
			shaderPipelines.set(blendMode, shaderPipeline);
		}
		
		return shaderPipelines.get(blendMode);
	}
}

typedef FactorData =
{
	blendSource:BlendingFactor,
	blendDestination:BlendingFactor,
	alphaBlendSource:BlendingFactor,
	alphaBlendDestination:BlendingFactor	
}