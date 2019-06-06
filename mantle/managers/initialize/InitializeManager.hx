package mantle.managers.initialize;

import condition.Condition;

/**
 * ...
 * @author P.J.Shand
 */
class InitializeManager {
	public function new() {}

	public static function define(parent:Dynamic, view:Class<Dynamic>, condition:Condition, params:Array<Dynamic> = null):DefinitionObject {
		return new DefinitionObject(parent, view, condition, params);
	}
}
