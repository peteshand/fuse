package robotlegs.extensions.impl.utils.parsers;
import haxe.Json;
import mantle.util.lang.TypeInfo;

using Logger;

/**
 * ...
 * @author Thomas Byrne
 */
class ObjectFiller
{
	private var _typeInterpreters:Map<String, String->Dynamic>;

	public function new() 
	{
		_typeInterpreters = new Map();
	}
	
	public function populateXML(typedObject:Dynamic, xml:Xml):Void 
	{
		var staticRef:Class<Dynamic> = Type.getClass(typedObject);
		
		var classFields = Type.getClassFields(staticRef);
		
		for ( data in xml.elementsNamed("data") ) {
			for ( element in data.elements() ) {
				
				var textNode = element.firstChild();
				
				var value:String = textNode == null ? null : textNode.toString();
				
				if (TypeInfo.hasField(typedObject, element.nodeName)) {
					setProperty(typedObject, element.nodeName, value);
				}
				
				for (i in 0...classFields.length) 
				{
					if (classFields[i] == element.nodeName) {
						setProperty(staticRef, element.nodeName, value);
					}
				}
			}
		}
	}
	
	public function populateDynamic(typedObject:Dynamic, data:Dynamic):Void 
	{
		var staticRef:Class<Dynamic> = Type.getClass(typedObject);
		
		var dataFields = Reflect.fields(data);
		var classFields = Type.getClassFields(staticRef);
		
		for ( field in dataFields) {
			
			var rawValue:Dynamic = Reflect.field(data, field);
			var value:String = Json.stringify(rawValue);
			
			if (TypeInfo.hasField(typedObject, field)) {
				setProperty(typedObject, field, value);
			}
			
			for (i in 0...classFields.length) 
			{
				if (classFields[i] == field) {
					setProperty(staticRef, field, value);
				}
			}
		}
	}
	
	
	public function addTypeInterpreter(type:String, f:String -> Dynamic):Void 
	{
		_typeInterpreters.set(type, f);
	}
	
	function setProperty(object:Dynamic, prop:String, value:String) 
	{
		var type:String = TypeInfo.getFieldType(object, prop);
		var f:String->Dynamic = _typeInterpreters.get(type);
		if (f != null) {
			Reflect.setProperty(object, prop, f(value));
			return;
		}
		while (type.indexOf("Null<") == 0 && type.charAt(type.length - 1) == ">") {
			type = type.substring(5, type.length - 1);
		}
		switch(type) {
			case "String":
				Reflect.setProperty(object, prop, value);
				
			case "Int":
				Reflect.setProperty(object, prop, Std.parseInt(value));
				
			case "Float":
				Reflect.setProperty(object, prop, Std.parseFloat(value));
				
			case "Bool":
				Reflect.setProperty(object, prop, value=="true");
				
			case "Array<String>":
				Reflect.setProperty(object, prop, value.split(","));
				
			case "Array<Int>":
				Reflect.setProperty(object, prop, value.split(",").map(Std.parseInt));
				
			case "Array<Float>":
				Reflect.setProperty(object, prop, value.split(",").map(Std.parseFloat));
				
			case "Array<Bool>":
				Reflect.setProperty(object, prop, value.split(",").map(function(value:String) return value == "true"));
				
			default:
				warn("Couldn't interpret variable into property of type: " + type);
		}
	}
}