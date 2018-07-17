package robotlegs.extensions.impl.commands.screenPosition;

import mantle.delay.Delay;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeWindowDisplayState;
import flash.display.NativeWindowResize;
import flash.events.NativeWindowBoundsEvent;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;
import flash.ui.MouseCursor;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.StageDisplayState;
import openfl.errors.Error;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;

/**
 * ...
 * @author P.J.Shand
 */
class ScreenPositionCommand extends Command 
{
	private var startLocation:Point;
	private var sharedObject:SharedObject;
	private var window:NativeWindow;
	private var resizePadding:Int = 10;
	
	@inject public var contextView:ContextView;
	@inject public var configModel:IConfigModel;
	//@inject("optional=true") public var configModel:IConfigModel;
	//@inject public var screenService:ScreenService;
	
	private var isDown:Bool = false;
	
	private var ns:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,1509160700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1509160700,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4278190080,4278190080,4280164666,4294967295,4280164666,4278190080,4278190080,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4278190080,4278190080,4280164666,4294967295,4280164666,4278190080,4278190080,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4294967295,4280164666,1509160700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0]);
	private var we:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1526003452,4280164666,4280164666,0,0,0,0,0,0,0,0,0,0,0,4280164666,4280164666,1509160700,0,0,0,0,0,1526003452,4280164666,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4280164666,1526003452,0,0,0,1526003452,4280164666,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4280164666,1526003452,0,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4294967295,4294967295,4294967295,4280164666,1526003452,4280164666,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4280164666,1526003452,4280164666,4294967295,4294967295,4294967295,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4280164666,4294967295,4294967295,4294967295,4280164666,1509160700,0,1509160700,4280164666,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4280164666,1526003452,0,0,0,1526003452,4280164666,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4280164666,1526003452,0,0,0,0,0,1526003452,4280164666,4280164666,0,0,0,0,0,0,0,0,0,0,0,4280164666,4280164666,1526003452,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
	private var nwse:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4285888649,4278190080,4278190080,4278190080,4278190080,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4294967295,4294111994,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4293783541,4278190080,1576335100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4293256941,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4292993512,4278190080,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,1609889788,0,2161498079,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4115550567,4294967295,4115550567,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4115550567,4294967295,4149104999,2144720863,0,1609889788,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2144720863,4278190080,4294441215,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4149104999,4294441215,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1609889788,4278190080,4294111994,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4293783541,4294967295,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,4278190080,4278190080,4278190080,4278190080,4285888649,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
	private var nesw:Vector<UInt> = Vector.ofArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,4278190080,4278190080,4278190080,4278190080,4285888649,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294441215,4294967295,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1609889788,4278190080,4294441215,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4294967295,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,4294111994,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4149104999,2144720863,4278190080,4293783541,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4115550567,4294967295,4149104999,2161498079,0,1609889788,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2161498079,4149104999,4294967295,4115550567,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,3614733960,4278190080,1576335100,0,2144720863,4149104999,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294111994,4278190080,2144720863,4115550567,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4293783541,4115550567,4294967295,4149104999,2161498079,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4149104999,2144720863,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4293256941,4278190080,1609889788,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4294967295,4294967295,4294967295,4292993512,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4285888649,4278190080,4278190080,4278190080,4278190080,4278190080,3614733960,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);

	private var RESIZE_WE:String = "we";
	private var RESIZE_NS:String = "ns";
	private var RESIZE_NESW:String = "nesw";
	private var RESIZE_NWSE:String = "nwse";
	
	public function ScreenPositionCommand() { }
	
	override public function execute():Void
	{
		if (configModel == null) return;
		
		window = getMainWindow();
		if (window == null) {
			Delay.nextFrame(execute);
			return;
		}
		
		if (configModel.retainScreenPosition) {
			sharedObject = SharedObject.getLocal("windowPosition");
			if (sharedObject.data.x != null || sharedObject.data.y != null) {
				startLocation = new Point();
			}
			if (sharedObject.data.x != null) {
				startLocation.x = sharedObject.data.x;
			}
			if (sharedObject.data.y != null) {
				startLocation.y = sharedObject.data.y;
			}
		}
		if (configModel.draggableWindow || configModel.resizableWindow) {
			contextView.view.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			contextView.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			contextView.view.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyChange);
			contextView.view.stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyChange);
		}
		
		/*var output:String = "VECTORS = \n";
		output += "	private var ns:Vector<UInt> = Vector.ofArray([" + Assets.getBitmapData("img/ns.png").getVector(new Rectangle(0, 0, 23, 23)) + "]);\n";
		output += "	private var we:Vector<UInt> = Vector.ofArray([" + Assets.getBitmapData("img/we.png").getVector(new Rectangle(0, 0, 23, 23)) + "]);\n";
		output += "	private var nwse:Vector<UInt> = Vector.ofArray([" + Assets.getBitmapData("img/nwse.png").getVector(new Rectangle(0, 0, 23, 23)) + "]);\n";
		output += "	private var nesw:Vector<UInt> = Vector.ofArray([" + Assets.getBitmapData("img/nesw.png").getVector(new Rectangle(0, 0, 23, 23)) + "]);\n";
		trace(output);*/
		
		
		setCursor(we, RESIZE_WE);
		setCursor(ns, RESIZE_NS);
		setCursor(nesw, RESIZE_NESW);
		setCursor(nwse, RESIZE_NWSE);
		
		if (startLocation != null) {
			//Delay.nextFrame(SetLoc);
			SetLoc();
		}
		
		
		//screenService.numberOfScreens.change.add(OnScreensChange);
	}
	
	function getMainWindow():NativeWindow
	{
		for (i in 0...NativeApplication.nativeApplication.openedWindows.length) 
		{
			return NativeApplication.nativeApplication.openedWindows[i];
		}
		return null;
	}
	
	//function OnScreensChange() 
	//{
		//SetLoc();
		//
		//if (configModel.fullscreenOnInit){
			//try {
				//contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//}
			//catch (e:Error) {
				//contextView.view.stage.displayState = StageDisplayState.FULL_SCREEN;
			//}
		//}
	//}
	
	function setCursor(vec:Vector<UInt>, id:String) 
	{
		var bmd:BitmapData = new BitmapData(23, 23, true, 0x00000000);
		bmd.setVector(bmd.rect, vec);
		
		var cursorData = new MouseCursorData();
		cursorData.hotSpot = new Point(bmd.width/2, bmd.height/2);
		cursorData.data = Vector.ofArray([bmd]);
		Mouse.registerCursor(id, cursorData);
	}
	
	private function OnKeyChange(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.SHIFT) {
			UpdateCursor(contextView.view.stage.mouseX, contextView.view.stage.mouseY, e.type == "keyDown");
		}
	}
	
	private function OnMouseDown(e:MouseEvent):Void 
	{
		if (e.shiftKey && contextView.view.stage.displayState == StageDisplayState.NORMAL) {
			window = NativeApplication.nativeApplication.activeWindow;
			if (window == null) return;
			window.addEventListener(NativeWindowBoundsEvent.MOVE, OnUserMoveWindow);
			isDown = true;
			contextView.view.stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
		}
	}
	
	private function OnMouseMove(e:MouseEvent):Void 
	{
		UpdateCursor(e.stageX, e.stageY, e.shiftKey);
		
		if (!isDown) return;
		
		var nativeWindowResize:NativeWindowResize = null;
		if (e.stageX <= resizePadding) {
			if (e.stageY <= resizePadding) {
				nativeWindowResize = NativeWindowResize.TOP_LEFT;
			}
			else if (e.stageY >= window.height - resizePadding) {	
				nativeWindowResize = NativeWindowResize.BOTTOM_LEFT;
			}
			else {
				nativeWindowResize = NativeWindowResize.LEFT;
			}
		}
		else if (e.stageX >= window.width - resizePadding) {	
			if (e.stageY <= resizePadding) {
				nativeWindowResize = NativeWindowResize.TOP_RIGHT;
			}
			else if (e.stageY >= window.height - resizePadding) {	
				nativeWindowResize = NativeWindowResize.BOTTOM_RIGHT;
			}
			else {
				nativeWindowResize = NativeWindowResize.RIGHT;
			}
		}
		else if (e.stageY <= resizePadding) {
			nativeWindowResize = NativeWindowResize.TOP;
		}
		else if (e.stageY >= window.height - resizePadding) {	
			nativeWindowResize = NativeWindowResize.BOTTOM;
		}
		else {
			window.startMove();
		}
		
		if (nativeWindowResize != null) {
			window.startResize(nativeWindowResize);
		}
	}
	
	function UpdateCursor(_x:Float, _y:Float, shiftDown:Bool) 
	{
		window = getMainWindow();
		if (window == null) return;
		
		if (shiftDown) {
			if (_x <= resizePadding) {
				if (_y <= resizePadding) {
					Mouse.cursor = RESIZE_NWSE;
				}
				else if (_y >= window.height - resizePadding) {	
					Mouse.cursor = RESIZE_NESW;
				}
				else {
					Mouse.cursor = RESIZE_WE;
				}
			}
			else if (_x >= window.width - resizePadding) {	
				if (_y <= resizePadding) {
					Mouse.cursor = RESIZE_NESW;
				}
				else if (_y >= window.height - resizePadding) {	
					Mouse.cursor = RESIZE_NWSE;
				}
				else {
					Mouse.cursor = RESIZE_WE;
				}
			}
			else if (_y <= resizePadding) {
				Mouse.cursor = RESIZE_NS;
			}
			else if (_y >= window.height - resizePadding) {	
				Mouse.cursor = RESIZE_NS;
			}
			else {
				Mouse.cursor = MouseCursor.HAND;
			}
		}
		else {
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
	
	private function OnMouseUp(e:MouseEvent):Void 
	{
		window.removeEventListener(NativeWindowBoundsEvent.MOVE, OnUserMoveWindow);
		UpdateCursor(e.stageX, e.stageY, e.shiftKey);
		isDown = false;
		contextView.view.stage.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
	}
	
	private function SetLoc():Void 
	{
		window = NativeApplication.nativeApplication.activeWindow;
		if (window == null) return;
		
		if (window.stage.displayState != StageDisplayState.NORMAL) return;
		
		if (startLocation != null){
			window.x = startLocation.x;
			window.y = startLocation.y;
		}
	}
	
	private function OnUserMoveWindow(e:NativeWindowBoundsEvent):Void 
	{
		if (window.stage.displayState != StageDisplayState.NORMAL) return;
		
		Delay.killDelay(SaveData);
		Delay.byFrames(10, SaveData);
	}
	
	private function SaveData():Void 
	{
		if (configModel.retainScreenPosition) {
			sharedObject.data.x = Std.int(window.x);
			sharedObject.data.y = Std.int(window.y);
			sharedObject.flush();
		}
	}
}