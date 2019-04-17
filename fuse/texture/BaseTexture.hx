package fuse.texture;

import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.front.texture.IFrontTexture;

import fuse.utils.ObjectId;
import fuse.texture.TextureId;
import signal.Signal;
import delay.Delay;

import fuse.display.Image;
import fuse.utils.Color;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;

@:access(openfl.display3D.textures.TextureBase)
@:access(fuse.core.front.texture.IFrontTexture)
class BaseTexture implements ITexture
{
    @:isVar var texture(default, set):IFrontTexture;
    public var objectId(get, null):ObjectId;
	public var textureId(get, null):TextureId;

    public var onUpdate = new Signal();
    public var onUpload = new Signal();
    public var width(get, set):Null<Int>;
	public var height(get, set):Null<Int>;
    public var offsetU(get, set):Float;
	public var offsetV(get, set):Float;
	public var scaleU(get, set):Float;
	public var scaleV(get, set):Float;
    public var directRender(get, set):Bool;

    public var textureData(get, set):ITextureData;
    public var nativeTexture(get, null):Texture;
    public var textureBase(get, null):TextureBase;
    public var clearColour(get, set):Color;
    public var _clear(get, set):Bool;
    public var _alreadyClear(get, set):Bool;

    public function new() 
	{
        
    }

    function get_objectId():ObjectId                            {   return texture.objectId;                }
    function get_textureId():TextureId                          {   return texture.textureId;               }
    
    function get_width():Null<Int>                              {   return texture.width;                   }
	function get_height():Null<Int>                             {   return texture.height;                  }
    function get_offsetU():Float                                {   return texture.offsetU;                 }
	function get_offsetV():Float                                {   return texture.offsetV;                 }
    function get_scaleU():Float                                 {   return texture.scaleU;                  }
	function get_scaleV():Float                                 {   return texture.scaleV;                  }
    function get_directRender():Bool                            {   return texture.directRender;            }
    function get_textureData():ITextureData                     {   return texture.textureData;             }
    function get_nativeTexture():Texture                        {   return texture.nativeTexture;           }
    function get_textureBase():TextureBase                      {   return texture.textureBase;             }
    function get_clearColour():Color                            {   return texture.clearColour;             }
    function get__clear():Bool                                  {   return texture._clear;                  }
    function get__alreadyClear():Bool                           {   return texture._alreadyClear;           }
    
    function set_texture(value:IFrontTexture):IFrontTexture
    {
        if (texture != null){
            onUpdate = null;
            onUpload = null;
        }
        texture = value;
        if (texture != null){
            onUpdate = texture.onUpdate;
            onUpload = texture.onUpload;
            
            if (texture.textureAvailable == true){
                Delay.nextFrame(() -> {
                    // Texture already ready
                    onUpdate.dispatch();
                    onUpload.dispatch();
                });
            }
        }
        return value;
    }

    function set_width(value:Null<Int>):Null<Int>               {   return texture.width = value;           }
	function set_height(value:Null<Int>):Null<Int>              {   return texture.height = value;          }
    function set_offsetU(value:Float):Float                     {   return texture.offsetU = value;         }
	function set_offsetV(value:Float):Float                     {   return texture.offsetV = value;         }
    function set_scaleU(value:Float):Float                      {   return texture.scaleU = value;          }
	function set_scaleV(value:Float):Float                      {   return texture.scaleV = value;          }
	function set_directRender(value:Bool):Bool                  {   return texture.directRender = value;    }
    function set_textureData(value:ITextureData):ITextureData   {   return texture.textureData = value;     }
	function set_clearColour(value:Color):Color                 {   return texture.clearColour = value;     }
	function set__clear(value:Bool):Bool                        {   return texture._clear = value;          }
	function set__alreadyClear(value:Bool):Bool                 {   return texture._alreadyClear = value;   }
	
    public function upload():Void                               {   texture.upload();                       }
	public function dispose():Void                              {   texture.dispose();                      }
	public function addChangeListener(image:Image):Void         {   texture.addChangeListener(image);       }
	public function removeChangeListener(image:Image):Void      {   texture.removeChangeListener(image);    }
	public function setTextureData():Void                       {   texture.setTextureData();               }
	
    public function createSubTexture(offsetU:Float, offsetV:Float, scaleU:Float, scaleV:Float):SubTexture
    {
        var subTexture = new SubTexture(texture.createSubTexture(offsetU, offsetV, scaleU, scaleV));
        //onUpdate.add(subTexture.onUpdate.dispatch);
        //onUpload.add(subTexture.onUpload.dispatch);
        return subTexture;
    }
}