package fuse.shader;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.Vector;
import openfl.filters.ColorMatrixFilter;

class ColorMatrixShader extends BaseShader
{
    @:isVar public var colorMatrixFilter(default, set):ColorMatrixFilter;
	
    static var defaultColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,  0,1,0,0,0,  0,0,1,0,0,  0,0,0,1,0]);
    var colorMatrixValues:Vector<Float>;
    
    public function new (colorMatrixFilter:ColorMatrixFilter=null)
    {	
        super();
		
        this.colorMatrixFilter = colorMatrixFilter;
	}

    function set_colorMatrixFilter(value:ColorMatrixFilter):ColorMatrixFilter
    {
        if (value == null) value = defaultColorMatrixFilter;

        colorMatrixValues = new Vector<Float>();
        var i2:Int = 0;
        for (i in 0...16) {
            colorMatrixValues.push(value.matrix[i2]);
            if (i % 4 == 3) i2 += 2;
            else i2++;
        }
        for (j in 0...4){
            var j2:Int = 4 + (j * 5);
            colorMatrixValues.push(value.matrix[j2]);
        }
        hasChanged = true; 
        return value;
    }

    override public function activate(context3D:Context3D):Void
    {
        //if (hasChanged) {
            context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, colorMatrixValues, 5);
            hasChanged = false;
        //}
    }

    override public function fragmentString():String 
	{
        var agal:String = "";
        var fcs:Array<String> = ["fc3", "fc4", "fc5", "fc6"];
        var channel:Array<String> = ["x", "y", "z", "w"];
        
        for (i in 0...fcs.length) {
            var j:Int = 3 + i;
            var c = channel[i];
            var c4 = c + c + c + c;
            agal += "mul ft2, ft1, " + fcs[i] + "	                        \n";
            
            //agal += "mov ft3." + c4 + ",        ft2.xyzw     		            \n";
            
            agal += "mov ft3." + c + ",        ft2.x       		            \n";
            agal += "add ft3." + c + ", ft3." + c + ", ft2.y       	        \n";
            agal += "add ft3." + c + ", ft3." + c + ", ft2.z       	        \n";
            agal += "add ft3." + c + ", ft3." + c + ", ft2.w       	        \n";
            
            agal += "add ft3." + c + ", ft3." + c + ", fc7." + c + "        \n";
        }
        agal += "mov ft1.xyzw, ft3.xyzw \n";
        
        return agal;
    }
}