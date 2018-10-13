package fuse.text;

import fuse.core.front.texture.TextFieldTexture;
import fuse.display.Image;

@:forward(antiAliasType, autoSize, background, backgroundColor, border, borderColor, bottomScrollV, caretIndex, defaultTextFormat, displayAsPassword, embedFonts, gridFitType, htmlText, length, maxChars, maxScrollH, maxScrollV, mouseWheelEnabled, multiline, numLines, restrict, scrollH, scrollV, selectable, selectionBeginIndex, selectionEndIndex, sharpness, text, textColor, textHeight, textWidth, type, wordWrap)
abstract AbTextField(Image) to Image from Image
{
    var texture(get, set):TextFieldTexture;

    public function new(width:Int, height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null)
    {
        var t = new TextFieldTexture(width, height, queUpload, onTextureUploadCompleteCallback);
        this = new Image(t);
    }

    function get_texture():TextFieldTexture
    {
        return untyped this.texture;
    }

    function set_texture(value:TextFieldTexture):TextFieldTexture
    {
        return untyped this.texture = value;
    }
}