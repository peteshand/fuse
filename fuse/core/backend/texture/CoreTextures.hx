package fuse.core.backend.texture;

import fuse.utils.ObjectId;
import fuse.core.front.texture.TextureRef;
import fuse.texture.TextureId;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.backend.texture.CoreTexture)
class CoreTextures {
	public static var texturesHaveChanged:Bool = false;
	public static var atlasTxtsHaveChanged:Bool = false;

	var texturesMap = new Map<TextureId, CoreTexture>();
	var textures = new Array<CoreTexture>();

	public var renderTextures = new Array<CoreRenderTexture>();

	public function new() {}

	public function checkForTextureChanges():Void {
		if (texturesHaveChanged) {
			// trace("backIsStatic 6");
			Fuse.current.conductorData.backIsStatic = 0;
		}
	}

	public function create(textureRef:TextureRef) {
		var texture:CoreTexture = get(textureRef.objectId);
		if (texture == null) {
			if (textureRef.renderTexture) {
				var renderTexture = new CoreRenderTexture(textureRef);
				renderTextures.push(renderTexture);
				texture = renderTexture;
			} else {
				texture = new CoreTexture(textureRef);
			}
			texturesMap.set(textureRef.objectId, texture);
			textures.push(texture);
		}
		return texture;
	}

	public function update(objectId:ObjectId) {
		var texture:CoreTexture = get(objectId);
		if (texture != null)
			texture.update();
	}

	public function get(objectId:ObjectId) {
		return texturesMap.get(objectId);
	}

	public function getRenderTexture(objectId:ObjectId) {
		for (renderTexture in renderTextures) {
			if (renderTexture.objectId == objectId)
				return renderTexture;
		}
		return null;
	}

	public function updateSurface(objectId:ObjectId) {
		var texture:CoreTexture = texturesMap.get(objectId);
		if (texture != null) {
			// TODO: amend so altas isn't recalulated every frame
			if (texture.textureData.directRender != 1) {
				// trace("FIX");
				atlasTxtsHaveChanged = true;
			}
			texturesHaveChanged = true;
			// trace([atlasTxtsHaveChanged, texturesHaveChanged, texture.textureData.directRender]);
			texture.updateSurface();
		}
	}

	public function dispose(objectId:ObjectId):Void {
		if (texturesMap.exists(objectId)) {
			var i:Int = textures.length - 1;
			while (i >= 0) {
				if (textures[i].objectId == objectId) {
					textures.splice(i, 1);
				}
				i--;
			}
			texturesMap.remove(objectId);
		}
	}

	public function register(textureId:ObjectId):CoreTexture {
		var texture:CoreTexture = texturesMap.get(textureId);
		if (texture != null)
			texture.activeCount++;
		return texture;
	}

	public function deregister(textureId:ObjectId) {
		if (texturesMap.exists(textureId)) {
			var texture:CoreTexture = texturesMap.get(textureId);
			texture.activeCount--;
		}
	}

	// public function clearTextureChanges()
	// {
	// for (i in 0...textures.length)
	// {
	// textures[i].clearTextureChange();
	// }
	// }

	public function reset() {
		for (i in 0...textures.length) {
			textures[i].uvsHaveChanged = false;
		}
	}
}
