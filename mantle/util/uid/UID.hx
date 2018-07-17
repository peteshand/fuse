//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package mantle.util.uid;

/**
 * Utility for generating unique object IDs
 */

@:keepSub
class UID
{

	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/
	#if swc @:protected #end
	private static var _i:UInt;

	/*============================================================================*/
	/* Public Static Functions                                                    */
	/*============================================================================*/

	/**
	 * Generates a UID for a given source object or class
	 * @param source The source object or class
	 * @return Generated UID
	 */
	public static function create(source:Dynamic = null):String
	{
		var className = UID.classID(source);
		var random:Int = Math.floor(Math.random() * 255);
		var returnVal:String = "";// (source ? source + '-':'');
		if (source != null) returnVal = className;
		returnVal += '-';
		returnVal += random;
		
		return returnVal;
	}
	
	public static function classID(source:Dynamic):String
	{
		var className = "";
		if (Std.is(source, Class)) {
			className = Type.getClassName(source); 
		}
		else if (Type.getClass(source) != null) {
			className = Type.getClassName(Type.getClass(source)); 
		}
		return className;
	}
	
	// Be careful here (you are storing references to objects)
	//private static var refs = new Array<Dynamic>();
	private static var classRefs = new Map<String,Array<Dynamic>>();
	
	public static function instanceID(source:Dynamic):String
	{
		var classID = classID(source);
		if (Std.is(source, Class)) {
			// Instance can not be of type Class
			return classID;
		}
		if (!classRefs.exists(classID)) {
			classRefs.set(classID, []);
		}
		var id:Int = -1;
		
		var i = 0;
		for (key in classRefs.keys())
		{
			if (classRefs.get(key) == source) {
				id = i;
				break;
			}
			i++;
		}
		
		if (id == -1) {
			id = classRefs.get(classID).length;
			classRefs.get(classID).push(source);
		}
		return UID.classID(source) + "-" + id;
	}
	
	public static function clearInstanceID(source:Dynamic):String
	{
		// Warning, the next time instanceID is called, a new ID will be assigned!
		var classID = classID(source);
		if (Std.is(source, Class)) {
			// Instance can not be of type Class
			return classID;
		}
		if (!classRefs.exists(classID)) {
			classRefs.set(classID, []);
		}
		
		var i = 0;
		for (key in classRefs.keys())
		{
			if (classRefs.get(key) == source) {
				classRefs.get(key)[i] = null;
				return UID.classID(source) + "-" + i;
			}
			i++;
		}
		
		trace("instanceID: " + source + " is not in use");
		return "";
	}
}