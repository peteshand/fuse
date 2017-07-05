package kea2.core.memory.data.textureData;

import kea2.core.atlas.packer.AtlasPartition;
import kea2.utils.Notifier;

/**
 * @author P.J.Shand
 */
interface ITextureData 
{
	public var memoryBlock:MemoryBlock;
	public var textureId:Int;
	
	public var x(get, set):Int;
	public var y(get, set):Int;
	public var width(get, set):Int;
	public var height(get, set):Int;
	public var p2Width(get, set):Int;
	public var p2Height(get, set):Int;
	
	public var baseX(get, set):Int;
	public var baseY(get, set):Int;
	public var baseWidth(get, set):Int;
	public var baseHeight(get, set):Int;
	public var baseP2Width(get, set):Int;
	public var baseP2Height(get, set):Int;
	
	public var textureAvailable(get, set):Int;
	
	public var area(get, null):Float;
	public var placed:Bool;
	
	public var atlasTextureId(get, set):Int;
	public var atlasBatchTextureIndex(get, set):Int;
}