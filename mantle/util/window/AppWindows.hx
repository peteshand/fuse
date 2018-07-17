package mantle.util.window;
import msignal.Signal.Signal1;

/**
 * @author Thomas Byrne
 */

#if js

typedef NativeAppWindows = JsAppWindows;
typedef NativeAppWindow = mantle.util.window.JsAppWindows.JsAppWindow;
@:forward(createSupported, hideSupported, hideAll, closeAll, exit, foreach, lastWindowClosing)
#else

typedef NativeAppWindows = AirAppWindows;
typedef NativeAppWindow = mantle.util.window.AirAppWindows.AirAppWindow;
@:forward(createSupported, hideSupported, hideAll, closeAll, exit, foreach, lastWindowClosing)
#end

abstract AppWindows(NativeAppWindows) from NativeAppWindows
{

	public var onAdded(get, never):Signal1<AppWindow>;
	public var onRemoved(get, never):Signal1<AppWindow>;

	@public public var list(get, never):Array<AppWindow>;

	public function new()
	{
		this = new NativeAppWindows();
	}

	function get_list():Array<AppWindow>
	{
		return this.list;
	}

	public function create():AppWindow
	{
		return this.create();
	}

	public function foreach (onAdd:AppWindow->Void, onRemove:AppWindow->Void):Void
	{
		this.onAdded.add(onAdd);
		this.onRemoved.add(onRemove);
		for (window in list)
		{
			onAdd(window);
		}
	}
	
	function get_onAdded():Signal1<NativeAppWindow> 
	{
		return untyped this.onAdded;
	}
	
	function get_onRemoved():Signal1<NativeAppWindow> 
	{
		return untyped this.onRemoved;
	}
}

@:forward()
abstract AppWindow(NativeAppWindow) from NativeAppWindow to NativeAppWindow
{

}

typedef MouseInfo =
{
	stageX:Float,
	stageY:Float,
	shift:Bool,
}