// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package fuse.text.textDisplay.utils;

/** A class that provides constant values for horizontal alignment of objects. */
class VAlign {
	/** Left alignment. */
	public static inline var TOP:String = "top";

	/** Centered alignement. */
	public static inline var CENTER:String = "center";

	/** Right alignment. */
	public static inline var BOTTOM:String = "bottom";

	/** Indicates whether the given alignment string is valid. */
	public static function isValid(vAlign:String):Bool {
		return vAlign == TOP || vAlign == CENTER || vAlign == BOTTOM;
	}
}
