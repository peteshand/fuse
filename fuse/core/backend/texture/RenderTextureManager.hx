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
	var start:Int;
	var end:Int;
	var lastStart:Int;
	var lastEnd:Int;

	public var renderTextureDataMap = new Map<Int, RenderTextureDrawData>();

	public function new() {}

	public function update() {
		// Will need to be reworked for New Assembler //

		/*start = Conductor.conductorData.renderTextureProcessIndex;
			end = Conductor.conductorData.renderTextureCountIndex;

			if (end > 0 && start != end) {
				Core.hierarchyBuildRequired = true;

				for (i in start...end)
				{
					var renderTextureDrawData:RenderTextureDrawData = getMemoryBlock(i);
					RenderTexture.currentRenderTargetId = renderTextureDrawData.renderTextureId;

					var rootWorkerDisplay:CoreDisplayObject = Core.displayList.get(renderTextureDrawData.displayObjectId);

					var clonedRoot:CoreDisplayObject = Pool.displayObjects.request();
					rootWorkerDisplay.copyTo(clonedRoot);

					Core.assembler.process(clonedRoot);

					clonedRoot.recursiveReleaseToPool();
				}



				Conductor.conductorData.renderTextureProcessIndex = Conductor.conductorData.renderTextureCountIndex = 0;
			}


			lastStart = start;
			lastEnd = end; */
	}

	function getMemoryBlock(index:Int):RenderTextureDrawData {
		if (!renderTextureDataMap.exists(index))
			renderTextureDataMap.set(index, new RenderTextureDrawData(index));
		return renderTextureDataMap.get(index);
	}
}
