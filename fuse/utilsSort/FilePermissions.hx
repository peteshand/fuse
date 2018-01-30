package fuse.utilsSort;

import fuse.utils.tick.Tick;
#if air
import flash.events.PermissionEvent;
import fuse.filesystem.File;
import flash.permissions.PermissionStatus;
import openfl.errors.Error;
#end
/**
 * ...
 * @author P.J.Shand
 */

@:rtti
class FilePermissions 
{
	public function new() { }
	
	static public function request(onComplete:Bool -> Void) 
	{
		#if air
		if (File.permissionStatus == PermissionStatus.GRANTED) {
			onComplete(true);
		}
		else {
			new FilePermissionChecker(onComplete);
		}
		
		#else
			onComplete(true);
		#end
	}
}

#if air
class FilePermissionChecker
{
	var requestPermission:Void->Void;
	var onComplete:Bool-> Void;
	var requesting:Bool;
	var file:File;
	
	public function new(onComplete:Bool -> Void)
	{
		file = new File();
		var requestPermission:Void -> Void = Reflect.getProperty(file, "requestPermission");
		if (requestPermission == null) {
			onComplete(true);
		}
		
		this.onComplete = onComplete;
		file.addEventListener(PermissionEvent.PERMISSION_STATUS, OnPermissionStatus);
		
		request();
		
		if (File.permissionStatus != PermissionStatus.GRANTED) {
			Tick.add(WaitForResponse);
		}
		
	}
	
	function request() 
	{
		try {
			requesting = true;
			requestPermission();
		}
		catch (e:Error) {
			trace("Error requesting file permissions: " + e.message);
			requesting = false;
			onComplete(false);
		}
	}
	
	function WaitForResponse(delta:Int) 
	{
		if (File.permissionStatus == PermissionStatus.GRANTED) {
			requesting = false;
			onComplete(true);
			Tick.remove(WaitForResponse);
		}
		else if (File.permissionStatus == PermissionStatus.DENIED) {
			//onComplete(false);
			request();
			trace("Filesystem permission denied by user");
		}
	}
	
	function OnPermissionStatus(e:PermissionEvent):Void 
	{
		
	}
}
#end