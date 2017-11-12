package fuse.core.communication.data.batchData;

/**
 * @author P.J.Shand
 */

interface IBatchData 
{
	public var renderTargetId(get, set):Int;
	public var startIndex(get, set):Int;
	public var length(get, set):Int;
	public var textureIds(get, null):Array<Int>;
	public var textureId1(get, set):Int;
	public var textureId2(get, set):Int;
	public var textureId3(get, set):Int;
	public var textureId4(get, set):Int;
	public var numTextures(get, set):Int;
	public var numItems(get, set):Int;
	public var width(get, set):Int;
	public var height(get, set):Int;
	//public var firstIndex(get, null):Int;
}