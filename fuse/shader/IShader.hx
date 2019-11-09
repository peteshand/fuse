package fuse.shader;

import signals.Signal;
import openfl.display3D.Context3D;
import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */
interface IShader {
	var objectId:ObjectId;
	// private var hasChanged:Bool;
	var onUpdate:Signal;
	function activate(context3D:Context3D):Void;
	function deactivate(context3D:Context3D):Void;
	function vertexString():String;
	function fragmentString():String;
	function dispose():Void;
}
