package fuse.text.textDisplay.text.util;

import haxe.ds.StringMap;
import fuse.text.textDisplay.text.model.format.InputFormat;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.util.FormatParser.FormatNode;
import fuse.text.textDisplay.utils.SpecialChar;

/**
 * ...
 * @author P.J.Shand
 */
class FormatParser {
	static var NodePool:Array<FormatNode> = [];
	// static var AttPool:Array<FormatAttribute> = [];
	static var incompatibleCheck = new InputFormat();

	public static function recycleNodes(nodes:Array<FormatNode>):Void {
		for (node in nodes) {
			NodePool.push(node);
			recycleNodes(node.children);
			node.clear();
		}
	}

	public static function textAndFormatToNodes(v:String, format:InputFormat):Array<FormatNode> {
		var formatNode = newFormatNode();
		formatNode.value = v;
		formatNode.format = format;
		formatNode.startIndex = 0;
		formatNode.endIndex = v.length;
		return [formatNode];
	}

	static private function newFormatNode() {
		if (NodePool.length > 0) {
			return NodePool.pop();
		} else {
			return new FormatNode();
		}
	}

	public static function htmlToNodes(v:String):Array<FormatNode> {
		var xml:Xml = clearString(v);
		// var nodes:Array<FormatNode> = convert(xml, null);
		var nodes:Array<FormatNode> = [xmlToNodes(xml, null)];

		var plainText:String = plainText(nodes);
		findStartEnd(0, nodes, plainText);
		removeEmptyNodes(nodes);
		mergeNodes(nodes);
		return nodes;
	}

	public static function mergeNodes(nodes:Array<FormatNode>) {
		var i:Int = nodes.length - 1;
		while (i >= 0) {
			var node:FormatNode = nodes[i];
			if (node.children.length > 1) {
				var j:Int = node.children.length - 1;
				while (j >= 1) {
					var previousChildNode:FormatNode = node.children[j - 1];
					var childNode:FormatNode = node.children[j];
					if (previousChildNode.value != null && childNode.value != null) {
						if (isEqual(previousChildNode.format, childNode.format)) {
							previousChildNode.value += childNode.value;
							previousChildNode.endIndex = childNode.endIndex;
							node.children.splice(j, 1);

							childNode.clear();
							NodePool.push(childNode);
						}
					}
					j--;
				}

				if (node.children.length == 1) {
					var child = node.children[0];
					InputFormatHelper.copyActiveValues(node.format, child.format);

					// TODO: shouldn't have to do this, should already be same
					node.startIndex = child.startIndex;
					node.endIndex = child.endIndex;
					node.value = child.value;

					node.children = child.children;
					child.parent = null;
				}
			}

			if (node.children.length > 0) {
				mergeNodes(node.children);
			}
			i--;
		}
	}

	static private function isEqual(format1:InputFormat, format2:InputFormat) {
		if (format1.color != format2.color)
			return false;
		if (format1.face != format2.face)
			return false;
		if (format1.size != format2.size)
			return false;
		if (format1.leading != format2.leading)
			return false;
		if (format1.kerning != format2.kerning)
			return false;
		if (format1.baseline != format2.baseline)
			return false;
		if (format1.textTransform != format2.textTransform)
			return false;
		if (format1.href != format2.href)
			return false;
		return true;
	}

	public static function removeEmptyNodes(nodes:Array<FormatNode>) {
		var i:Int = nodes.length - 1;
		while (i >= 0) {
			var node:FormatNode = nodes[i];
			if (node.children.length == 1 && node.parent != null) {
				if (node.children[0].format.isClear() && node.children[0].children.length == 0) {
					node.value = node.children[0].value;
					node.children.splice(0, 1);
				}
			}

			if (node.children.length > 0) {
				removeEmptyNodes(node.children);
			} else if ((node.value == null || node.value == "") && node.parent != null) {
				nodes.splice(i, 1);
			}
			i--;
		}
	}

