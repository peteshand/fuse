package mantle.managers.initialize;

import condition.IState;
import condition.State;

/**
 * ...
 * @author P.J.Shand
 */
class InitializeManager {
	public function new() {}

	public static function define(parent:Dynamic, view:Class<Dynamic>, state:IState, params:Array<Dynamic> = null):DefinitionObject {
		return new DefinitionObject(parent, view, state, params);
	}
}
