package kea.logic.buffers.atlas.packer;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.packer.AtlasPartition;
import kea.logic.buffers.atlas.packer.AtlasPartition.PlacementReturn;
import kea.logic.buffers.atlas.renderer.TextureAtlas;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasPacker
{
	var atlasBuffer:AtlasBuffer;
	var sheets:Array<SheetPacker> = [];
	
	public function new(atlasBuffer:AtlasBuffer) 
	{
		this.atlasBuffer = atlasBuffer;
		for (i in 0...atlasBuffer.atlases.length) 
		{
			sheets.push(new SheetPacker(atlasBuffer, i));
		}
		
	}
	
	public function pack(orderedlist:Array<AtlasItem>, sheetIndex:Int, startIndex:Int) 
	{
		/*if (sheetIndex != 0) {
			trace("sheetIndex = " + sheetIndex);
		}*/
		if (sheetIndex >= sheets.length) return;
		
		/*if (sheetIndex == sheets.length) {
			sheets.push(new SheetPacker(atlasBuffer, sheets.length));
		}*/
		
		var sheet:SheetPacker = sheets[sheetIndex];
		var endIndex:Int = sheet.pack(orderedlist, startIndex);
		if (endIndex < orderedlist.length) {
			pack(orderedlist, sheetIndex + 1, endIndex);
		}
	}	
}