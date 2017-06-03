package kea2.worker.thread.display;

import kea.notify.Notifier;
import kea2.core.memory.data.batchData.BatchData;
import kea2.worker.thread.display.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */
class TextureOrder
{
	public var textureStartIndex:Null<Int>;
	public var textureEndIndex:Null<Int>;
	public var textureIds = new Notifier<Int>();
	var currentTextureDef:TextureDef;
	var textureDefArray:Array<TextureDef> = [];
	var batchDataArray:Array<BatchData> = [];
	var length:Int = 0;
	
	public function new() 
	{
		textureIds.add(OnTextureIdChange);
	}
	
	public function begin() 
	{
		currentTextureDef = null;
		//textureDefArray = [];
		length = 0;
	}
	
	function OnTextureIdChange() 
	{
		if (currentTextureDef == null || currentTextureDef.textureIdArray.length >= 4){
			if (currentTextureDef != null) {
				currentTextureDef.length = textureStartIndex - currentTextureDef.startIndex;
			}
			
			if (textureDefArray.length <= length) {
				currentTextureDef = { 
					startIndex:textureStartIndex,
					textureIds:new Map<Int, Int>(),
					textureIdArray:[]
				};
				textureDefArray.push(currentTextureDef);
			}
			else {
				currentTextureDef = textureDefArray[length];
				currentTextureDef.startIndex = textureStartIndex;
				//currentTextureDef.textureIds = new Map<Int, Int>();
				for (i in 0...currentTextureDef.textureIdArray.length)
				{
					currentTextureDef.textureIds.remove(currentTextureDef.textureIdArray[i]);
				}
				currentTextureDef.textureIdArray.splice(0, currentTextureDef.textureIdArray.length);
				/*for (key in currentTextureDef.textureIds.keys()) 
				{
					currentTextureDef.textureIds.remove(key);
				}*/
				//currentTextureDef.textureIdArray = [];
			}
			length++;
		}
		if (!currentTextureDef.textureIds.exists(textureIds.value)) {
			currentTextureDef.textureIdArray.push(textureIds.value);
			currentTextureDef.textureIds.set(textureIds.value, textureIds.value);
		}
		
		
	}
	
	
	
	public function end() 
	{
		if (currentTextureDef != null) {
			currentTextureDef.length = textureEndIndex - currentTextureDef.startIndex;
		}
		
		for (j in 0...length) 
		{
			//trace([textureDefArray[j].textureId, textureDefArray[j].startIndex, textureDefArray[j].length]);
			var batchData:BatchData = getBatchData(j);
			batchData.startIndex = textureDefArray[j].startIndex;
			batchData.length = textureDefArray[j].length;
			batchData.textureId1 = setValue(textureDefArray[j].textureIdArray, 0);
			batchData.textureId2 = setValue(textureDefArray[j].textureIdArray, 1);
			batchData.textureId3 = setValue(textureDefArray[j].textureIdArray, 2);
			batchData.textureId4 = setValue(textureDefArray[j].textureIdArray, 3);
		}
		
		Conductor.conductorDataAccess.numberOfBatches = length;
		// TODO: Need to clear any unused batchDatas here!
	}
	
	function setValue(textureIdArray:Array<Int>, index:Int):Null<Int>
	{
		if (index < textureIdArray.length) return textureIdArray[index];
		return null;
	}
	
	public function getBatchData(objectId:Int) 
	{
		if (objectId >= batchDataArray.length) {
			var batchData:BatchData = new BatchData(objectId);
			batchDataArray.push(batchData);
		}
		return batchDataArray[objectId];
	}
	
	public function getTextureIndex(textureId:Int) 
	{
		if (currentTextureDef == null) return 0;
		for (i in 0...currentTextureDef.textureIdArray.length) 
		{
			if (currentTextureDef.textureIdArray[i] == textureId) return i;
		}
		return 0;
	}
	
	private function mapCounterItem(map:Map<Int,Dynamic>):Int
	{ 
		var ret = 0; 
		for (_ in map.keys()) ret++; 
		return ret; 
	} 
}

typedef TextureDef =
{
	startIndex:Int,
	textureIds:Map<Int, Int>,
	textureIdArray:Array<Int>,
	?length:Int
}