package robotlegs.extensions.impl.logic.config.html;
import haxe.Json;
import mantle.util.app.App;
import js.Browser;
import robotlegs.bender.extensions.config.IConfigModel;
import org.swiftsuspenders.utils.DescribedType;
/**
 * ...
 * @author P.J.Shand
 */

@:keepSub
class AttributeConfigLogic implements DescribedType
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