package fuse.core.communication.messageData;

/**
 * @author P.J.Shand
 */

typedef SetChildIndexMsg =
{
	objectId:Int,
	displayType:Int,
	parentId:Int,
	index:Int,
	childIds:Array<Int>
}