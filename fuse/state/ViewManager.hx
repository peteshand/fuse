package fuse.state;
import com.imagination.core.managers.state.StateManager;
import fuse.air.sample.view.fuse.BaseView;
import fuse.air.sample.view.shell.back.BackBtnView;

/**
 * ...
 * @author P.J.Shand
 */
class ViewManager 
{
	public function new() { }
	
	public static function define(parent:Dynamic, view:Class<BaseView>, stateManager:StateManager, params:Array<Dynamic>=null):Void 
	{
		new ViewManagerItem(parent, view, stateManager, params);
	}
}

class ViewManagerItem
{
	private var parent:Dynamic;
	private var ViewClass:Class<BaseView>;
	private var params:Array<Dynamic>;
	
	public function new(parent:Dynamic, ViewClass:Class<BaseView>, stateManager:StateManager, params:Array<Dynamic>=null) 
	{
		this.parent = parent;
		this.ViewClass = ViewClass;
		this.params = params;
		
		stateManager.onActive.add(OnActive);
		stateManager.onInactive.add(OnInactive);
		if (stateManager.isActive) {
			OnActive();
		}
	}
	
	function OnInactive() 
	{
		//trace("OnInactive");
	}
	
	private function OnActive():Void 
	{
		new ViewCleanup(parent, ViewClass, params);
	}
}

class ViewCleanup
{
	var currentView:BaseView;
	
	var parent:Dynamic;
	var ViewClass:Class<BaseView>;
	var params:Array<Dynamic>;
	
	public function new(parent:Dynamic, ViewClass:Class<BaseView>, params:Array<Dynamic>=null) 
	{
		this.parent = parent;
		this.ViewClass = ViewClass;
		this.params = params;
		if (this.params == null) this.params = [];
		
		CreateView();
	}
	
	inline function CreateView() 
	{
		currentView = Type.createInstance(ViewClass, params);
		currentView.transition.onHideComplete.addOnce(OnHideComplete);
		parent.addChild(currentView);
	}
	
	inline function OnHideComplete() 
	{
		if (currentView == null) return;
		if (currentView.parent != null) {
			currentView.parent.removeChild(currentView);
		}
		currentView.dispose();
		currentView = null;
	}
}