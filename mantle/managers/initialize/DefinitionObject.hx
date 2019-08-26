package mantle.managers.initialize;

import condition.Condition;

/**
 * ...
 * @author P.J.Shand
 */
class DefinitionObject {
	var parent:Dynamic;
	var ViewClass:Class<Dynamic>;
	var condition:Condition;
	var params:Array<Dynamic>;

	public function new(parent:Dynamic, ViewClass:Class<Dynamic>, condition:Condition, params:Array<Dynamic> = null) {
		this.parent = parent;
		this.ViewClass = ViewClass;
		this.condition = condition;
		this.params = params;
		if (this.params == null) {
			this.params = [];
		}

		condition.onActive.add(initialize);
	}

	public function initialize():Void {
		condition.onActive.remove(initialize);
		var sceneView:Dynamic = Type.createInstance(ViewClass, params);
		Reflect.callMethod(parent, parent.addChild, [sceneView]);
	}
}
