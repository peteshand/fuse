package fuse.core.communication.messageData;

/**
 * @author P.J.Shand
 */

typedef AddChildMsg =
{
	objectId:Int,
	displayType:Int,
	parentId:Int,
	addAtIndex:Int,
	childIds:Array<Int>
}