package robotlegs.extensions.impl.utils.net;

import openfl.events.AsyncErrorEvent;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import openfl.events.IEventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.NetStatusEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;

/**
 * ...
 * @author P.J.Shand
 */
class ListenerUtil
{
	private static var listenerUtilObjects = new Map<IEventDispatcher, ListenerUtilObject>();
	
	public static function configureListeners(dispatcher:IEventDispatcher, OnSuccess:Void -> Void, OnFail:Void -> Void):Void {
		
		var listenerUtilObject:ListenerUtilObject = listenerUtilObjects.get(dispatcher);
		if (listenerUtilObject == null) {
			listenerUtilObject = new ListenerUtilObject();
		}	
		listenerUtilObject.configureListeners(dispatcher, OnSuccess, OnFail);
	}
	
	public static function removeListeners(dispatcher:IEventDispatcher):Void
	{
		var listenerUtilObject:ListenerUtilObject = listenerUtilObjects.get(dispatcher);
		if (listenerUtilObject != null) {
			listenerUtilObject.removeListeners(dispatcher);
			listenerUtilObjects.remove(dispatcher);
			listenerUtilObject.dispose();
			listenerUtilObject = null;
		}
	}
}

class ListenerUtilObject
{
	var OnSuccessFuncs:Array<Void-> Void> = [];
	var OnFailFuncs:Array<Void-> Void> = [];
	
	public function new ()
	{
		
	}
	
	public function configureListeners(dispatcher:IEventDispatcher, OnSuccess:Void -> Void, OnFail:Void -> Void):Void
	{
		this.OnFailFuncs.push(OnFail);
		this.OnSuccessFuncs.push(OnSuccess);
		
		dispatcher.addEventListener(Event.COMPLETE, OnLoadComplete);
		dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		dispatcher.addEventListener(Event.INIT, initHandler);
		dispatcher.addEventListener(Event.OPEN, openHandler);
		dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		
		dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//dispatcher.addEventListener(IOErrorEvent.NETWORK_ERROR, ioErrorHandler);
		dispatcher.addEventListener(ErrorEvent.ERROR, ioErrorHandler);
		dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ioErrorHandler);
		
		dispatcher.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		dispatcher.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
	}
	
	public function removeListeners(dispatcher:IEventDispatcher):Void {
		dispatcher.removeEventListener(Event.COMPLETE, OnLoadComplete);
		dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		dispatcher.removeEventListener(Event.INIT, initHandler);
		dispatcher.removeEventListener(Event.OPEN, openHandler);
		dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
		
		dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//dispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, ioErrorHandler);
		dispatcher.removeEventListener(ErrorEvent.ERROR, errorHandler);
		dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		
		dispatcher.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		dispatcher.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
	}
	
	public function dispose() 
	{
		OnSuccessFuncs = null;
		OnFailFuncs = null;
	}
	
	function OnLoadComplete(event:Event) 
	{
		OnSuccess();
		
	}
	
	function httpStatusHandler(event:HTTPStatusEvent):Void {
		//trace("httpStatusHandler: " + event);
	}

	function initHandler(event:Event):Void {
		//trace("initHandler: " + event);
	}
	
	function openHandler(event:Event):Void {
		//trace("openHandler: " + event);
	}
	
	function progressHandler(event:ProgressEvent):Void {
		var frac:Float = event.bytesLoaded / event.bytesTotal;
		//trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		//trace("progressHandler: " + frac);
		
	}

	function unLoadHandler(event:Event):Void {
		//trace("unLoadHandler: " + event);
	}
	
	function ioErrorHandler(event:IOErrorEvent):Void {
		//trace("ioErrorHandler: " + event);
		OnFail();
	}

	private function securityErrorHandler(event:SecurityErrorEvent):Void 
	{
		//trace("securityErrorHandler: " + event);
		OnFail();
	}
	
	private function errorHandler(event:ErrorEvent):Void 
	{
		//trace("errorHandler: " + event);
		OnFail();
	}
	
	private function onAsyncError(event:AsyncErrorEvent):Void 
	{
		//trace("onAsyncError: " + event);
		OnFail();
	}
	
	private function onNetStatus(event:NetStatusEvent):Void 
	{
		//trace("onNetStatus: " + event);
		event.preventDefault();
	}
	
	function OnSuccess() 
	{
		if (OnSuccessFuncs == null) return;
		for (i in 0...OnSuccessFuncs.length) 
		{
			OnSuccessFuncs[i]();
		}
	}
	
	function OnFail() 
	{
		if (OnFailFuncs == null) return;
		for (i in 0...OnFailFuncs.length) 
		{
			OnFailFuncs[i]();
		}
	}
}