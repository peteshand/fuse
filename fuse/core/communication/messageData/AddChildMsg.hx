package fuse.core.communication.messageData;

/**
 * @author P.J.Shand
 */
@:dox(hide)
typedef AddChildMsg =
{
	objectId:Int,
	displayType:Int,
	parentId:Int,
	addAtIndex:Int
}