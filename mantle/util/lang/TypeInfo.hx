package mantle.util.lang;

import haxe.rtti.CType;
import haxe.rtti.CType.Classdef;
import haxe.rtti.CType.ClassField;
import haxe.rtti.Rtti;

using StringTools;

/**
 * ...
 * @author Thomas Byrne
 */
class TypeInfo
{
	private static var _rttiCache:Map<String, Array<Classdef>> = new Map();
	
	
	public static function hasField( o:Dynamic, field:String):Bool
	{
		var fields;
		var clazz:Class<Dynamic>;
		if (Std.is(o, Class)) {
			clazz = o;
			fields = Type.getInstanceFields(clazz);
		}
		else {
			fields = Reflect.fields(o);	
			clazz = Type.getClass(o);
		}
		
		for (i in 0...fields.length) 
		{
			if (fields[i] == field) return true;
		}
		
		if(clazz !=null){
			var typename:String = Type.getClassName(clazz);
			var typeLineage:Array<Classdef> = _rttiCache.get(typename);
			if (typeLineage == null) {
				typeLineage = getTypeLineage(clazz);
				if(typeLineage!=null)_rttiCache.set(typename, typeLineage);
			}
			if (typeLineage != null) {
				if (findField(typeLineage, field) != null) return true;
				#if flash
				if (getFlashFieldType(o, clazz, typename, field) != null) return true;
				#end
			}
		}

		
		#if (js || cpp)
			var f:Dynamic = Reflect.getProperty(o, field);
			var isFunction = Reflect.isFunction(f);
			var isObject = Reflect.isObject(f);
			if (isFunction || isObject) return true;
			else return false;
		#else 
			var hasField = Reflect.hasField(o, field);
			return hasField;
		#end
	}

	public static function getFieldType(obj:Dynamic, field:String) : Null<String> 
	{
		var type:Class<Dynamic> = Type.getClass(obj);
		if (type == null) {
			// dynamic object
			if (!Reflect.hasField(obj, field)) {
				Logger.warn(TypeInfo, "Couldn't find type of field on dynamic object: "+obj);
				return null;
			}
			var value:Dynamic = Reflect.field(obj, field);
			if(value!=null){
				return Type.getClassName(Type.getClass(value));
			}else {
				Logger.warn(TypeInfo, "Couldn't find type of field on dynamic object: "+obj);
				return null;
			}
			
		}else {
			var typename:String = Type.getClassName(type);
			var typeLineage:Array<Classdef> = _rttiCache.get(typename);
			if (typeLineage == null) {
				typeLineage = getTypeLineage(type);
				if(typeLineage!=null)_rttiCache.set(typename, typeLineage);
			}
			if (typeLineage == null) {
				#if flash
					return getFlashFieldType(obj, type, typename, field);
				#else
					Logger.warn(TypeInfo, "RTTI information not found on class: "+typename);
					return null;
				#end
			}
			var classField:ClassField = findField(typeLineage, field);
			if (classField == null) {
				#if flash
					return getFlashFieldType(obj, type, typename, field);
				#else
					Logger.warn(TypeInfo, "Couldn't find field " + field + " on class " + typename);
					return null;
				#end
			}
			return getCTypeName(classField.type);
		}
		
	}
	
	static private function getCTypeName(type:CType) 
	{
			switch(type) {
				case CType.CClass(name, paramsList) | CType.CAbstract(name, paramsList) | CType.CTypedef(name, paramsList):
					if (paramsList.length>0) {
						var paramTypes:Array<String> = [];
						for (param in paramsList) {
							paramTypes.push(getCTypeName(param));
						}
						return name+"<"+paramTypes.join(",")+">";
					}else{
						return name;
					}
					
				default:
					return "Dynamic";
			}
	}
	
	static private function getTypeLineage(type:Class<Dynamic>) : Array<Classdef>
	{
		var ret:Array<Classdef> = [];
		var lastDef:Classdef = Rtti.getRtti(type);
		if (lastDef == null) return null;
		ret.push(lastDef);
		
		var trySuper:Class<Dynamic> = null;
		while (trySuper != null || lastDef.superClass != null) {
			if (trySuper != null) {
				type = trySuper;
				trySuper = null;
			}else {
				type = Type.resolveClass(lastDef.superClass.path);
			}
			try{
				lastDef = Rtti.getRtti(type);
				if (lastDef != null) {
					ret.push(lastDef);
				}
			}catch (e:Dynamic) {
				trySuper = Type.getSuperClass(	type );
				break;
			}
		}
		
		return ret;
	}
	
	static private function findField(typeLineage:Array<Classdef>, field:String) : ClassField
	{
		for(typeInfo in typeLineage){
			for (f in typeInfo.fields) {
				if (f.name == field) return f;
			}
		}
		return null;
	}
	
	#if flash
	static private var describeTypeCache:Map<String, Xml> = new Map();
	static private function getFlashFieldType(obj:Dynamic, type:Class<Dynamic>, typename:String, field:String) : Null<String>
	{
		var typeDesc:Xml = describeTypeCache.get(typename);
		if (typeDesc == null) {
			typeDesc = getFlashTypeLineage(type);
			describeTypeCache.set(typename, typeDesc);
		}
		if (!Std.is(obj, Class)) {
			typeDesc = typeDesc.elementsNamed("factory").next();
		}
		var vars = typeDesc.elementsNamed("variable");
		for (varNode in vars) {
			if (varNode.get("name") == field) {
				return varNode.get("type").replace("::", ".");
			}
		}
		var accessors = typeDesc.elementsNamed("accessor");
		for (accNode in accessors) {
			if (accNode.get("name") == field) {
				return accNode.get("type").replace("::", ".");
			}
		}
		Logger.warn(TypeInfo, "Couldn't find field " + field + " on class " + typename);
		return null;
	}
	
	static private function getFlashTypeLineage(type:Class<Dynamic>) : Xml
	{
		return Xml.parse(flash.Lib.describeType(type).toXMLString()).firstChild();
	}
	#end
	
}