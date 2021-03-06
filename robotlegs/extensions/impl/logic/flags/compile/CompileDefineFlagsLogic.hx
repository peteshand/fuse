package robotlegs.extensions.impl.logic.flags.compile;

import robotlegs.extensions.impl.model.flags.FlagsModel;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author Thomas Byrne
 */
@:build(robotlegs.extensions.impl.logic.flags.CompileDefineMacro.build())
class CompileDefineFlagsLogic implements DescribedType {
	@inject public var flagsModel:FlagsModel;

	// Build macro will populate
	private var defineKeys = new Array<String>();

	public function new() {}

	public function init():Void {
		for (i in 0...defineKeys.length) {
			var split:Array<String> = defineKeys[i].split(",");
			var key:String = split[0];
			var value:String = split[1];
			flagsModel.add(key, value);
		}
	}
}
