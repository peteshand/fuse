# Texture API Spec

## Disclaimer ##
This APIs are currently not implemented. The purpose of this document is to define a spec and gather feedbck before implementing.

## Texture Types ##
* BitmapTexture
* ImageTexture
* VideoTexture
* AnimatedTexture
* ColorTexture

### BitmapTexture ###
    var texture = Texture.createBitmapTexture(bmd);

### ImageTexture ###
    var texture = Texture.createImageTexture('/path/to/image.png');

### VideoTexture ###
    var texture = Texture.createVideoTexture('/path/to/video.mp4');

### AnimatedTexture ###
    var urls:Array<String> = [
    	'/path/to/image1.png',
    	'/path/to/image2.png',
    	'/path/to/image3.png'
    ];
    var texture = Texture.createAnimatedTexture(urls, 30);

### ColorTexture ###
    var texture = Texture.createColorTexture(0xFF66AA44);