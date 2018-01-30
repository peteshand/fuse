package fuse.robotlegs.window.logic;

import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeWindowDisplayState;
import flash.display.NativeWindowResize;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

import openfl.Lib;
import openfl.Vector;
import openfl.geom.Point;
import openfl.net.SharedObject;
import openfl.ui.MouseCursor;

import fuse.input.keyboard.Key;
import fuse.input.keyboard.Keyboard;
import fuse.utils.Notifier;
import fuse.utils.delay.Delay;
import fuse.window.AppWindow;

import fuse.robotlegs.window.model.WindowPositionModel;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
class WindowPositionLogic 
{
	@inject public var windowPositionModel:WindowPositionModel;
	
	public var draggableWindow:Bool = true;
	public var resizableWindow:Bool = true;
	public var resizePadding:Int = 10;
	
	@:isVar public var isMoving(default, null):Notifier<Bool> = new Notifier(false);
	@:isVar public var isResizing(default, null):Notifier<Bool> = new Notifier(false);
	
	var savedLocation:Point;
	var savedSize:Point;
	var sharedObject:SharedObject;
	var retainScreenPosition:Bool = true;
	var retainScreenSize:Bool = true;
	var isDown:Bool = false;
	var appWindow:AppWindow;
	public var active:Bool = true;
	
