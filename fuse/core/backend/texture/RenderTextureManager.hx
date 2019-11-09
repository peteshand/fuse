package fuse.core.backend.texture;

import fuse.core.assembler.Assembler;
import fuse.core.backend.Conductor;
import fuse.core.backend.Core;
import fuse.core.communication.data.MemoryBlock;
import fuse.core.communication.data.renderTextureData.RenderTextureDrawData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.utils.ObjectPool;
import fuse.core.utils.Pool;
import fuse.core.backend.display.CoreDisplayObject;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class RenderTextureManager {
	static var start:Int;
	static var end:Int;
	static var lastStart:Int;
	static var lastEnd:Int;

	public static var renderTextureDataMap = new Map<Int, RenderTextureDrawData>();

	public static var textures = new Array<CoreTexture>();

	// public function new() {}

	public static function add(texture:CoreTexture) {
		textures.push(texture);
	}

	public static function remove(texture:CoreTexture) {
		var i:Int = textures.length - 1;
		while (i >= 0) {
			if (textures[i] == texture) {
				textures.splice(i, 1);
			}
			i--;
		}
	}

	public static function update() {
		// Will need to be reworked for New Assembler //

		// trace("Core.textures.renderTextures.length = " + Core.textures.renderTextures.length);
		start = Conductor.conductorData.renderTextureProcessIndex;
		end = Conductor.conductorData.renderTextureCountIndex;

		// trace("start = " + start);
		// trace("end = " + end);

		if (end > 0 && start != end) {
			// Core.hierarchyBuildRequired = true;

			for (i in start...end) {
				var renderTextureDrawData:RenderTextureDrawData = getMemoryBlock(i);
				// trace(renderTextureDrawData.renderTextureId);
				/*RenderTexture.currentRenderTargetId = renderTextureDrawData.renderTextureId;

					var rootWorkerDisplay:CoreDisplayObject = Core.displayList.get(renderTextureDrawData.displayObjectId);

					var clonedRoot:CoreDisplayObject = Pool.displayObjects.request();
					rootWorkerDisplay.copyTo(clonedRoot);

					Core.assembler.process(clonedRoot);

					clonedRoot.recursiveReleaseToPool(); */
			}

			Conductor.conductorData.renderTextureProcessIndex = Conductor.conductorData.renderTextureCountIndex = 0;
		}

		lastStart = start;
		lastEnd = end;
	}

	static function getMemoryBlock(index:Int):RenderTextureDrawData {
		if (!renderTextureDataMap.exists(index))
			renderTextureDataMap.set(index, new RenderTextureDrawData(index));
		return renderTextureDataMap.get(index);
	}
}
