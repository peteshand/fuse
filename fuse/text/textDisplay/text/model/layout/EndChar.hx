package fuse.text.textDisplay.text.model.layout;

/**
 * ...
 * @author P.J.Shand
 */
class EndChar extends Char {
	var textDisplay:TextDisplay;

	public function new(character:String, index:Int = 0, textDisplay:TextDisplay) {
		super(character, index);
		this.textDisplay = textDisplay;
	}

	override function get_scale():Float {
		if (textDisplay.formatModel.defaultFormat.size == null) {
			return 1;
		} else {
			return textDisplay.formatModel.defaultFormat.size / textDisplay.formatModel.defaultFont.size;
		}
	}
}