	static function __init__():Void
	{
		var ns:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,1509160700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1509160700,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4278190080,4278190080,4280164666,4294967295,4280164666,4278190080,4278190080,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4278190080,4278190080,4280164666,4294967295,4280164666,4278190080,4278190080,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4280164666,1509160700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0]);
		var we:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4280164666,0,0,0,0,0,0,0,0,0,0,0,4280164666,4280164666,1509160700,0,0,0,0,0,1526003452,4280164666,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4280164666,1526003452,0,0,0,1526003452,4280164666,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4280164666,1526003452,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4294967295,4294967295,4294967295,4280164666,1509160700,0,1509160700,4280164666,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4280164666,1526003452,0,0,0,1526003452,4280164666,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4280164666,1526003452,0,0,0,0,0,1526003452,4280164666,4280164666,0,0,0,0,0,0,0,0,0,0,0,4280164666,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
		var nwse:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4285888649,4278190080,4278190080,4278190080,4278190080,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4294967295,4294111994,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4293783541,4278190080,1576335100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4293256941,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4292993512,4278190080,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,1609889788,0,2161498079,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4115550567,4294967295,4115550567,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4115550567,4294967295,4149104999,2144720863,0,1609889788,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2144720863,4278190080,4294441215,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4149104999,4294441215,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1609889788,4278190080,4294111994,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4293783541,4294967295,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,4278190080,4278190080,4278190080,4278190080,4285888649,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
		var nesw:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,4278190080,4278190080,4278190080,4278190080,4285888649,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294441215,4294967295,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1609889788,4278190080,4294441215,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,4294111994,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4149104999,2144720863,4278190080,4293783541,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4115550567,4294967295,4149104999,2161498079,0,1609889788,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,1576335100,0,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294111994,4278190080,2144720863,4115550567,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4293783541,4115550567,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4293256941,4278190080,1609889788,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4294967295,4292993512,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4285888649,4278190080,4278190080,4278190080,4278190080,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
		
		setCursor(we, CursorID.westEast);
		setCursor(ns, CursorID.northSouth);
		setCursor(nesw, CursorID.northEastSouthWest);
		setCursor(nwse, CursorID.northWestSouthEast);
	}
	
	static function setCursor(vec:Vector<UInt>, id:String) 
	{
		var bmd:BitmapData = new BitmapData(23, 23, true, 0x00000000);
		bmd.setVector(bmd.rect, vec);
		
		var cursorData = new MouseCursorData();
		cursorData.hotSpot = new Point(bmd.width/2, bmd.height/2);
		cursorData.data = Vector.ofArray([bmd]);
		Mouse.registerCursor(id, cursorData);
	}
	
	public function new() { }
	
	public function initialize():Void
	{
		windowPositionModel.fullscreen.add(OnFullscreenChange);
		OnFullscreenChange();
		
		appWindow = new AppWindow(NativeApplication.nativeApplication.activeWindow);
	}
	
	function OnFullscreenChange() 
	{
		if (windowPositionModel.fullscreen.value) {
			removeListeners();
			
		}
		else {
			addListeners();
		}
	}
	
	function removeListeners() 
	{
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
		
		Keyboard.removePress(OnPressShift);
		Keyboard.removeRelease(OnReleaseShift);
	}
	
	function addListeners() 
	{
		
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
		
		Keyboard.onPress(Key.SHIFT, OnPressShift);
		Keyboard.onRelease(Key.SHIFT, OnReleaseShift);
	}
	
	function OnPressShift():Void 
	{
		if (!active) return;
		UpdateCursor(Lib.current.stage.mouseX, Lib.current.stage.mouseY, true);
	}
	
	function OnReleaseShift():Void 
	{
		if (!active) return;
		UpdateCursor(Lib.current.stage.mouseX, Lib.current.stage.mouseY, false);
	}
	
	function OnMouseDown(e:MouseEvent):Void 
	{
		if (!active) return;
		if (e.shiftKey) {
			if (appWindow == null) return;
			if(sharedObject != null){
				appWindow.onMove.add(OnUserMoveWindow);
				appWindow.onResize.add(OnUserMoveWindow);
			}
			//appWindow.addEventListener(NativeWindowBoundsEvent.MOVE, OnUserMoveWindow);
			isDown = true;
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
		}
	}
	
	private function OnMouseMove(e:MouseEvent):Void 
	{
		UpdateCursor(e.stageX, e.stageY, e.shiftKey);
		
		if (!isDown) return;
		
		if (appWindow.displayState == NativeWindowDisplayState.MAXIMIZED){
			var x = appWindow.x;
			var y = appWindow.y;
			var w = appWindow.width;
			var h = appWindow.height;
			appWindow.restore();
			appWindow.setBounds(x, y, w, h);
		}
		
		var nativeWindowResize:NativeWindowResize = null;
		if(resizableWindow){
			if (e.stageX <= resizePadding) {
				if (e.stageY <= resizePadding) {
					nativeWindowResize = NativeWindowResize.TOP_LEFT;
				}
				else if (e.stageY >= Lib.current.stage.stageHeight - resizePadding) {	
					nativeWindowResize = NativeWindowResize.BOTTOM_LEFT;
				}
				else {
					nativeWindowResize = NativeWindowResize.LEFT;
				}
			}
			else if (e.stageX >= Lib.current.stage.stageWidth - resizePadding) {	
				if (e.stageY <= resizePadding) {
					nativeWindowResize = NativeWindowResize.TOP_RIGHT;
				}
				else if (e.stageY >= Lib.current.stage.stageHeight - resizePadding) {	
					nativeWindowResize = NativeWindowResize.BOTTOM_RIGHT;
				}
				else {
					nativeWindowResize = NativeWindowResize.RIGHT;
				}
			}
			else if (e.stageY <= resizePadding) {
				nativeWindowResize = NativeWindowResize.TOP;
			}
			else if (e.stageY >= Lib.current.stage.stageHeight - resizePadding) {	
				nativeWindowResize = NativeWindowResize.BOTTOM;
			}
			else if (draggableWindow) {
				isMoving.value = true;
				appWindow.startMove();
			}
		}else if (draggableWindow){
			isMoving.value = true;
			appWindow.startMove();
		}
		
		if (nativeWindowResize != null) {
			isResizing.value = true;
			appWindow.startResize(nativeWindowResize);
		}
	}
	
	function UpdateCursor(_x:Float, _y:Float, shiftDown:Bool) 
	{
		if (appWindow == null) return;
		
		if (shiftDown && active) {
			if(resizableWindow){
				if (_x <= resizePadding) {
					if (_y <= resizePadding) {
						Mouse.cursor = CursorID.northWestSouthEast;
					}
					else if (_y >= Lib.current.stage.stageHeight - resizePadding) {	
						Mouse.cursor = CursorID.northEastSouthWest;
					}
					else {
						Mouse.cursor = CursorID.westEast;
					}
				}
				else if (_x >= Lib.current.stage.stageWidth - resizePadding) {	
					if (_y <= resizePadding) {
						Mouse.cursor = CursorID.northEastSouthWest;
					}
					else if (_y >= Lib.current.stage.stageHeight - resizePadding) {	
						Mouse.cursor = CursorID.northWestSouthEast;
					}
					else {
						Mouse.cursor = CursorID.westEast;
					}
				}
				else if (_y <= resizePadding) {
					Mouse.cursor = CursorID.northSouth;
				}
				else if (_y >= Lib.current.stage.stageHeight - resizePadding) {	
					Mouse.cursor = CursorID.northSouth;
				}
				else{
					Mouse.cursor = (draggableWindow ? MouseCursor.HAND : MouseCursor.AUTO);
				}
			}else{
				Mouse.cursor = (draggableWindow ? MouseCursor.HAND : MouseCursor.AUTO);
			}
		}
		else {
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
	
	private function OnMouseUp(e:MouseEvent):Void 
	{
		if (!isDown) return;
		
		if(sharedObject != null){
			appWindow.onMove.remove(OnUserMoveWindow);
			appWindow.onResize.remove(OnUserMoveWindow);
		}
		//appWindow.removeEventListener(NativeWindowBoundsEvent.MOVE, OnUserMoveWindow);
		UpdateCursor(e.stageX, e.stageY, e.shiftKey);
		isDown = false;
		isMoving.value = false;
		isResizing.value = false;
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
	}
	
	private function SetLoc():Void 
	{
		trace("appWindow.displayState = " + appWindow.displayState);
		
		if (savedLocation != null && savedSize != null){
			appWindow.setBounds(savedLocation.x, savedLocation.y, savedSize.x, savedSize.y);
		}else{
			if (savedLocation != null){
				appWindow.moveTo(savedLocation.x, savedLocation.y);
			}
			if (savedSize != null){
				appWindow.resizeTo(savedSize.x, savedSize.y);
			}
		}
	}
	
	private function OnUserMoveWindow():Void 
	{
		if (appWindow.displayState != NativeWindowDisplayState.NORMAL) return;
		
		Delay.killDelay(SaveData);
		Delay.byFrames(10, SaveData);
	}
	
	private function SaveData():Void 
	{
		if (retainScreenPosition) {
			sharedObject.data.x = Std.int(appWindow.x);
			sharedObject.data.y = Std.int(appWindow.y);
		}
		if (retainScreenSize) {
			sharedObject.data.width = Std.int(appWindow.width);
			sharedObject.data.height = Std.int(appWindow.height);
		}
		
		sharedObject.flush();
	}
	
}

@:enum
abstract CursorID(String) from String to String
{
    var westEast = "we";
	var northSouth = "ns";
	var northEastSouthWest = "nesw";
	var northWestSouthEast = "nwse";
	
	@:to private static function toMouseCursor(cursor:CursorID):MouseCursor {
		
		return cast cursor;
	}
}