package net.peteshand.keaOpenFL;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
class TransparentTest extends Sprite
{

	public function new() 
	{
		super();
	}
	
	public function init() 
	{
		var bmd1:BitmapData = Assets.getBitmapData("img/keaSquare.png");
		
		
		//var img:BitmapData = imgBitmap.bitmapData;
		//var mask:BitmapData = maskBitmap.bitmapData;
		var mergeBmp:BitmapData = new BitmapData(bmd1.width, bmd1.height, true, 0xFF000000);
		//var rect:Rectangle = new Rectangle(0, 0, img.width, img.height);
		//mergeBmp.copyPixels(img, rect, new Point());
		mergeBmp.lock();
		mergeBmp.copyChannel(bmd1, bmd1.rect, bmd1.rect.topLeft, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
		mergeBmp.copyChannel(bmd1, bmd1.rect, bmd1.rect.topLeft, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
		mergeBmp.copyChannel(bmd1, bmd1.rect, bmd1.rect.topLeft, BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
		//return new Bitmap(mergeBmp);
		mergeBmp.unlock();
		
		
		//var outputBitmapData:BitmapData = new BitmapData(200, 200, true); 
		//var destPoint:Point = new Point(0, 0); 
		//var sourceRect:Rectangle = new Rectangle(0, 0, outputBitmapData.width, outputBitmapData.height); 
		var threshold:UInt =  0xFFFFFFFF;  
		var color:UInt = 0x00000000;     
		var mask:UInt = 0xFFFF00FF;     
		mergeBmp.threshold(mergeBmp, mergeBmp.rect, mergeBmp.rect.topLeft, "!=", threshold, color, mask, true);
		
		var rect:Rectangle = mergeBmp.getColorBoundsRect(mask, color, true);
		trace("rect = " + rect);
		
		//mergeBmp.fillRect(rect, 0x55FF0000);
		
		var bitmap:Bitmap = new Bitmap(mergeBmp);
		addChild(bitmap);
	}
	
}