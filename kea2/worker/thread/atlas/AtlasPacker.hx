package kea2.worker.thread.atlas;

import kea2.worker.thread.display.TextureOrder;
import kea2.core.memory.data.textureData.TextureData;
import kea2.worker.thread.display.TextureRenderBatch;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class AtlasPacker
{
	//public var textureDataMap = new Map<Int, TextureData>();
	var textureUsageMap = new Map<Int, TextureUsage>();
	var newTextures:Array<TextureUsage> = [];
	
	var sheets:Array<SheetPacker> = [];
	 
	public function new() 
	{
		for (i in 0...5) 
		{
			sheets.push(new SheetPacker(i));
		}
	}
	
	//public function update() 
	//{
		//for (i in 0...textureOrder.textureDefArray.length) 
		//{
			//var textureUsage:TextureUsage = textureUsageMap.get(textureOrder.textureDefArray[i].textureId);
			//trace("textureUsage.textureId = " + textureUsage.textureId);
			//trace([textureUsage.textureData.width, textureUsage.textureData.height, textureUsage.textureData.p2Width, textureUsage.textureData.p2Height]);
			//
			//
		//}
		///*while (newTextures.length > 0) 
		//{
			//var textureUsage:TextureUsage = newTextures.shift();
			//
		//}*/
	//}
	
	public function update() 
	{
		if (WorkerCore.textureOrder.textureDefArray.length > 0) {
			
			//trace("WorkerCore.textureOrder.textureDefArray = " + WorkerCore.textureOrder.textureDefArray);
			
			pack(0, 0);
			
			setVertexData();
			//WorkerCore.textureOrder.textureDefArray = [];
		}
		//trace("sheets = " + sheets);
	}
	
	function pack(sheetIndex:Int=0, startIndex:Int=0) 
	{
		//trace("sheetIndex = " + sheetIndex);
		//trace("startIndex = " + startIndex);
		
		if (sheetIndex >= sheets.length) return;
		
		var sheet:SheetPacker = sheets[sheetIndex];
		var endIndex:Int = sheet.pack(startIndex);
		//trace("endIndex = " + endIndex);
		
		if (endIndex < WorkerCore.textureOrder.textureDefArray.length) {
			pack(sheetIndex + 1, endIndex);
		}
	}
	
	function setVertexData() 
	{
		
	}
	
	public function registerTexture(textureId:Int):TextureData
	{
		if (!textureUsageMap.exists(textureId)) {
			var textureUsage:TextureUsage = new TextureUsage(textureId);
			textureUsageMap.set(textureId, textureUsage);
			newTextures.push(textureUsage);
		}
		var textureUsage:TextureUsage = textureUsageMap.get(textureId);
		textureUsage.activeCount++;
		return textureUsage.textureData;
	}
	
	public function removeTexture(textureId:Int) 
	{
		if (textureUsageMap.exists(textureId)) {
			var textureUsage:TextureUsage = textureUsageMap.get(textureId);
			textureUsage.activeCount--;
			if (textureUsage.activeCount == 0) {
				textureUsageMap.remove(textureId);
			}
		}
	}
}

class TextureUsage
{
	public var textureId:Int;
	public var activeCount:Int = 0;
	public var textureData:TextureData;
	
	public function new(textureId:Int)
	{
		this.textureId = textureId;
		textureData = new TextureData(textureId);
	}
}