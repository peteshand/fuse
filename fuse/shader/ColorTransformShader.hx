package fuse.shader;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.Vector;

class ColorTransformShader extends BaseShader
{
    @:isVar public var redMultiplier(default, set):Float;
	@:isVar public var blueMultiplier(default, set):Float;
	@:isVar public var greenMultiplier(default, set):Float;
    @:isVar public var alphaMultiplier(default, set):Float;
	
    @:isVar public var redOffset(get, set):Float;
    @:isVar public var greenOffset(get, set):Float;
	@:isVar public var blueOffset(get, set):Float;
	@:isVar public var alphaOffset(get, set):Float;
	
    var colorTransform:Vector<Float>;
    var id:Int;
    static var count:Int = 0;
    public function new (redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0, greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0)
    {	
        super();
        id = count++;
		colorTransform = new Vector<Float>();
        
        this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.greenOffset = greenOffset;
		this.blueOffset = blueOffset;
		this.alphaOffset = alphaOffset;
	}

    function set_redMultiplier(value:Float):Float { colorTransform[0] = value; hasChanged = true; return value; }
    function set_greenMultiplier(value:Float):Float { colorTransform[1] = value; hasChanged = true; return value; }
    function set_blueMultiplier(value:Float):Float { colorTransform[2] = value; hasChanged = true; return value; }
    function set_alphaMultiplier(value:Float):Float { colorTransform[3] = value; hasChanged = true; return value; }

    function get_redOffset():Float { return colorTransform[4] * 0xFF; }
    function get_greenOffset():Float { return colorTransform[5] * 0xFF; }
    function get_blueOffset():Float { return colorTransform[6] * 0xFF; }
    function get_alphaOffset():Float { return colorTransform[7] * 0xFF; }

    function set_redOffset(value:Float):Float { colorTransform[4] = value / 0xFF; hasChanged = true; return value; }
    function set_greenOffset(value:Float):Float { colorTransform[5] = value / 0xFF; hasChanged = true; return value; }
    function set_blueOffset(value:Float):Float { colorTransform[6] = value / 0xFF; hasChanged = true; return value; }
    function set_alphaOffset(value:Float):Float { colorTransform[7] = value / 0xFF; hasChanged = true; return value; }

    override public function activate(context3D:Context3D):Void
    {
        //if (hasChanged) {
            context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, colorTransform, 2);
            hasChanged = false;
        //}
    }

    override public function fragmentString():String 
	{
        var agal:String = "";
        agal += "mul ft1, ft1, fc1				\n"; // multiply by color transform mul rgba
			
		agal += "min ft1, ft1, ONE.4			\n"; // cap to +1
		agal += "min ft1, NEG_ONE.4, ft1		\n"; // cap to -1

		agal += "add ft1, ft1, fc2				\n"; // add color transform offset rgba
		
        return agal;
    }
}