package fuse.texture;
import fuse.core.communication.data.textureData.ITextureData;
import msignal.Signal.Signal0;
import fuse.texture.BaseTexture;
import fuse.utils.Color;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture2.BaseTexture)
abstract AbstractTexture(Null<Int>) to Int from Int
{
	static var coreTextures = new Map<Int, BaseTexture>();
	public var coreTexture(get, never):BaseTexture;
	
	
	private var textureData(get, never):ITextureData;
	public var nativeTexture(get, never):Texture;
	public var textureBase(get, never):TextureBase;
	public var textureId(get, never):Int;
	public var width(get, never):Null<Int>;
	public var height(get, never):Null<Int>;
	public var onUpdate(get, never):Signal0;
	public var clearColour(get, never):Color;
	private var _clear(get, never):Bool;
	public var _alreadyClear(get, set):Bool;
	public var directRender(get, set):Bool;
	
	public function new(baseTexture:BaseTexture) 
	{
		this = baseTexture.textureId;
		
		coreTextures.set(this, baseTexture);
	}
	
	function get_coreTexture():BaseTexture		{ return coreTextures.get(this);				}
	function get_textureData():ITextureData		{ return coreTexture.textureData;				}
	function get_nativeTexture():Texture		{ return coreTexture.nativeTexture;				}
	function get_textureBase():TextureBase		{ return coreTexture.textureBase;				}
	function get_textureId():Int				{ return coreTexture.textureId;					}
	function get_width():Null<Int>				{ return coreTexture.width;						}
	function get_height():Null<Int>				{ return coreTexture.height;					}
	function get_onUpdate():Signal0 			{ return coreTexture.onUpdate;					}
	function get_clearColour():Color			{ return coreTexture.clearColour;				}
	function get__clear():Bool					{ return coreTexture._clear;					}
	function get__alreadyClear():Bool			{ return coreTexture._alreadyClear;				}
	function set__alreadyClear(value:Bool):Bool	{ return coreTexture._alreadyClear = value;		}
	function get_directRender():Bool			{ return coreTexture.directRender;				}
	function set_directRender(value:Bool):Bool 	{ return coreTexture.directRender = value;		}
	
	private function upload():Void			{	coreTexture.upload();							}
	public function dispose():Void			{	coreTexture.dispose();							}
}