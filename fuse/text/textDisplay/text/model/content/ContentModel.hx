package fuse.text.textDisplay.text.model.content;

import fuse.text.textDisplay.text.model.format.InputFormat;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.util.FormatParser;
import fuse.text.textDisplay.text.util.FormatParser.FormatNode;
import fuse.text.textDisplay.text.util.InputFormatHelper;
import fuse.text.textDisplay.utils.On;

/**
 * ...
 * @author P.J.Shand
 */
class ContentModel {
	static var charPool:Array<Char> = [];

	var textDisplay:TextDisplay;

	public var charactersChanged:On = new On();
	public var characters = new Array<Char>();
	public var _nodes = new Array<FormatNode>();
	public var nodes(get, set):Array<FormatNode>;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
	}

	public function update():Void {
		clearChars();

		var str:String = textDisplay.value;

		if (str != "") {
			for (i in 0...str.length) {
				characters[i] = newChar(str.charAt(i), i);
			}
		}
		charactersChanged.fire();
	}

	function clearChars() {
		if (characters.length == 0)
			return;

		var length = charPool.length;
		for (char in characters) {
			char.clear();
			charPool[length] = char;
			length++;
		}
		characters = [];
	}

	function newChar(char:String, i:Int):Char {
		if (charPool.length > 0) {
			var ret = charPool.pop();
			ret.init(char, i);
			return ret;
		} else {
			return new Char(char, i);
		}
	}

	public function remove(editStart:Int, editEnd:Int) {
		removeFromNodes(nodes, editStart, editEnd);
	}

	private function removeFromNodes(nodes:Array<FormatNode>, editStart:Int, editEnd:Int) {
		var index:Int = editStart;
		var len:Int = editEnd - editStart;

		var i:Int = nodes.length - 1;
		while (i >= 0) {
			var node = nodes[i];
			var editLen:Int;
			var rangeOverlap:RangeOverlap = getOverlap(editStart, editEnd, node.startIndex, node.endIndex + 1);
			if (rangeOverlap == RangeOverlap.SURROUND) {
				nodes.splice(i, 1);
			} else {
				if (rangeOverlap == RangeOverlap.INSIDE || rangeOverlap == RangeOverlap.MATCH) {
					node.value = removeChars(node.value, editStart - node.startIndex, len); // remove chars
					// do not remove from start
					node.endIndex -= len; // remove from end
				} else if (rangeOverlap == RangeOverlap.TOP_INSIDE) {
					editLen = editEnd - node.startIndex;
					node.value = removeChars(node.value, editEnd - editLen - node.startIndex, editLen); // remove chars
					node.startIndex -= len - editLen; // remove from start
					node.endIndex -= len; // remove from end
				} else if (rangeOverlap == RangeOverlap.BOTTOM_INSIDE) {
					editLen = (node.endIndex + 1) - editStart;
					// do not remove from start
					node.value = removeChars(node.value, editStart - node.startIndex, editLen); // remove chars
					node.endIndex -= editLen; // remove from end
				} else if (rangeOverlap == RangeOverlap.OUTSIDE_BOTTOM) {
					node.startIndex -= len; // remove from start
					node.endIndex -= len; // remove from end
					// do not remove chars
				} else if (rangeOverlap == RangeOverlap.OUTSIDE_TOP) {
					// do not remove from start
					// do not remove from end
					// do not remove chars
				}

				if (node.children.length > 0) {
					removeFromNodes(node.children, editStart, editEnd);
				}
			}
			i--;
		}
	}

	function removeChars(value:String, start:Int, len:Int):String {
		if (value == null)
			return null;

		#if js
		if (Std.is(value, Xml))
			value = cast(value, Xml).nodeValue;
		#end

		var split:Array<String> = value.split("");
		split.splice(start, len);
		return split.join("");
	}

	private function getOverlap(editStart:Int, editEnd:Int, formatStart:Int, formatEnd:Int):RangeOverlap {
		if (editStart == formatStart && editEnd == formatEnd) {
			return RangeOverlap.MATCH;
		} else if (editStart >= formatStart && editEnd <= formatEnd) {
			return RangeOverlap.INSIDE;
		} else if (editStart >= formatStart && editStart < formatEnd) {
			return RangeOverlap.BOTTOM_INSIDE;
		} else if (editEnd > formatStart && editEnd <= formatEnd) {
			return RangeOverlap.TOP_INSIDE;
		} else if (editStart <= formatStart && editEnd >= formatEnd) {
			return RangeOverlap.SURROUND;
		} else if (editStart < formatStart) {
			return RangeOverlap.OUTSIDE_BOTTOM;
		} else if (editEnd > formatEnd) {
			return RangeOverlap.OUTSIDE_TOP;
		}
		return null;
	}

	public function insert(letter:String, index:Int) {
		insertIntoNodes(_nodes, letter, index);
	}

	private function insertIntoNodes(nodes:Array<FormatNode>, letter:String, index:Int) {
		// Fail safe, apply default format if there is only one node and nothing in it
		if (nodes.length == 1) {
			if (nodes[0].value != null) {
				if (nodes[0].value.length == 0) {
					InputFormatHelper.copyMissingValues(nodes[0].format, textDisplay.defaultFormat);
				}
			}
		}

		for (i in 0...nodes.length) {
			var node:FormatNode = nodes[i];
			if (index <= node.startIndex && node.startIndex != 0) {
				node.startIndex += letter.length;
				node.endIndex += letter.length;
			} else if (index <= node.endIndex + 1) {
				if (node.children.length == 0) {
					if (node.value == null || node.value == "") {
						node.value = letter;
					} else if (index == 0) {
						node.value = letter + node.value;
					} else {
						var split:Array<String> = node.value.split("");
						var newValue:String = "";
						for (j in 0...split.length) {
							var valueIndex:Int = node.startIndex + j;
							newValue += split[j];
							if (valueIndex + 1 == index)
								newValue += letter;
						}
						node.value = newValue;
					}
					node.endIndex = node.startIndex + node.value.length - 1;
				}
			}

			if (node.children.length > 0) {
				insertIntoNodes(node.children, letter, index);
				var length = node.children[node.children.length - 1].endIndex - node.children[0].startIndex;
				node.endIndex = node.startIndex + length - 1;
			}
		}
	}

	public function setFormat(format:InputFormat, begin:Null<Int> = null, end:Null<Int> = null):Void {
		if (_nodes.length == 0 && begin == null && end == null) {
			var plainText:String = FormatParser.nodesToPlainText(nodes);
			FormatParser.recycleNodes(_nodes);
			_nodes = FormatParser.textAndFormatToNodes(plainText, format);
		} else {
			applyFormatToNodes(_nodes, format, begin, end);
		}
	}

	function hasIdenticalFormat(node1:FormatNode, node2:FormatNode) {
		if (node1.format.color != node2.format.color)
			return false;
		if (node1.format.face != node2.format.face)
			return false;
		if (node1.format.kerning != node2.format.kerning)
			return false;
		if (node1.format.leading != node2.format.leading)
			return false;
		if (node1.format.size != node2.format.size)
			return false;

		return true;
	}

	function applyFormatToNodes(nodes:Array<FormatNode>, format:InputFormat, begin:Null<Int>, end:Null<Int>) {
		for (i in 0...nodes.length) {
			var node:FormatNode = nodes[i];
			var testBegin:Int = begin;
			var testEnd:Int = end;
			if (begin == null && nodes.length > 0)
				testBegin = nodes[0].startIndex;
			if (end == null && nodes.length > 0)
				testEnd = nodes[0].endIndex;

			if (testBegin < node.startIndex)
				testBegin = node.startIndex;
			if (testEnd > node.endIndex)
				testEnd = node.endIndex;

			if (testEnd < testBegin)
				continue;

			if (node.children.length > 0) {
				applyFormatToNodes(node.children, format, testBegin, testEnd);
			} else {
				// if (node.children.length > 0) continue;

				var rangeOverlap:RangeOverlap = getOverlap(testBegin, testEnd + 1, node.startIndex, node.endIndex + 1);

				if (rangeOverlap == RangeOverlap.MATCH || rangeOverlap == RangeOverlap.SURROUND) {
					InputFormatHelper.copyActiveValues(node.format, format);
					if (node.parent != null)
						InputFormatHelper.removeDuplicates(node.format, node.parent.format);
				} else if (node.value != null) {
					if (rangeOverlap == RangeOverlap.INSIDE
						|| rangeOverlap == RangeOverlap.BOTTOM_INSIDE
						|| rangeOverlap == RangeOverlap.TOP_INSIDE) {
						var beginNode:FormatNode = null;
						var middleNode:FormatNode = null;
						var endNode:FormatNode = null;

						if (testBegin > node.startIndex) {
							beginNode = createChildNode(node);
							beginNode.startIndex = node.startIndex;
							beginNode.endIndex = testBegin - 1;
							beginNode.value = node.value.substring(0, testBegin - node.startIndex);
						}

						if (testEnd < node.endIndex) {
							endNode = createChildNode(node);
							endNode.startIndex = testEnd + 1;
							endNode.endIndex = node.endIndex;
							endNode.value = node.value.substr((testEnd + 1) - node.startIndex, node.value.length);
						}

						if (beginNode != null || endNode != null) {
							middleNode = createChildNode(node);
							middleNode.startIndex = testBegin;
							middleNode.endIndex = testEnd;

							middleNode.value = node.value.substring(testBegin - node.startIndex, (testEnd + 1) - node.startIndex);

							InputFormatHelper.copyActiveValues(middleNode.format, format);
							if (node.parent != null)
								InputFormatHelper.removeDuplicates(middleNode.format, node.format);

							if (beginNode != null)
								node.children.push(beginNode);
							if (middleNode != null)
								node.children.push(middleNode);
							if (endNode != null)
								node.children.push(endNode);

							node.value = null;
						} else {
							// THIS IS MOST LIKELY AN ERROR IN PARSING
							trace("PARSING ERROR");
						}
					}
				}
			}
		}
	}

	function createChildNode(node:FormatNode) {
		var formatNode:FormatNode = new FormatNode();
		formatNode.parent = node;
		// formatNode.name = node.name;
		formatNode.format = new InputFormat();
		return formatNode;
	}

	function get_nodes():Array<FormatNode> {
		return _nodes;
	}

	function set_nodes(value:Array<FormatNode>):Array<FormatNode> {
		_nodes = value;
		return _nodes;
	}

	#if debug
	public function logNodes() {
		trace(_logNodes(_nodes, '\n'));
	}

	@:access(fuse.text.textDisplay.text.util.FormatParser)
	function _logNodes(nodes:Array<FormatNode>, tabs:String):String {
		var ret = '\n';
		for (i in 0...nodes.length) {
			var node = nodes[i];
			var value = node.value;
			ret += tabs + '[' + (i + 1) + "/" + nodes.length + '] - start:' + node.startIndex + ' - end:' + node.endIndex + ' - length:'
				+ (value == null ? null : value.length);
			ret += tabs + FormatParser.createStartTag(node);
			if (value != null && value.length > 0) {
				value = StringTools.replace(value, '\n', '\\n');
				value = StringTools.replace(value, '\r', '\\r');
				value = StringTools.replace(value, '\t', '\\t');
				ret += tabs + '"' + value + '"';
			}
			if (node.children.length > 0)
				ret += _logNodes(node.children, tabs + '\t');
		}
		return ret;
	}
	#end
}

@:enum abstract RangeOverlap(String) from String to String {
	public var MATCH = "match";
	public var INSIDE = "inside";
	public var BOTTOM_INSIDE = "bottom_inside";
	public var TOP_INSIDE = "top_inside";
	public var OUTSIDE_BOTTOM = "outside_bottom";
	public var OUTSIDE_TOP = "outside_top";
	public var SURROUND = "surround";
}
