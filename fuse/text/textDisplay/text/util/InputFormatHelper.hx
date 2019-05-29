package fuse.text.textDisplay.text.util;

import fuse.text.textDisplay.text.model.format.InputFormat;

/**
 * ...
 * @author P.J.Shand
 */
class InputFormatHelper {
	public function new() {}

	public static function copyActiveValues(copyTo:InputFormat, copyFrom:InputFormat) {
		if (copyFrom == null)
			return;
		if (copyFrom.size != null)
			copyTo.size = copyFrom.size;
		if (copyFrom.face != null)
			copyTo.face = copyFrom.face;
		if (copyFrom.color != null)
			copyTo.color = copyFrom.color;
		if (copyFrom.kerning != null)
			copyTo.kerning = copyFrom.kerning;
		if (copyFrom.leading != null)
			copyTo.leading = copyFrom.leading;
		if (copyFrom.baseline != null)
			copyTo.baseline = copyFrom.baseline;
		if (copyFrom.textTransform != null)
			copyTo.textTransform = copyFrom.textTransform;
	}

	public static function copyMissingValues(copyTo:InputFormat, copyFrom:InputFormat) {
		if (copyFrom == null)
			return;
		if (copyTo.size == null && copyFrom.size != null)
			copyTo.size = copyFrom.size;
		if (copyTo.face == null && copyFrom.face != null)
			copyTo.face = copyFrom.face;
		if (copyTo.color == null && copyFrom.color != null)
			copyTo.color = copyFrom.color;
		if (copyTo.kerning == null && copyFrom.kerning != null)
			copyTo.kerning = copyFrom.kerning;
		if (copyTo.leading == null && copyFrom.leading != null)
			copyTo.leading = copyFrom.leading;
		if (copyTo.baseline == null && copyFrom.baseline != null)
			copyTo.baseline = copyFrom.baseline;
		if (copyTo.textTransform == null && copyFrom.textTransform != null)
			copyTo.textTransform = copyFrom.textTransform;
	}

	static public function removeDuplicates(format:InputFormat, parent:InputFormat) {
		if (format == null || parent == null)
			return;
		if (format.size == parent.size)
			format.size = null;
		if (format.face == parent.face)
			format.face = null;
		if (format.color == parent.color)
			format.color = null;
		if (format.kerning == parent.kerning)
			format.kerning = null;
		if (format.leading == parent.leading)
			format.leading = null;
		if (format.baseline == parent.baseline)
			format.baseline = null;
		if (format.textTransform == parent.textTransform)
			format.textTransform = null;
	}
}
