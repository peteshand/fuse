package robotlegs.extensions.impl.logic.config.html;

import openfl.net.SharedObject;
import robotlegs.bender.extensions.config.IConfigModel;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class HtmlDynamicConfigLogic implements DescribedType {
	@inject public var configModel:IConfigModel;

	private var localSharedObject:SharedObject;

	public function new() {}

	public function init() {
		localSharedObject = SharedObject.getLocal("localHtmlDynamicConfigLogic");

		loadDynamicData(configModel.localDynamicData, localSharedObject);

		configModel.onLocalDynamicSet.add(OnLocalDynamicSet);
	}

	function loadDynamicData(dynamicData:Map<String, Dynamic>, sharedObject:SharedObject) {
		var fields:Array<String> = Reflect.fields(sharedObject.data);
		for (i in 0...fields.length) {
			var field:String = fields[i];
			dynamicData.set(field, Reflect.getProperty(sharedObject.data, field));
		}
	}

	function OnLocalDynamicSet() {
		for (key in configModel.localDynamicData.keys()) {
			localSharedObject.setProperty(key, configModel.localDynamicData.get(key));
		}
		localSharedObject.flush();
	}
}
