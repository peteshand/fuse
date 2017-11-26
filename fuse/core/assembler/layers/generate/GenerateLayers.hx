package fuse.core.assembler.layers.generate;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.backend.display.CoreImage;
import fuse.core.utils.Pool;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class GenerateLayers
{
	static var isStatic:Notifier<Int>;
	static var currentLayerBuffer:LayerBuffer;
	
	static function __init__() 
	{
		isStatic = new Notifier<Int>();
		isStatic.add(OnStaticChange);
	}
	
	static function clear() 
	{
		isStatic.value = -1;
		LayerBufferAssembler.directLayers.clear();
		LayerBufferAssembler.activeLayers.clear();
		Pool.layerBufferes.forceReuse();
	}
	
	static public function build() 
	{
		clear();
		for (i in 0...HierarchyAssembler.hierarchy.length) 
		{
			var image:CoreImage = HierarchyAssembler.hierarchy[i];
			isStatic.value = image.isStatic;
			currentLayerBuffer.add(image);
		}
	}
	
	static private function OnStaticChange() 
	{
		if (isStatic.value == -1) return;
		
		currentLayerBuffer = Pool.layerBufferes.request();
		currentLayerBuffer.init(isStatic.value, LayerBufferAssembler.directLayers.length);
		LayerBufferAssembler.directLayers.push(currentLayerBuffer);
	}
}