package fuse.core.assembler.layers.generate;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.assembler.layers.sort.SortLayers;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.CoreTextures;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class GenerateLayers
{
	public static var layers = new GcoArray<LayerBuffer>([]);
	//public static var lastLayers = new GcoArray<LayerBuffer>([]);
	
	public static var layersGenerated:Bool = false;
	public static var drawCacheLayers:Bool = false;
	static var generationStaticCount:Int = 0;
	static var generateCacheAfterXFrames:Int = 60;
	static var update:Notifier<Null<Bool>>;
	static var currentLayerBuffer:LayerBuffer;
	
	static function __init__() 
	{
		update = new Notifier<Null<Bool>>();
		update.add(OnStaticChange);
	}
	
	static function clear() 
	{
		update.value = null;
		GenerateLayers.layers.clear();
		Pool.layerBufferes.forceReuse();
	}
	
	static public function build() 
	{
		//trace("DisplayList.hierarchyBuildRequired = " + DisplayList.hierarchyBuildRequired);
		//trace("CoreTextures.texturesHaveChanged = " + CoreTextures.texturesHaveChanged);
		//trace("Fuse.current.conductorData.frontStaticCount = " + Fuse.current.conductorData.frontStaticCount);
		
		if (DisplayList.hierarchyBuildRequired || CoreTextures.texturesHaveChanged || Fuse.current.conductorData.frontStaticCount <= 1) {
			//trace("1");
			generationStaticCount = 0;
			GenerateLayers.layersGenerated = true;
			GenerateLayers.drawCacheLayers = false;
		}
		else {
			GenerateLayers.layersGenerated = false;
			GenerateLayers.drawCacheLayers = false;
			
			if (generationStaticCount == generateCacheAfterXFrames) {
				GenerateLayers.layersGenerated = true;
				GenerateLayers.drawCacheLayers = true;
			}
			generationStaticCount++;
			
		}
		
		if (GenerateLayers.layersGenerated == true) {
			clear();
			
			if (GenerateLayers.drawCacheLayers){
				for (i in 0...HierarchyAssembler.hierarchy.length) 
				{
					var image:CoreImage = HierarchyAssembler.hierarchy[i];
					if (!image.visible) continue;
					
					update.value = false;
					currentLayerBuffer.add(image);
				}
			}
			else {
				for (i in 0...HierarchyAssembler.hierarchy.length) 
				{
					var image:CoreImage = HierarchyAssembler.hierarchy[i];
					if (!image.visible) continue;
					//if (!imageVisible(image)) continue;
					
					if (image.coreTexture.textureData.directRender == 1) {
						update.value = false;
					}
					else {
						update.value = image.updateAny;
						//trace("image.update = " + image.update);
					}
					
					currentLayerBuffer.add(image);
				}
			}
			
			//checkForLayerChanges();
		}
		
		//trace("GenerateLayers.layers = " + GenerateLayers.layers.length);
		//trace("GenerateLayers.layersGenerated = " + GenerateLayers.layersGenerated);
		//trace("GenerateLayers.drawCacheLayers = " + GenerateLayers.drawCacheLayers);	
	}
	
	static private function OnStaticChange() 
	{
		if (update.value == null) return;
		
		currentLayerBuffer = Pool.layerBufferes.request();
		currentLayerBuffer.init(update.value, GenerateLayers.layers.length);
		GenerateLayers.layers.push(currentLayerBuffer);
	}
}