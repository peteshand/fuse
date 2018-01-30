package fuse.robotlegs.config.logic.html;

import fuse.utilsSort.app.App;
import haxe.Json;
import fuse.robotlegs.config.IConfigModel;

/**
 * ...
 * @author P.J.Shand
 */

@:rtti
@:keepSub
class AttributeConfigLogic
{
	@inject public var configModel:IConfigModel;
	
	public function new() 
	{
		
	}
	
	public function init() 
	{
		var propsAttr = App.appElement.attributes.getNamedItem("config");
		if (propsAttr != null) {
			var propsStr = propsAttr.value;
			trace("props = " + propsStr);
			var propsData = Json.parse(propsStr);
			for (field in Reflect.fields(propsData)){
				var value = Reflect.field(propsData, field);
				Reflect.setProperty(configModel, field, value);
				trace("Embedded prop: " + field + " = " + value);
			}
		}
	}
	
}