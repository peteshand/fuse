package fuse.core.communication.data;
import fuse.core.communication.messageData.WorkerPayload;

/**
 * @author P.J.Shand
 */
typedef WorkerMessage =
{
	name:String,
	?payload:WorkerPayload
}