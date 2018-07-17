package mantle.util.window;
import mantle.notifier.Notifier;
import mantle.util.app.App;
import mantle.util.app.AppExit;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindowResize;
import flash.display.NativeWindowSystemChrome;
import flash.events.NativeWindowBoundsEvent;
import flash.events.NativeWindowDisplayStateEvent;
import flash.display.NativeWindowDisplayState;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import openfl.display.Stage;
import openfl.events.Event;

/**
 * Currently only supported in AIR
 * 
 * @author Pete Shand
 * @author Thomas Byrne
 */
@:access(mantle.util.app.AppExit)
class AirAppWindows
{
	public var createSupported(get, null): Bool;
	public var hideSupported(get, null): Bool;
	public var lastWindowClosing:Signal1<Void->Void> = new Signal1<Void->Void>();
	
	public var onAdded = new Signal1<AirAppWindow>();
	public var onRemoved = new Signal1<AirAppWindow>();
	
	@:isVar public var list(default, null) : Array<AirAppWindow> = [];
	
	var app:NativeApplication;
	var autoExit:Bool;

	public function new() 
	{
		app = NativeApplication.nativeApplication;
		autoExit = app.autoExit;
		app.autoExit = false;
		for (window in app.openedWindows){
			windowAdded(window);
		}
		app.addEventListener("exiting", onAppExiting);
	}
	
	private function onAppExiting(e:Event):Void 
	{
		AppExit.onLastWindowClosing(e.preventDefault);
	}
	
	/**
	 * Must manually call this method when a new window is opened.
	 * There is no event fired when a new window is opened.
	 */
	public function windowAdded(nativeWindow:NativeWindow) : AirAppWindow
	{
		var window = new AirAppWindow(nativeWindow);
		list.push(window);
		onAdded.dispatch(window);
		
		window.closing.add(onWindowClose);
		return window;
	}
	
	private function onWindowClose(from:AirAppWindow, cancel:Void->Void):Void 
	{
		if (autoExit && app.openedWindows.length == 0){
			var exitCode = from.pendingError;
			from.pendingError = 0;
			App.exit(exitCode);
		}
		
		list.remove(from);
		onRemoved.dispatch(from);
	}
	
	function get_hideSupported():Bool 
	{
		return true;
	}
	
	function get_createSupported():Bool 
	{
		return true;
	}
	
	public function create():AirAppWindow{
		var options = new NativeWindowInitOptions();
		var window = new NativeWindow(options);
		return windowAdded(window);
	}
	
	public function hideAll():Void
	{
		for (window in list){
			window.visible.value = false;
		}
	}
	
	public function closeAll():Void
	{
		for (window in list){
			window.close();
		}
	}
	
	public function exit(exitCode:Int) 
	{
		NativeApplication.nativeApplication.exit(exitCode);
	}
}

class AirAppWindow
{
	public var closing:Signal2<AirAppWindow, Void->Void> = new Signal2<AirAppWindow, Void->Void>();
	
	public var onMove(get, null):Signal0;
	public var onResize(get, null):Signal0;
	
	public var focused:Notifier<Bool> = new Notifier(false);
	public var visible:Notifier<Bool> = new Notifier(false);
	public var title:Notifier<String> = new Notifier();
	public var alwaysInFront:Notifier<Bool> = new Notifier(false);
	
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;
	
	public var nativeWindow(get, null):NativeWindow;
	
	public var contentsScaleFactor(get, null):Float;
	
	public var displayState(get, null):NativeWindowDisplayState;
	
	public var stage(get, null):Stage;
	
	var window:NativeWindow;
	var wasActive:Bool;
	var ignoreChanges:Bool;
	
	public var pendingError:Int = 0;
	
	
	public function new(window:NativeWindow) 
	{
		this.window = window;
		
		window.addEventListener(Event.CLOSING, onWindowClosing);
		window.addEventListener(Event.CLOSE, onWindowClose);
		window.addEventListener(Event.DEACTIVATE, onWindowDeactivate);
		
		window.addEventListener(Event.ACTIVATE, onWindowStateChange);
		window.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onWindowStateChange);
		
		title.value = window.title;
		alwaysInFront.value= window.alwaysInFront;
		
		focused.add(onFocusedChanged);
		visible.add(onVisibleChanged);
		title.add(onTitleChanged);
		alwaysInFront.add(onAlwaysInFrontChanged);
		
