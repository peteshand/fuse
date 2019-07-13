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

	var texturesMap = new Map<TextureId, CoreTexture>();
	var textures = new Array<CoreTexture>();

	// var count:Int = 0;

	public function new() {}

	public function checkForTextureChanges():Void {
		/*
			texturesHaveChanged = false;

			for (i in 0...textures.length) {
				textures[i].checkForChanges();

				if (textures[i].textureHasChanged) {
					//count = -1;
					texturesHaveChanged = true;
				}
			}
		 */

		// trace("textures.length = " + textures.length);
		if (texturesHaveChanged) {
			Fuse.current.conductorData.backIsStatic = 0;
		}

		// count++;
		// if (count <= 2) {
		// texturesHaveChanged = true;
		// }
		// else {
		// texturesHaveChanged = false;
		// }
	}

	public function create(textureRef:TextureRef) {
		if (!texturesMap.exists(textureRef.objectId)) {
			var texture:CoreTexture = new CoreTexture(textureRef);
			texturesMap.set(textureRef.objectId, texture);
			textures.push(texture);
		}
	}

	public function update(objectId:ObjectId) {
		var texture:CoreTexture = texturesMap.get(objectId);
		if (texture != null)
			texture.update();
	}

	public function updateSurface(objectId:ObjectId) {
		var texture:CoreTexture = texturesMap.get(objectId);
		if (texture != null) {
			// TODO: amend so altas isn't recalulated every frame
			// if (texture.textureData.directRender == 0) {
			//trace("FIX");
			texturesHaveChanged = true;
			// }
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