	/*static private function isEmptyFormat(inputFormat:InputFormat):Bool
		{
			if (inputFormat.color != null) return false;
			if (inputFormat.face != null) return false;
			if (inputFormat.kerning != null) return false;
			if (inputFormat.baseline != null) return false;
			if (inputFormat.leading != null) return false;
			if (inputFormat.textTransform != null) return false;
			if (inputFormat.size != null) return false;
			if (inputFormat.href != null) return false;
			return true;
	}*/
	/*public static function nodesToFormats(nodes:Array<FormatNode>):Array<FormatLength>
		{
			var formatLengths:Array<FormatLength> = new Array<FormatLength>();
			createFormats(nodes, formatLengths);
			//applyFormats(nodes);

			return formatLengths;
	}*/
	static private function clearString(v:String):Xml {
		if (v == null)
			return null;
		var value:String = v;
		value = new EReg("<br>", "g").replace(value, SpecialChar.NewLine);
		value = new EReg("<br/>", "g").replace(value, SpecialChar.NewLine);
		return Xml.parse("<xml>" + value + "</xml>").firstChild();
	}

	/*private static function createFormats(formatNodes:Array<FormatNode>, formatLengths:Array<FormatLength>) 
		{
			if (formatNodes == null) return;


			for (i in 0...formatNodes.length)
			{
				if (formatNodes[i].attributes.length > 0) {
					var formatLength:FormatLength = new FormatLength();
					formatLength.startIndex = formatNodes[i].startIndex;
					formatLength.endIndex = formatNodes[i].endIndex;
					formatLength.format = new InputFormat();
					for (j in 0...formatNodes[i].attributes.length)
					{
						var propName:String = formatNodes[i].attributes[j].key;
						var propValue:String = formatNodes[i].attributes[j].value;

						if (propName.toLowerCase() == "color") 			untyped formatLength.format[propName] = Std.parseInt("0x" + propValue.split("#").join(""));
						else if (propName.toLowerCase() == "face")		untyped formatLength.format[propName] = propValue;
						else if (propName.toLowerCase() == "size")		untyped formatLength.format[propName] = Std.parseInt(propValue);
						else if (propName.toLowerCase() == "kerning")	untyped formatLength.format[propName] = Std.parseInt(propValue);
						else if (propName.toLowerCase() == "leading")	untyped formatLength.format[propName] = Std.parseInt(propValue);

					}
					formatLengths.push(formatLength);
				}
				if (formatNodes[i].children.length > 0) {
					createFormats(formatNodes[i].children, formatLengths);
				}
			}
	}*/
	/*private static function createFormats(formatNodes:Array<FormatNode>) 
		{
			for (i in 0...formatNodes.length)
			{
				var formatNode:FormatNode = formatNodes[i];

			}
	}*/
	static private function findStartEnd(searchStartIndex:Int, nodes:Array<FormatNode>, plainText:String) {
		var value:String;

		for (i in 0...nodes.length) {
			if (nodes[i].children.length > 0) {
				findStartEnd(searchStartIndex, nodes[i].children, plainText);
			}

			if (Std.is(nodes[i].value, Xml))
				value = cast(nodes[i].value, Xml).nodeValue;
			else
				value = nodes[i].value;

			if (nodes[i].children.length > 0 && value == null) {
				nodes[i].startIndex = nodes[i].children[0].startIndex;
				nodes[i].endIndex = nodes[i].children[nodes[i].children.length - 1].endIndex;
			} else if (value != null) {
				var searchText:String = plainText.substring(searchStartIndex, plainText.length);
				nodes[i].startIndex = searchStartIndex + searchText.indexOf(value);
				nodes[i].endIndex = nodes[i].startIndex + value.length - 1;
			}

			searchStartIndex = nodes[i].endIndex + 1;
		}
	}

	static private function childStart(nodes:Array<FormatNode>, plainText:String):Null<Int> {
		if (nodes.length == 0)
			return null;
		var first:FormatNode = nodes[0];
		if (first.children.length > 0) {
			return childStart(first.children, plainText);
		} else {
			var returnIndex:Null<Int> = plainText.indexOf(first.value);
			return returnIndex;
		}
	}

	static private function childEnd(nodes:Array<FormatNode>, plainText:String):Null<Int> {
		if (nodes.length == 0)
			return null;
		var last:FormatNode = nodes[nodes.length - 1];
		if (last.children.length > 0) {
			return childEnd(last.children, plainText);
		}
		var index:Int = plainText.indexOf(last.value);
		var value:String;
		if (Std.is(last.value, Xml))
			value = cast(last.value, Xml).nodeValue;
		else
			value = last.value;
		return index + value.length - 1;
	}