		onWindowStateChange();
	}
	
	function onAlwaysInFrontChanged() 
	{
		window.alwaysInFront = alwaysInFront.value;
	}
	
	function onTitleChanged() 
	{
		window.title = title.value;
	}
	
	inline public function startMove():Void
	{
		window.startMove();
	}
	inline public function startResize(resize:NativeWindowResize):Void
	{
		window.startResize(resize);
	}
	
	public function close():Void
	{
		window.close();
	}
	
	public function activate():Void
	{
		window.activate();
	}
	
	function onFocusedChanged() 
	{
		if (ignoreChanges) return;
		if (focused.value){
			window.activate();
		}
	}
	
	function onVisibleChanged() 
	{
		if (ignoreChanges) return;
		if (!wasActive){
			onWindowDeactivate();
			return;
		}
		
		//if (!visible.value) return;
		window.visible = visible.value;
	}
	
	private function onWindowStateChange(?e:Event):Void 
	{
		ignoreChanges = true;
		if (window.active) wasActive = true;
		visible.value = wasActive && window.displayState != NativeWindowDisplayState.MINIMIZED;
		focused.value = window.active;
		ignoreChanges = false;
	}
	
	private function onWindowDeactivate(?e:Event):Void 
	{
		ignoreChanges = true;
		visible.value = false;
		ignoreChanges = false;
	}
	
	private function onWindowClosing(e:Event):Void 
	{
		pendingError = (window.systemChrome == NativeWindowSystemChrome.NONE ? 1 : 0);
	}
	
	private function onWindowClose(e:Event):Void 
	{
		closing.dispatch(this, e.preventDefault);
		if (!e.isDefaultPrevented()){
			removeListeners();
		}
	}
	
	function removeListeners() 
	{
		window.removeEventListener(Event.CLOSING, onWindowClosing);
		window.removeEventListener(Event.CLOSE, onWindowClose);
		window.removeEventListener(Event.DEACTIVATE, onWindowDeactivate);
		
		window.removeEventListener(Event.ACTIVATE, onWindowStateChange);
		window.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onWindowStateChange);
	}
	
	function get_x():Float 
	{
		return window.x * window.stage.contentsScaleFactor;
	}
	
	function get_contentsScaleFactor():Float 
	{
		return window.stage.contentsScaleFactor;
	}
	
	function get_y():Float 
	{
		return window.y * window.stage.contentsScaleFactor;
	}
	
	function get_width():Float 
	{
		return window.width * window.stage.contentsScaleFactor;
	}
	
	function get_height():Float 
	{
		return window.height * window.stage.contentsScaleFactor;
	}
	
	function get_stage():Stage 
	{
		return window.stage;
	}
	
	function get_displayState():NativeWindowDisplayState 
	{
		return window.displayState;
	}
	
	public function moveTo(x:Float, y:Float):Void
	{
		var scale = window.stage.contentsScaleFactor;
		
		window.x = x / scale;
		window.y = y / scale;
		
		if (scale != window.stage.contentsScaleFactor){
			// moved to a different density screen
			scale = window.stage.contentsScaleFactor;
			window.x = x / scale;
			window.y = y / scale;
		}
	}
	
	function get_nativeWindow():NativeWindow 
	{
		return window;
	}
	
	public function resizeTo(width:Float, height:Float):Void
	{
		var scale = window.stage.contentsScaleFactor;
		
		window.width = width / scale;
		window.height = height / scale;
		
		if (scale != window.stage.contentsScaleFactor){
			// moved to a different density screen
			scale = window.stage.contentsScaleFactor;
			window.width = width / scale;
			window.height = height / scale;
		}
	}
	
	public function setBounds(x:Float, y:Float, width:Float, height:Float):Void
	{
		var scale = window.stage.contentsScaleFactor;
		
		window.x = x / scale;
		window.y = y / scale;
		window.width = width / scale;
		window.height = height / scale;
		
		if (scale != window.stage.contentsScaleFactor){
			// moved to a different density screen
			scale = window.stage.contentsScaleFactor;
			window.x = x / scale;
			window.y = y / scale;
			window.width = width / scale;
			window.height = height / scale;
		}
	}
	
	function get_onMove():Signal0 
	{
		if (onMove == null){
			onMove = new Signal0();
			window.addEventListener(NativeWindowBoundsEvent.MOVE, onNativeMove);
		}
		return onMove;
	}
	function get_onResize():Signal0 
	{
		if (onResize == null){
			onResize = new Signal0();
			window.addEventListener(NativeWindowBoundsEvent.RESIZE, onNativeResize);
		}
		return onResize;
	}
	
	private function onNativeMove(e:NativeWindowBoundsEvent):Void 
	{
		onMove.dispatch();
	}
	private function onNativeResize(e:NativeWindowBoundsEvent):Void 
	{
		onResize.dispatch();
	}
}