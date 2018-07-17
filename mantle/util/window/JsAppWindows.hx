package mantle.util.window;

import mantle.notifier.Notifier;
import mantle.util.window.JsAppWindows.JsAppWindow;
import js.Browser;
import js.Lib;
import js.html.Event;
import js.html.Window;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;

/**
 * ...
 * @author Thomas Byrne
 */
class JsAppWindows
{
	static var VIS_API_PROPS = ["hidden", "msHidden", "webkitHidden"];
	static var VIS_API_EVENTS = ["visibilitychange", "msvisibilitychange", "webkitvisibilitychange"];
	
	public var createSupported(get, null) : Bool;
	public var hideSupported(get, null) : Bool;
	
	public var onAdded = new Signal1<JsAppWindow>();
	public var onRemoved = new Signal1<JsAppWindow>();

	
	public var list(get, null) : Array<JsAppWindow>;
	public var lastWindowClosing:Signal1<Void->Void> = new Signal1<Void->Void>();
	
	var _list:Array<JsAppWindow> = [];
	var visProp:String;
	var visEvent:String;

	public function new() 
	{
		checkSupport();
		windowAdded(Browser.window);
	}
	
	function checkSupport() 
	{
		var document = Browser.document;
		for (i in 0 ... VIS_API_PROPS.length){
			var prop:String = VIS_API_PROPS[i];
			if (untyped __typeof__(Reflect.field(document, prop)) != "undefined") {
				visProp = prop;
				visEvent = VIS_API_EVENTS[i];
				break;
			}
		}
	}
	
	function windowAdded(nativeWindow:Window) 
	{
		var window = new JsAppWindow(nativeWindow, visProp, visEvent);
		_list.push(window);
		window.closing.add(onWindowClosing);
		window.closed.add(onWindowClosed);
		onAdded.dispatch(window);
	}
	
	function onWindowClosed(from:JsAppWindow) 
	{
		from.closing.remove(onWindowClosing);
		from.closed.remove(onWindowClosed);
		_list.remove(from);
		onRemoved.dispatch(from);
	}
	
	function onWindowClosing(from:JsAppWindow, cancel:Void->Void) : Void
	{
		if (_list.length == 1){
			lastWindowClosing.dispatch(cancel);
		}
	}
	
	function get_hideSupported():Bool 
	{
		return false;
	}
	
	function get_createSupported(): Bool
	{
		return false;
	}
	public function create():JsAppWindow{
		throw "Not Supported (use createSupported to test support)";
	}
	
	function get_list():Array<JsAppWindow> 
	{
		return _list;
	}
	
	public function closeAll():Void
	{
		for (window in _list){
			window.doClose();
		}
	}
	public function hideAll():Void{
		throw "Not Supported (use hideSupported to test support)";
	}
	
	public function exit(exitCode:Int) 
	{
		// Ignore
	}
	
}

class JsAppWindow
{
	public var closing = new Signal2<JsAppWindow, Void->Void>();
	public var closed = new Signal1<JsAppWindow>();
	
	public var visible:Notifier<Bool> = new Notifier(true);
	public var focused:Notifier<Bool> = new Notifier(true);
	public var title:Notifier<String> = new Notifier();
	
	var window:Window;
	var ignoreChanges:Bool;
	
	var visProp:String;
	var visEvent:String;
	
	public function new(window:Window, visProp:String, visEvent:String) 
	{
		this.window = window;
		this.visProp = visProp;
		this.visEvent = visEvent;
		
		title.value = window.document.title;
		
		this.window.addEventListener("beforeunload", onBeginExit);
		this.window.addEventListener("unload", onExit);
		
		window.addEventListener("focus", onFocus);
		window.addEventListener("blur", onBlur);
		window.addEventListener("focusin", onFocus);
		window.addEventListener("focusout", onBlur);
		
		if (visProp != null){
			visible.value = !Reflect.field(window, visProp);
			window.addEventListener(visEvent, onVisChanged);
			
		}else{
			// IE 9 and earlier
			window.addEventListener("focusin", onShow);
			window.addEventListener("focusout", onHide);
			
			// Others
			window.addEventListener("pageshow", onShow);
			window.addEventListener("pagehide", onHide);
			window.addEventListener("focus", onShow);
			window.addEventListener("blur", onHide);
		}
		
		visible.add(onVisibleChange);
		focused.add(onFocusedChange);
		title.add(onTitleChange);
	}
	
	function onVisibleChange() 
	{
		if (ignoreChanges) return;
		visible.value = !visible.value;
	}
	function onFocusedChange() 
	{
		if (ignoreChanges) return;
		focused.value = !focused.value;
	}
	function onTitleChange() 
	{
		window.document.title = title.value;
	}
	
	private function onBlur(e:Event):Void 
	{
		ignoreChanges = true;
		focused.value = false;
		ignoreChanges = false;
	}
	private function onFocus(e:Event):Void 
	{
		ignoreChanges = true;
		focused.value = true;
		ignoreChanges = false;
	}
	
	private function onHide(e:Event):Void 
	{
		ignoreChanges = true;
		visible.value = false;
		ignoreChanges = false;
	}
	private function onShow(e:Event):Void 
	{
		ignoreChanges = true;
		visible.value = true;
		ignoreChanges = false;
	}
	
	private function onVisChanged(e:Event):Void 
	{
		ignoreChanges = true;
		visible.value = !Reflect.field(window, visProp);
		ignoreChanges = false;
	}
	
	function removeListeners() 
	{
		this.window.removeEventListener("beforeunload", onBeginExit);
		this.window.removeEventListener("unload", onExit);
		
		window.removeEventListener("focus", onFocus);
		window.removeEventListener("blur", onBlur);
		window.removeEventListener("focusin", onFocus);
		window.removeEventListener("focusout", onBlur);
		
		if (visProp != null){
			window.removeEventListener(visEvent, onVisChanged);
			
		}else{
			// IE 9 and earlier
			window.removeEventListener("focusin", onShow);
			window.removeEventListener("focusout", onHide);
			
			// Others
			window.removeEventListener("pageshow", onShow);
			window.removeEventListener("pagehide", onHide);
			window.removeEventListener("focus", onShow);
			window.removeEventListener("blur", onHide);
		}
	}
	
	private function onBeginExit(e:Event):Bool 
	{
		closing.dispatch(this, e.preventDefault);
		if (e.defaultPrevented){
			return js.Browser.window.confirm("You will loose unsaved work"); // This message will be replaced by most browsers;
		}else{
			return true;
		}
	}
	
	private function onExit(e:Event):Void 
	{
		removeListeners();
		closed.dispatch(this);
	}
	
	public function doClose():Void
	{
		removeListeners();
		close();
	}
	
	public function close():Void
	{
		try{
			this.window.close();
			
		}catch (e:Dynamic){
			this.window.history.back();
		}
	}
	
}