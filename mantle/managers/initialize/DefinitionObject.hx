package mantle.managers.initialize;

import mantle.managers.state.IState;
import mantle.managers.state.State;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */

class DefinitionObject
{
	var parent:Dynamic;
	var ViewClass:Class<Dynamic>;
	var state:IState;
	var params:Array<Dynamic>;
	var onActive:Signal0;
	
	public function new(parent:Dynamic, ViewClass:Class<Dynamic>, state:IState, params:Array<Dynamic>=null) 
	{
		this.parent = parent;
		this.ViewClass = ViewClass;
		this.state = state;
		this.params = params;
		if (this.params == null) {
			this.params = [];
		}
		
		onActive = Reflect.getProperty(state, "onActive");
		onActive.addOnce(initialize);
		var result:Bool = state.check();
		if (result) {
			onActive.remove(initialize);
			initialize();
		}
	}
	
	public function initialize():Void
	{
		onActive.remove(initialize);
		var sceneView:Dynamic = Type.createInstance(ViewClass, params);
		Reflect.callMethod(parent, parent.addChild, [sceneView]);
	}
	
}