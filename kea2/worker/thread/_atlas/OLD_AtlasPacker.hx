package kea2.worker.thread.atlas;

import kea2.worker.thread.display.TextureOrder;

/**
 * ...
 * @author P.J.Shand
 */
class OLD_AtlasPacker
{
	var textureOrder:TextureOrder;
	var sheets:Array<SheetPacker> = [];
	
	public function new(textureOrder:TextureOrder) 
	{
		this.textureOrder = textureOrder;
		for (i in 0...5) 
		{
			sheets.push(new SheetPacker(textureOrder, i));
		}
	}
	
	public function update() 
	{
		if (textureOrder.textureDataArray.length > 0) {
			
			trace("textureOrder.textureOrder = " + textureOrder.textureDataArray);
			
			pack(0, 0);
			
			textureOrder.textureDataArray = [];
		}
	}
	
	function pack(sheetIndex:Int=0, startIndex:Int=0) 
	{
		if (sheetIndex >= sheets.length) return;
		
		var sheet:SheetPacker = sheets[sheetIndex];
		var endIndex:Int = sheet.pack(startIndex);
		if (endIndex < textureOrder.textureDataArray.length) {
			pack(sheetIndex + 1, endIndex);
		}
	}
}