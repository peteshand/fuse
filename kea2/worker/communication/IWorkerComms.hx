package kea2.worker.communication;
import kea2.worker.data.WorkerPayload;

/**
 * @author P.J.Shand
 */
interface IWorkerComms 
{
	var usingWorkers:Bool;
	function addListener(name:String, callback:WorkerPayload -> Void):Void;
	function send(name:String, payload:WorkerPayload = null):Void;
	
	function getSharedProperty(key : String) : Dynamic;
	function setSharedProperty(key : String, value : Dynamic) : Void;
}