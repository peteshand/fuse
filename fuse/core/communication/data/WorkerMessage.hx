package fuse.core.communication.data;
import fuse.core.communication.messageData.WorkerPayload;

/**
 * @author P.J.Shand
 */
@:dox(hide)
typedef WorkerMessage =
{
	name:String,
	?payload:WorkerPayload
}