	static function xmlToNodes(xml:Xml, parent:FormatNode):FormatNode {
		var node:FormatNode = newFormatNode();
		node.parent = parent;

		if (xml.nodeType == Xml.Element) {
			// node.attributes = getAttributes(xml);
			// node.format = createFormat(xml);
			fillFormat(node.format, xml);

			for (child in xml.iterator()) {
				var childNode:FormatNode = xmlToNodes(child, node);
				if (childNode != null) {
					node.children.push(childNode);
				}
			}
		} else if (xml.nodeType == Xml.PCData) {
			node.value = xml.nodeValue;
		}

		if (node.value == null && node.format.isClear() && node.children.length == 1) {
			node.children[0].parent = node.parent;
			return node.children[0];
		}

		return node;
	}

	static private function fillFormat(format:InputFormat, xml:Xml):Void {
		for (key in xml.attributes()) {
			var value = xml.get(key);
			key = key.toLowerCase();

			switch (key) {
				case "color":
					format.color = Std.parseInt("0x" + value.split("#").join(""));
				case "face":
					format.face = value;
				case "size":
					format.size = Std.parseFloat(value);
				case "kerning":
					format.kerning = Std.parseFloat(value);
				case "baseline":
					format.baseline = Std.parseFloat(value);
				case "leading":
					format.leading = Std.parseFloat(value);
				case "href":
					format.href = value;
			}
		}
	}

	// static function convert(xml:Xml, parent:FormatNode):Array<FormatNode>
	// {
	////trace("convert:" + xml);
	// var nodes:Array<FormatNode> = [];
	// for (child in xml.iterator())
	// {
	// var node:FormatNode = newFormatNode();
	// node.parent = parent;
	//
	// if (child.nodeType == Xml.Element) {
	//
	// node.attributes = getAttributes(child);
	//
	//
	// var numChildren:Int = 0;
	// var children = new Array<Xml>();
	// var pcDataChildren = new Array<Xml>();
	// var elementChildren = new Array<Xml>();
	// for (child2 in child.iterator())
	// {
	// children.push(child2);
	// if (child2.nodeType == Xml.Element) {
	// elementChildren.push(child2);
	// }
	// else if (child2.nodeType == Xml.PCData) {
	// pcDataChildren.push(child2);
	// }
	// }
	//
	// if (pcDataChildren.length > 0) {
	//
	// for (j in 0...children.length)
	// {
	// if (children[j].nodeType == Xml.Element) {
	// var nodeChildren = convert(children[j], node);
	// var formatAttribute = getAttributes(children[j]);
	// var inputFormat = createFormat(formatAttribute);
	// for (k in 0...nodeChildren.length)
	// {
	// nodeChildren[k].attributes = formatAttribute;
	// nodeChildren[k].format = inputFormat;
	// node.children.push(nodeChildren[k]);
	// }
	// }
	// else {
	// var childNode = newFormatNode();
	// childNode.value = cast(children[j].nodeValue, String);
	// childNode.parent = node;
	// childNode.format = new InputFormat();
	// node.children.push(childNode);
	// }
	// }
	// }
	// else {
	// node.children = convert(child, node);
	// }
	// }
	// else if (child.nodeType == Xml.PCData) {
	// node.value = cast(child.nodeValue, String);
	// }
	//
	// node.format = createFormat(node.attributes);
	//
	// nodes.push(node);
	// }
	//
	// return nodes;
	// }

