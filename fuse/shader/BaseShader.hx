package fuse.shader;

import openfl.display3D.Context3D;

class BaseShader implements IShader
{
    static var idCount:Int = 1;
    //static var map = new Map<Int, IShader>();
    static var registry:Array<IShader> = [];
    
    static function getShaders(id:Int):Array<IShader>
    {
        trace("id = " + id);
        var shaders:Array<IShader> = [];

        var i:Int = registry.length - 1;
        while (i >= 0) {
            trace("registry[i].objectId = " + registry[i].objectId);
            if (id >= registry[i].objectId) {
                shaders.push(registry[i]);
            }
            i--;
        }
        trace("shaders.length = " + shaders.length);
        return shaders;
    }

    public var objectId:Int;
    var hasChanged:Bool = false;

    public function new()
    {
        objectId = idCount;
        idCount += idCount;

        registry.push(this);
        //map.set(objectId, this);
    }

    public function dispose()
    {
        //map.remove(objectId);
        var i:Int = registry.length - 1;
        while (i >= 0) {
            if (registry[i] == this) {
                registry.splice(i, 1);
            }
            i--;
        }
    }

    public function activate(context3D:Context3D):Void
    {

    }

    public function deactivate(context3D:Context3D):Void
    {

    }
    
    public function vertexString():String
    {
        return "";
    }
    
	public function fragmentString():String
    {
        return "";
    }
    
}