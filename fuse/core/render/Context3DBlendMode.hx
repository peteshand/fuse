package fuse.core.render;
import fuse.display.BlendMode;
import haxe.Json;
import notifier.Notifier;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;

/**
 * ...
 * @author P.J.Shand
 */
class Context3DBlendMode
{
	static var context3D:Context3D;
	static var factors:Map<Int, BlendFactors>;
	
	public static var blendMode = new Notifier<BlendMode>();
	
	public static function init(context3D:Context3D) 
	{
		Context3DBlendMode.context3D = context3D;
		
		factors = new Map<Int, BlendFactors>();
		factors.set(BlendMode.NONE, { sourceFactor:Context3DBlendFactor.ONE, destinationFactor:Context3DBlendFactor.ZERO } );
		factors.set(BlendMode.NORMAL, { sourceFactor:Context3DBlendFactor.ONE, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA } );
		factors.set(BlendMode.ADD, { sourceFactor:Context3DBlendFactor.ONE, destinationFactor:Context3DBlendFactor.ONE } );
		factors.set(BlendMode.MULTIPLY, { sourceFactor:Context3DBlendFactor.DESTINATION_COLOR, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA } );
		factors.set(BlendMode.SCREEN, { sourceFactor:Context3DBlendFactor.ONE, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR } );
		factors.set(BlendMode.ERASE, { sourceFactor:Context3DBlendFactor.ZERO, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA } );
		factors.set(BlendMode.MASK, { sourceFactor:Context3DBlendFactor.ZERO, destinationFactor:Context3DBlendFactor.SOURCE_ALPHA } );
		factors.set(BlendMode.BELOW, { sourceFactor:Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, destinationFactor:Context3DBlendFactor.DESTINATION_ALPHA } );
		
		factors.set(BlendMode.ALPHA, { sourceFactor:Context3DBlendFactor.SOURCE_ALPHA, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA } );
		factors.set(BlendMode.HARDLIGHT, { sourceFactor:Context3DBlendFactor.SOURCE_ALPHA, destinationFactor:Context3DBlendFactor.DESTINATION_COLOR } );
		factors.set(BlendMode.NEGATIVE, { sourceFactor:Context3DBlendFactor.ZERO, destinationFactor:Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR } );
		factors.set(BlendMode.SHADOW, { sourceFactor:Context3DBlendFactor.ZERO, destinationFactor:Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR } );
		
		blendMode.add(OnBlendModeChange);
	}
	
	static private function OnBlendModeChange() 
	{
		var blendFactors:BlendFactors = factors.get(blendMode.value);
		context3D.setBlendFactors(blendFactors.sourceFactor, blendFactors.destinationFactor);
	}	
}

typedef BlendFactors =
{
	sourceFactor:Context3DBlendFactor, 
	destinationFactor:Context3DBlendFactor
}