	/*static private function createFormat(formatAttribute:Array<FormatAttribute>):InputFormat
		{

			var inputFormat = new InputFormat();
			var len:Int = formatAttribute.length;
			for (i in 0...len)
			{
				var propName:String = formatAttribute[i].key;
				var propValue:String = formatAttribute[i].value;

				if (propName.toLowerCase() == "color") 			Reflect.setField(inputFormat, propName, Std.parseInt("0x" + propValue.split("#").join("")));
				else if (propName.toLowerCase() == "face")		Reflect.setField(inputFormat, propName, propValue);
				else if (propName.toLowerCase() == "size")		Reflect.setField(inputFormat, propName, Std.parseFloat(propValue));
				else if (propName.toLowerCase() == "kerning")	Reflect.setField(inputFormat, propName, Std.parseFloat(propValue));
				else if (propName.toLowerCase() == "baseline")	Reflect.setField(inputFormat, propName, Std.parseFloat(propValue));
				else if (propName.toLowerCase() == "leading")	Reflect.setField(inputFormat, propName, Std.parseFloat(propValue));
				else if (propName.toLowerCase() == "href")		Reflect.setField(inputFormat, propName, propValue);

			}
			return inputFormat;
	}*/
	/*static private function getAttributes(child:Xml):Array<FormatAttribute>
		{
			var formatAttribute = new Array<FormatAttribute>();
			for (key in child.attributes())
			{
				formatAttribute.push(new FormatAttribute(key, child.get(key)));
			}
			return formatAttribute;
	}*/
	public static function nodesToHtml(value:Array<FormatNode>):String {
		if (value == null)
			return "";
		var output:String = "";
		for (i in 0...value.length) {
			var startTag:String = createInputFormatStartTag(value[i].format);
			if (value[i].name != null)
				output += startTag;
			if (value[i].value == null) {
				output += nodesToHtml(value[i].children);
			} else {
				output += value[i].value;
			}
			if (value[i].name != null && startTag != "")
				output += createEndTag(value[i]);
		}
		output = StringTools.replace(output, "" + SpecialChar.Return + SpecialChar.NewLine, "<br/>");
		output = StringTools.replace(output, SpecialChar.NewLine, "<br/>");
		output = StringTools.replace(output, SpecialChar.Return, "<br/>");
		return output;
	}

	public static function nodesToPlainText(value:Array<FormatNode>):String {
		if (value == null)
			return "";
		var output:String = "";
		for (i in 0...value.length) {
			if (value[i].value == null)
				output += nodesToPlainText(value[i].children);
			else
				output += value[i].value;
		}
		return output;
	}

	private static function createStartTag(formatNode:FormatNode):String {
		/*var atts:String = "";
			atts += "<" + formatNode.name;
			for (i in 0...formatNode.attributes.length)
			{
				atts += " " + formatNode.attributes[i].key + "='" + formatNode.attributes[i].value + "'";
			}
			atts += ">";
			return atts; */

		var format:InputFormat = formatNode.format;

		var returnVal:String = "<" + formatNode.name;

		if (format.face != null)
			returnVal += "face=" + format.face;
		if (format.size != null)
			returnVal += "size=" + format.size;
		if (format.color != null)
			returnVal += "color=" + StringTools.hex(format.color, 6);
		if (format.kerning != null)
			returnVal += "kerning=" + format.kerning;
		if (format.leading != null)
			returnVal += "leading=" + format.leading;
		if (format.baseline != null)
			returnVal += "baseline=" + format.baseline;
		if (format.textTransform != null)
			returnVal += "textTransform=" + format.textTransform;
		if (format.href != null)
			returnVal += "href=" + format.href;

		return returnVal + ">";
	}

	static private function createEndTag(formatNode:FormatNode) {
		return "</" + formatNode.name + ">";
	}

	static private function plainText(formatNodes:Array<FormatNode>):String {
		var output:String = "";
		for (i in 0...formatNodes.length) {
			if (formatNodes[i].value != null) {
				output += formatNodes[i].value;
			} else {
				output += plainText(formatNodes[i].children);
			}
		}
		return output;
	}

