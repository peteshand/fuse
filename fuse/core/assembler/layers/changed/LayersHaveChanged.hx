package fuse.core.assembler.layers.changed;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.layers.LayerBufferAssembler.LayerState;
import fuse.core.backend.display.CoreImage;
import fuse.utils.GcoArray;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class LayersHaveChanged
{
	static var isStatic:Notifier<Int>;
	static var count:Int;
	static var index:Int;
	static var directLayers = new GcoArray<Int>([]);
	
	static function __init__() 
	{
		isStatic = new Notifier<Int>();
		isStatic.add(OnStaticChange);
	}
	
	static public function cheak() 
	{
		LayerBufferAssembler.STATE = LayerState.WRITE;
		count = 0;
		isStatic.value = -1;
		
		for (i in 0...HierarchyAssembler.hierarchy.length) 
		{
			index = i;
			var image:CoreImage = HierarchyAssembler.hierarchy[i];
			if (image.displayData.visible == 0) {
				// TODO: If not visible then the display probably shouldn't be added to the hierarchy before it gets to this point
				continue;
			}
			
			if (image.coreTexture.textureData.directRender == 1) {
				isStatic.value = 0;
			}
			else {
				isStatic.value = image.isStatic;
			}
			
			if (LayerBufferAssembler.STATE == LayerState.BAKE) return;
		}
	}
	
	static private function OnStaticChange() 
	{
		if (isStatic.value == -1) return;
		
		//trace([directLayers.length, isStatic.value, directLayers[count], index]);
		if (/*directLayers.length <= count || */directLayers[count] != index) {
			LayerBufferAssembler.STATE = LayerState.BAKE;
		}
		directLayers[count] = index;
		count++;
	}
}