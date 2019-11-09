package fuse.core.render;

import openfl.display3D.textures.VideoTexture;
import openfl.display3D.Context3D;
import fuse.core.front.texture.Textures;
import openfl.display3D.textures.TextureBase;
// #if air
import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.utils.Notifier)
@:access(openfl.display3D.Context3D)
class Context3DTexture {
	static var context3D:Context3D;
	static var contextTextureId1 = new Notifier<TextureBase>();
	static var contextTextureId2 = new Notifier<TextureBase>();
	static var contextTextureId3 = new Notifier<TextureBase>();
	static var contextTextureId4 = new Notifier<TextureBase>();
	static var contextTextureId5 = new Notifier<TextureBase>();
	static var contextTextureId6 = new Notifier<TextureBase>();
	static var contextTextureId7 = new Notifier<TextureBase>();
	static var contextTextureId8 = new Notifier<TextureBase>();
	static var contextTextureIds:Array<Notifier<TextureBase>> = [];

	public static function init(context3D:Context3D) {
		Context3DTexture.context3D = context3D;
		add(contextTextureId1, 0); // , SetContextTexture1);
		add(contextTextureId2, 1); // , SetContextTexture2);
		add(contextTextureId3, 2); // , SetContextTexture3);
		add(contextTextureId4, 3); // , SetContextTexture4);
		add(contextTextureId5, 4); // , SetContextTexture5);
		add(contextTextureId6, 5); // , SetContextTexture6);
		add(contextTextureId7, 6); // , SetContextTexture7);
		add(contextTextureId8, 7); // , SetContextTexture8);
	}

	public static function clear() {
		for (i in 0...contextTextureIds.length) {
			contextTextureIds[i].value = null;
		}
		// contextTextureId1.value = null;
		// contextTextureId2.value = null;
		// contextTextureId3.value = null;
		// contextTextureId4.value = null;
		// contextTextureId5.value = null;
		// contextTextureId6.value = null;
		// contextTextureId7.value = null;
		// contextTextureId8.value = null;
	}

	static function add(notifier:Notifier<TextureBase>, index:Int /*, SetContextTexture:Void -> Void*/) {
		contextTextureIds.push(notifier);
		// notifier.add(SetContextTexture);

		notifier.add(function() {
			context3D.setTextureAt(index, notifier.value);
		});
	}

	// static function SetContextTexture1():Void { trace("0, " + id(contextTextureId1.value)); context3D.setTextureAt(0, contextTextureId1.value); }
	// static function SetContextTexture2():Void { trace("1, " + id(contextTextureId2.value)); context3D.setTextureAt(1, contextTextureId2.value); }
	// static function SetContextTexture3():Void { trace("2, " + id(contextTextureId3.value)); context3D.setTextureAt(2, contextTextureId3.value); }
	// static function SetContextTexture4():Void { trace("3, " + id(contextTextureId4.value)); context3D.setTextureAt(3, contextTextureId4.value); }
	// static function SetContextTexture5():Void { trace("4, " + id(contextTextureId5.value)); context3D.setTextureAt(4, contextTextureId5.value); }
	// static function SetContextTexture6():Void { trace("5, " + id(contextTextureId6.value)); context3D.setTextureAt(5, contextTextureId6.value); }
	// static function SetContextTexture7():Void { trace("6, " + id(contextTextureId7.value)); context3D.setTextureAt(6, contextTextureId7.value); }
	// static function SetContextTexture8():Void { trace("7, " + id(contextTextureId8.value)); context3D.setTextureAt(7, contextTextureId8.value); }

	public static function setContextTexture(index:Int, textureId:Int) {
		var id:Null<Int> = Textures.getTextureId(textureId);
		var sampler = Textures.getTextureBase(id);

		#if html5
		// Hack to get around a bug in lime/openfl where video textures don't update
		if (Std.is(sampler, VideoTexture)) {
			contextTextureIds[index].value = null;
		}
		#end

		contextTextureIds[index].value = sampler;

		/*#if html5
				// Hack to get around a bug in lime/openfl where video textures don't update
				if (Std.is(sampler, VideoTexture)){
					var s:Int = untyped sampler;
					context3D.__samplerDirty |= (1 << s);
				}
			#end */
	}

	public static function id(texture:TextureBase) {
		for (key in Textures.textures.keys()) {
			if (Textures.textures.get(key).textureBase == texture)
				return key;
		}
		return -1;
	}
}

// #else
// class Context3DTexture
// {
// static var context3D:Context3D;
//
// public static function init(context3D:Context3D)
// {
// Context3DTexture.context3D = context3D;
// }
//
// public static function clear()
// {
//
// }
//
// public static function setContextTexture(index:Int, textureId:Int)
// {
// var id:Null<Int> = Textures.getTextureId(textureId);
// context3D.setTextureAt(index, Textures.getTextureBase(id));
// }
// }
// #end
