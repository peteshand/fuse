package robotlegs.extensions.impl.logic.flags.html;

import haxe.Json;
import mantle.util.app.App;
import js.Browser;
import robotlegs.extensions.impl.model.flags.FlagsModel;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class HtmlFlagsLogic implements DescribedType {
	@inject public var flagsModel:FlagsModel;

	public function new() {}

	public function init():Void {
		var propsAttr = App.appElement.attributes.getNamedItem("flags");
		if (propsAttr != null) {
			var props = propsAttr.value;
			if (props.length > 0) {
				var flagData = Json.parse(props);
				for (field in Reflect.fields(flagData)) {
					var value = Reflect.field(flagData, field);
					flagsModel.add(field, value);
					trace("Injected flag: " + field + " = " + value);
				}
			}
		}
	}
}
