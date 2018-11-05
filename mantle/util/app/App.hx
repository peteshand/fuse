package mantle.util.app;
import haxe.Json;
import notifier.Notifier;
import mantle.util.app.AppExit.ExitContinue;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.xml.Fast;


#if openfl
import openfl.Lib;
import openfl.display.Stage;
import openfl.events.Event;
#end

#if air
import mantle.util.window.AirAppWindows;
import flash.desktop.NativeApplication;
#elseif js
import js.html.Event;
#end

#if (air||js)
import mantle.util.window.AppWindows;
#end

/**
 * ...
 * @author Thomas Byrne
 */
 #if air
@:access(mantle.util.window.AirAppWindows)
#end
class App
{
	@:isVar static public var focused(get, null):Notifier<Bool>;
	static function get_focused():Notifier<Bool> 
	{
		setup();
		return focused;
	}
	
	static private var appId:String;
	static private var appExe:String;
	static private var version:String;
	static private var appFilename:String;
	
	#if (air||js)
	static public var windows(get, null):AppWindows;
	static function get_windows():AppWindows 
	{
		setup();
		return nativeWindows;
	}
	
	@:isVar static public var nativeWindows(get, null):NativeAppWindows;
	static function get_nativeWindows():NativeAppWindows 
	{
		setup();
		return nativeWindows;
	}
	#end
	
	#if js
	@:isVar static public var appElement(get, null):js.html.Element;
	static function get_appElement():js.html.Element 
	{
		if (appElement == null) appElement = js.Browser.document.getElementById("openfl-content");
		return appElement;
	}
	#end
	
	static private var isSetup:Bool;
	
	public static function getAppId():String 
	{
		checkManifest();
		return appId;
	}
	
	static public function getAppFilename() : String
	{
		checkManifest();
		return appFilename;
	}
	
	static public function getVersion() : String
	{
		checkManifest();
		return version;
	}
	
	static private function setup() 
	{
		if (isSetup) return;
		isSetup = true;
		
		focused = new Notifier(false);
		
		#if (air||js)
			App.nativeWindows = new NativeAppWindows();
			App.windows.foreach(onWindowAdd, onWindowRemove);
		#end
		
		checkManifest();
		
		AppExit.setup();
	}
	
	#if (air||js)
	static private function onWindowRemove(window:AppWindow) 
	{
		window.focused.add(onWindowFocusChanged);
		onWindowFocusChanged();
	}
	static private function onWindowAdd(window:AppWindow) 
	{
		window.focused.add(onWindowFocusChanged);
		if (window.focused.value) focused.value = true;
	}
	
	static private function onWindowFocusChanged() 
	{
		var focused:Bool = false;
		for (window in windows.list){
			if (window.focused.value){
				focused = true;
				break;
			}
		}
		App.focused.value = focused;
	}
	#end
	
	static public function exit(errorCode:Int = 0) 
	{
		AppExit.exit(errorCode);
	}
	
	/*static public function addExitConfirmer(handler:Int -> ExitContinue -> Void) 
	{
		AppExit.addExitConfirmer(handler);
		
	}
	static public function removeExitConfirmer(handler:Int -> ExitContinue -> Void) 
	{
		AppExit.removeExitConfirmer(handler);
	}
	
	
	static public function addExitCleanup(handler:Int -> (Void -> Void) -> Void) 
	{
		AppExit.addExitCleanup(handler);
		
	}
	static public function removeExitCleanup(handler:Int -> (Void -> Void) -> Void) 
	{
		AppExit.removeExitCleanup(handler);
	}*/
	
	#if air
	static public function getAppExe() 
	{
		if (appExe != null) return appExe;
		
		var appDir = flash.filesystem.File.applicationDirectory;
		checkManifest();
		appExe = appDir.resolvePath(appFilename + ".exe").nativePath;
		return appExe;
	}
	static public function getAppDir() 
	{
		return flash.filesystem.File.applicationDirectory.nativePath;
	}
	#end
	
	static private function checkManifest() 
	{
		if (appId != null) return;
		
		#if air
			var appXml:Xml = Xml.parse(flash.desktop.NativeApplication.nativeApplication.applicationDescriptor.toXMLString());
			var idNode = appXml.firstChild().elementsNamed("id");
			while(idNode.hasNext()){
				appId = idNode.next().firstChild().nodeValue;
				break;
			}
			var filenameNode = appXml.firstChild().elementsNamed("filename");
			while(filenameNode.hasNext()){
				appFilename = filenameNode.next().firstChild().nodeValue;
				break;
			}
			var versionNode = appXml.firstChild().elementsNamed("versionNumber");
			while(versionNode.hasNext()){
				version = versionNode.next().firstChild().nodeValue;
				break;
			}
		#elseif openfl
			var stage:Stage = Lib.current.stage;
			if (stage == null || stage.window == null) return;
			appId = stage.window.application.meta.get("packageName");
			appFilename = stage.window.application.meta.get("name");
			version = stage.window.application.meta.get("build");
		#end
	}
}