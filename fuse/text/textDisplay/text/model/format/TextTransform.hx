package fuse.text.textDisplay.text.model.format;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract TextTransform(String) from String to String {
	/** No capitalization. The text renders as it is. This is default. */
	var NONE = "none";

	/** Transforms all characters to uppercase. */
	var UPPERCASE = "uppercase";

	/** Transforms all characters to lowercase. */
	var LOWERCASE = "lowercase";

	/** Transforms the first character of each word to uppercase. */
	// NOT YET SUPPORTED
	// var CAPITALIZE = "capitalize";
	/** Transforms all characters to their initial transform state. */
	// NOT YET SUPPORTED
	// var INITIAL = "initial";
	/** Inherits this property from its parent element. */
	// NOT YET SUPPORTED
	// var INHERIT = "inherit";
}
