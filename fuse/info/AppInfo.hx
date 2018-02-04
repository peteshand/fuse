package fuse.info;

#if air
	import flash.desktop.NativeApplication;
#end

#if openfl
	import openfl.Lib;
	import openfl.display.Stage;
#end

/**
 * ...
 * @author P.J.Shand
 */
class AppInfo
{
	@:isVar static public var appId(default, null):String;
	@:isVar static public var version(default, null):String;
	@:isVar static public var filename(default, null):String;
	
	static function __init__() 
	{
		#if air
			var appXml:Xml = Xml.parse(flash.desktop.NativeApplication.nativeApplication.applicationDescriptor.toXMLString());
			var firstNode:Xml = appXml.firstChild();
			appId = find(firstNode, "id");
			version = find(firstNode, "versionNumber");
			filename = find(firstNode, "filename");
		#elseif openfl
			var stage:Stage = Lib.current.stage;
			if (stage == null || stage.window == null) return;
			
			appId = stage.window.application.config.packageName;
			//appFilename = stage.window.application.config.name;
			version = stage.window.application.config.version;
		#end
	}
	
	static function find(xml:Xml, id:String):String
	{
		var node = xml.elementsNamed(id);
		while(node.hasNext()){
			return node.next().firstChild().nodeValue;
		}
		return null;
	}
}