	/*static public function formatsToHtml(formatLengths:Array<FormatLength>, value:String) 
		{
			var output:String = "";
			var startTags = new Array<OutputTag>();
			var endTags = new Array<OutputTag>();

			var f:Array<FormatLength> = formatLengths.concat([]);
			var valueSplit:Array<String> = value.split("");

			f.sort(SortByStart);
			for (i in 0...f.length)
			{
				if (f[i].isDefault) continue; // Don't output default format
				var startIndex:Null<Int> = f[i].startIndex;
				startTags.push( { index:startIndex, value:createInputFormatStartTag(f[i].format) } );
			}
			f.sort(SortByEnd);
			for (i in 0...f.length)
			{
				if (f[i].isDefault) continue; // Don't output default format
				var endIndex:Null<Int> = f[i].endIndex;
				//if (endIndex < 0) endIndex = 0;
				if (endIndex > valueSplit.length) endIndex = valueSplit.length;
				endTags.push( { index:endIndex, value:"</font>" } );
			}


			for (j in 0...valueSplit.length+1)
			{
				if (j < valueSplit.length){
					for (k in 0...startTags.length)
						if (startTags[k].index == j) {
							output += startTags[k].value;
						}
					output += valueSplit[j];
				}
				for (k in 0...endTags.length) {
					if (endTags[k].index == j) {
						output += endTags[k].value;
					}
				}
			}
			output = output.split(SpecialChar.NewLine).join("<br/>").split(SpecialChar.Return).join("<br/>");
			//var xml:Xml = clearString(output);

			formatLengths.sort(SortByStartAndEnd);

			return output;
	}*/
	/*static public function applyFormats(nodes:Array<FormatNode>, formatLengths:Array<FormatLength>) 
		{
			for (i in 0...nodes.length)
			{
				var node:FormatNode = nodes[i];
				for (j in 0...formatLengths.length)
				{

				}
			}
	}*/
	/*static function SortByStartAndEnd(a:FormatLength, b:FormatLength):Int
		{
			if (a.startIndex < b.startIndex) return -1;
			if (a.startIndex > b.startIndex) return 1;
			if (a.endIndex < b.endIndex) return -1;
			if (a.endIndex > b.endIndex) return 1;
			return 0;
		}

		static function SortByStart(a:FormatLength, b:FormatLength):Int
		{
			if (a.startIndex < b.startIndex) return -1;
			if (a.startIndex > b.startIndex) return 1;
			return 0;
		}

		static function SortByEnd(a:FormatLength, b:FormatLength):Int
		{
			if (a.endIndex < b.endIndex) return -1;
			if (a.endIndex > b.endIndex) return 1;
			return 0;
	}*/
	private static function createInputFormatStartTag(inputFormat:InputFormat):String {
		var atts:String = "";

		if (inputFormat.color != null)
			atts += " color='#" + StringTools.hex(inputFormat.color, 6) + "'";
		if (inputFormat.face != null)
			atts += " face='" + inputFormat.face + "'";
		if (inputFormat.kerning != null && inputFormat.kerning != 0)
			atts += " kerning='" + inputFormat.kerning + "'";
		if (inputFormat.leading != null && inputFormat.leading != 0)
			atts += " leading='" + inputFormat.leading + "'";
		if (inputFormat.baseline != null && inputFormat.baseline != 0)
			atts += " baseline='" + inputFormat.baseline + "'";
		if (inputFormat.textTransform != null)
			atts += " transform='" + inputFormat.textTransform + "'";
		if (inputFormat.href != null)
			atts += " href='" + inputFormat.href + "'";
		if (inputFormat.size != null)
			atts += " size='" + inputFormat.size + "'";

		if (atts != "")
			atts = "<font" + atts + ">";

		return atts;
	}

	public static function getFormat(textDisplay:TextDisplay, nodes:Array<FormatNode>, begin:Null<Int>, end:Null<Int>):InputFormat {
		var returnFormat = new InputFormat();
		if (nodes.length == 0 || begin < 0)
			return returnFormat;

		incompatibleCheck.clear();

		if (end == begin)
			end++;
		if (end > textDisplay.contentModel.characters.length) {
			end = textDisplay.contentModel.characters.length;
			begin = end - 1;
		}
		for (j in begin...end) {
			var char:Char = textDisplay.contentModel.characters[j];
			copyCommonValues(returnFormat, incompatibleCheck, char.format);
		}

		return returnFormat;
	}

	public static function copyCommonValues(copyTo:InputFormat, incompatible:InputFormat, copyFrom:InputFormat) {
		if (copyFrom == null)
			return;
		if (copyFrom.size != null) {
			if (copyTo.size == null && incompatible.size == null)
				copyTo.size = incompatible.size = copyFrom.size;
			else if (copyTo.size != copyFrom.size)
				copyTo.size = null;
		}
		if (copyFrom.face != null) {
			if (copyTo.face == null && incompatible.face == null)
				copyTo.face = incompatible.face = copyFrom.face;
			else if (copyTo.face != copyFrom.face)
				copyTo.face = null;
		}
		if (copyFrom.color != null) {
			if (copyTo.color == null && incompatible.color == null)
				copyTo.color = incompatible.color = copyFrom.color;
			else if (copyTo.color != copyFrom.color)
				copyTo.color = null;
		}
		if (copyFrom.kerning != null) {
			if (copyTo.kerning == null && incompatible.kerning == null)
				copyTo.kerning = incompatible.kerning = copyFrom.kerning;
			else if (copyTo.kerning != copyFrom.kerning)
				copyTo.kerning = null;
		}
		if (copyFrom.baseline != null) {
			if (copyTo.baseline == null && incompatible.baseline == null)
				copyTo.baseline = incompatible.baseline = copyFrom.baseline;
			else if (copyTo.baseline != copyFrom.baseline)
				copyTo.baseline = null;
		}
		if (copyFrom.leading != null) {
			if (copyTo.leading == null && incompatible.leading == null)
				copyTo.leading = incompatible.leading = copyFrom.leading;
			else if (copyTo.leading != copyFrom.leading)
				copyTo.leading = null;
		}
		if (copyFrom.textTransform != null) {
			if (copyTo.textTransform == null && incompatible.textTransform == null)
				copyTo.textTransform = incompatible.textTransform = copyFrom.textTransform;
			else if (copyTo.textTransform != copyFrom.textTransform)
				copyTo.textTransform = null;
		}
		if (copyFrom.href != null) {
			if (copyTo.href == null && incompatible.href == null)
				copyTo.href = incompatible.href = copyFrom.href;
			else if (copyTo.href != copyFrom.href)
				copyTo.href = null;
		}
	}

	static public function removeAfterIndex(nodes:Array<FormatNode>, index:Int) {
		var i:Int = nodes.length - 1;
		while (i >= 0) {
			var node:FormatNode = nodes[i];
			if (index <= node.startIndex)
				nodes.splice(i, 1);
			else if (index <= node.endIndex && index > node.startIndex) {
				if (node.children.length > 0) {
					removeAfterIndex(node.children, index);
				} else {
					var len:Int = node.value.length - (node.endIndex - (index - 1));
					node.value = node.value.substr(0, len);
				}
				node.endIndex = (index - 1);
			}
			i--;
		}
	}
	/*static public function removeLineBreaks(v:String) 
		{
			return v.split(SpecialChar.Return).join("").split(SpecialChar.NewLine).join("").split("<br>").join("").split("<br/>").join("");
	}*/
}

class FormatNode {
	@:isVar public var value(get, set):String;
	@:isVar public var startIndex(get, set):Int = 0;
	@:isVar public var endIndex(get, set):Int = 0;
	public var parent:FormatNode;
	public var name:String = "font";
	// public var attributes = new Array<FormatAttribute>();
	public var children = new Array<FormatNode>();
	public var format:InputFormat = new InputFormat();

	public function new() {}

	/*public function clone():FormatNode
		{
			var formatNode:FormatNode = newFormatNode();
			formatNode.parent = this.parent;
			formatNode.name = this.name;
			formatNode.value = this.value;
			formatNode.attributes = this.attributes;
			formatNode.children = this.children;
			formatNode.startIndex = this.startIndex;
			formatNode.endIndex = this.endIndex;
			formatNode.format = this.format;
			return formatNode;
	}*/
	function get_value():String {
		return value;
	}

	function set_value(v:String):String {
		#if js
		if (Std.is(v, Xml))
			value = cast(v, Xml).nodeValue;
		else
			value = v;
		#else
		value = v;
		#end

		return value;
	}

	function get_startIndex():Int {
		return startIndex;
	}

	function set_startIndex(value:Int):Int {
		startIndex = value;
		if (startIndex < 0)
			startIndex = 0;
		return startIndex;
	}

	function get_endIndex():Int {
		return endIndex;
	}

	function set_endIndex(value:Int):Int {
		endIndex = value;
		if (endIndex < 0)
			endIndex = 0;
		return endIndex;
	}

	public function clear() {
		value = null;
		startIndex = 0;
		endIndex = 0;
		parent = null;
		name = "font";
		// attributes = new Array<FormatAttribute>();
		children = [];
		format.clear();
	}
}
/*class FormatAttribute
	{
	public var key:String;
	public var value:String;

	public function new(key:String, value:String)
	{
		this.key = key;
		this.value = value;
	}
	}

	typedef OutputTag =
	{
	index:Int,
	value:String
}*/
