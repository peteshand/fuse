package fuse.core.backend.display;

import fuse.geom.Point;
import fuse.geom.Rectangle;
import fuse.utils.PowerOfTwo;

class CoreMask {
	public var image:CoreImage;
	public var mask:CoreImage;
	public var uvs:Array<Point> = [];
	public var maskUVs:Array<Point> = [];
	public var imageUvs:Array<Point> = [];
	public var alpha(get, null):Float;

	var tempBounds = new TempBounds();
	var fracMaskUV = new Rectangle();
	var fracImageUV = new Rectangle();

	public function new(image:CoreImage, mask:CoreImage) {
		this.image = image;
		this.mask = mask;

		for (i in 0...4) {
			uvs.push(new Point());
			maskUVs.push(new Point());
			imageUvs.push(new Point());
		}
		// mask.addMaskOf(image);
	}

	public function dispose() {
		if (mask != null)
			mask.removeMaskOf(image);
		uvs = null;
		maskUVs = null;
		imageUvs = null;
		image = null;
		mask = null;
	}

	public function updateUVs() {
		var imageRotated:Bool = image.coreTexture.rotate;
		var maskRotated:Bool = mask.coreTexture.rotate;
		// var rotated:Bool = imageRotated || maskRotated;

		var offset:Int = 0;
		/*if (maskRotated != imageRotated){
			if (imageRotated) offset = 3;
			else if (maskRotated) offset = 1;
		}*/

		maskUVs[(offset + 0) % 4].x = mask.coreTexture.uvLeft;
		maskUVs[(offset + 1) % 4].x = mask.coreTexture.uvLeft;
		maskUVs[(offset + 2) % 4].x = mask.coreTexture.uvRight;
		maskUVs[(offset + 3) % 4].x = mask.coreTexture.uvRight;

		maskUVs[(offset + 0) % 4].y = mask.coreTexture.uvBottom;
		maskUVs[(offset + 1) % 4].y = mask.coreTexture.uvTop;
		maskUVs[(offset + 2) % 4].y = mask.coreTexture.uvTop;
		maskUVs[(offset + 3) % 4].y = mask.coreTexture.uvBottom;

		imageUvs[(offset + 0) % 4].x = image.coreTexture.uvLeft;
		imageUvs[(offset + 1) % 4].x = image.coreTexture.uvLeft;
		imageUvs[(offset + 2) % 4].x = image.coreTexture.uvRight;
		imageUvs[(offset + 3) % 4].x = image.coreTexture.uvRight;

		imageUvs[(offset + 0) % 4].y = image.coreTexture.uvBottom;
		imageUvs[(offset + 1) % 4].y = image.coreTexture.uvTop;
		imageUvs[(offset + 2) % 4].y = image.coreTexture.uvTop;
		imageUvs[(offset + 3) % 4].y = image.coreTexture.uvBottom;

		var pixelOffset:Float = mask.absoluteX - image.absoluteX;

		/*for (maskUV in maskUVs){
				maskUV.x -= pixelOffset;
			}
			return; */

		var absoluteRotation = mask.absoluteRotation();
		var rotation = mask.displayData.rotation;
		var scaleX = mask.displayData.scaleX / image.displayData.scaleX;
		var scaleY = mask.displayData.scaleX / image.displayData.scaleY;

		// trace(image.displayData.width / mask.displayData.width);

		var imageP2Width:Float = PowerOfTwo.getNextPowerOfTwo(Math.floor(image.displayData.width));
		var imageP2Height:Float = PowerOfTwo.getNextPowerOfTwo(Math.floor(image.displayData.height));
		var maskP2Width:Float = PowerOfTwo.getNextPowerOfTwo(Math.floor(mask.displayData.width));
		var maskP2Height:Float = PowerOfTwo.getNextPowerOfTwo(Math.floor(mask.displayData.height));

		scaleX *= imageP2Width / image.displayData.width;
		scaleY *= imageP2Height / image.displayData.height;
		scaleX /= maskP2Width / mask.displayData.width;
		scaleY /= maskP2Height / mask.displayData.height;

		/*if (maskRotated && !imageRotated){
			var temp:Float = scaleX;
			scaleX = scaleY;
			scaleY = temp;
		}*/

		var imageRatio:Float = image.displayData.height / image.displayData.width;

		var maskPivotX:Float = mask.displayData.pivotX;
		var maskPivotY:Float = mask.displayData.pivotY;

		var maskFracPivotX:Float = mask.uvPivot.x + fracMaskUV.x;
		var maskFracPivotY:Float = mask.uvPivot.y + fracMaskUV.y;

		maskFracPivotX = fracMaskUV.x + (maskFracPivotX * fracMaskUV.width);
		maskFracPivotY = fracMaskUV.y + (maskFracPivotY * fracMaskUV.height);

		trace("maskFracPivotX = " + maskFracPivotX);
		trace("maskFracPivotY = " + maskFracPivotY);
		trace("maskPivotX = " + maskPivotX);
		trace("maskPivotY = " + maskPivotY);

		var imagePivotX:Float = image.displayData.pivotX;
		var imagePivotY:Float = image.displayData.pivotY;

		var imageFracPivotX:Float = image.uvPivot.x + fracImageUV.x;
		var imageFracPivotY:Float = image.uvPivot.y + fracImageUV.y;

		trace("imagePivotX = " + imagePivotX);
		trace("imagePivotY = " + imagePivotY);

		// var offsetX:Float = (mask.absoluteX - image.absoluteX) / image.displayData.width / image.displayData.scaleX;
		// var offsetY:Float = (mask.absoluteY - image.absoluteY) / image.displayData.height / image.displayData.scaleY;
		trace("mask.absoluteX = " + mask.absoluteX);
		trace("image.absoluteX = " + image.absoluteX);

		var absolutePixelDifX:Float = (mask.absoluteX) - (image.absoluteX);
		var absolutePixelDifY:Float = (mask.absoluteY) - (image.absoluteY);
		trace("absolutePixelDifX = " + absolutePixelDifX);
		trace("absolutePixelDifY = " + absolutePixelDifY);
		var absoluteImageFracDifX:Float = absolutePixelDifX / image.displayData.width;
		var absoluteImageFracDifY:Float = absolutePixelDifY / image.displayData.height;
		trace("absoluteImageFracDifX = " + absoluteImageFracDifX);
		trace("absoluteImageFracDifY = " + absoluteImageFracDifY);

		var offsetX:Float = (mask.absoluteX - image.absoluteX) / mask.displayData.width / mask.displayData.scaleX;
		var offsetY:Float = (mask.absoluteY - image.absoluteY) / mask.displayData.height / mask.displayData.scaleY;

		fracMaskUV.x = mask.coreTexture.textureData.activeData.x / mask.coreTexture.textureData.activeData.p2Width;
		fracMaskUV.y = mask.coreTexture.textureData.activeData.y / mask.coreTexture.textureData.activeData.p2Height;
		fracMaskUV.width = mask.coreTexture.textureData.activeData.width / mask.coreTexture.textureData.activeData.p2Width;
		fracMaskUV.height = mask.coreTexture.textureData.activeData.height / mask.coreTexture.textureData.activeData.p2Height;

		fracImageUV.x = image.coreTexture.textureData.activeData.x / image.coreTexture.textureData.activeData.p2Width;
		fracImageUV.y = image.coreTexture.textureData.activeData.y / image.coreTexture.textureData.activeData.p2Height;
		fracImageUV.width = image.coreTexture.textureData.activeData.width / image.coreTexture.textureData.activeData.p2Width;
		fracImageUV.height = image.coreTexture.textureData.activeData.height / image.coreTexture.textureData.activeData.p2Height;

		if (imageRotated) {
			//    offsetX += fracMaskUV.y;
			//    offsetY += fracMaskUV.x;
		} else {
			// offsetX -= fracMaskUV.x * 0.7;
			//    offsetY += fracMaskUV.y;
		}

		trace("------");

		// var rotScaleY:Float = 0;//(Math.cos(absoluteRotation * 2 / 180 * Math.PI) * 0.5) + 0.5;
		var rotScaleX:Float = (Math.cos((absoluteRotation + 90) * 2 / 180 * Math.PI) * 0.5) + 0.5;
		// trace("rotScaleX = " + rotScaleX);

		// rotScaleY = rotScaleX;

		// rotScaleY *= ((1 / imageRatio) - 1);
		// rotScaleY += 1;

		rotScaleX *= (imageRatio - 1);
		rotScaleX += 1;
		// trace("rotScaleX = " + rotScaleX);

		var imageMaskScaleX:Float = image.displayData.width / mask.displayData.width;
		var imageMaskScaleY:Float = image.displayData.height / mask.displayData.height;

		for (i in 0...maskUVs.length) {
			var uv:Point = uvs[i];
			var maskUV:Point = maskUVs[i];
			var imageUv:Point = imageUvs[i];

			var _x:Float = (maskUV.x - maskFracPivotX) * imageMaskScaleX;
			var _y:Float = (maskUV.y - maskFracPivotY) * imageMaskScaleY;
			trace([_x, _y]);

			var h:Float = Math.sqrt(Math.pow(_x, 2) + Math.pow(_y, 2));
			var currentRot:Float = Math.atan2(_y, _x) * 180 / Math.PI;
			var newRotation:Float = currentRot - rotation;
			uv.x = imageFracPivotX + (Math.cos(newRotation / 180 * Math.PI) * h);
			uv.y = imageFracPivotY + (Math.sin(newRotation / 180 * Math.PI) * h);

			trace([imageFracPivotX, imageFracPivotY]);
			// uv.x -= absoluteImageFracDifX;
			// uv.y -= absoluteImageFracDifY;

			uv.x = maskUV.x * imageMaskScaleX;
			uv.y = maskUV.y * imageMaskScaleY;

			uv.x -= absoluteImageFracDifX;
			uv.y -= absoluteImageFracDifY;

			continue;

			// uv.x -= offsetX * fracMaskUV.width;
			// uv.y -= offsetY * fracMaskUV.height;

			var _x:Float = (maskUV.x - maskFracPivotX) * imageMaskScaleX;
			var _y:Float = (maskUV.y - maskFracPivotY) * imageMaskScaleY;
			var h:Float = Math.sqrt(Math.pow(_x, 2) + Math.pow(_y, 2));
			var currentRot:Float = Math.atan2(_y, _x) * 180 / Math.PI;
			var newRotation:Float = currentRot - rotation;

			trace("imageFracPivotX = " + imageFracPivotX);
			trace("imageFracPivotY = " + imageFracPivotY);

			var imageX:Float = (imageUv.x - imageFracPivotX) * image.displayData.width;
			var imageY:Float = (imageUv.y - imageFracPivotY) * image.displayData.height;
			// var imageH:Float = Math.sqrt(Math.pow(imageX, 2) + Math.pow(imageY, 2));
			trace("imageMaskScaleX = " + imageMaskScaleX);
			trace("imageMaskScaleY = " + imageMaskScaleY);

			trace("imageX = " + imageX);
			trace("imageY = " + imageY);

			var currentRot2:Float = Math.atan2(imageY, imageX) * 180 / Math.PI;
			var newRotation2:Float = currentRot2 - rotation;
			// trace([imageX, imageY, imageH]);

			/*var scaleX2:Float = 0;
				var scaleY2:Float = 0;

				scaleX2 += Math.cos(absoluteRotation / 180 * Math.PI) * scaleX;
				scaleX2 += Math.sin(absoluteRotation / 180 * Math.PI) * scaleY;

				scaleY2 += Math.cos(absoluteRotation / 180 * Math.PI) * scaleY;
				scaleY2 += Math.sin(absoluteRotation / 180 * Math.PI) * scaleX;

				trace([scaleX, scaleX2]); */

			// trace("currentRot = " + currentRot);
			// var m:Float = (Math.cos(absoluteRotation * 2 / 180 * Math.PI) - 1) * -0.5;
			// trace("m = " + m);
			// var h2:Float = h + (m * (imageRatio - 1));
			// trace("h = " + h);
			// trace("_x = " + _x);

			trace("newRotation = " + newRotation);
			trace("newRotation2 = " + newRotation2);
			trace("imageFracPivotX = " + imageFracPivotX);
			trace("imageFracPivotY = " + imageFracPivotY);

			var hx:Float = h; // * rotScaleX;
			var hy:Float = h; // / rotScaleX;

			trace("maskFracPivotX = " + maskFracPivotX);
			trace("maskFracPivotY = " + maskFracPivotY);
			trace("scaleX = " + scaleX);
			trace("scaleX = " + scaleX);

			uv.x = maskFracPivotX + (Math.cos(newRotation / 180 * Math.PI) * h);
			uv.y = maskFracPivotY + (Math.sin(newRotation / 180 * Math.PI) * h);

			// uv.x /= scaleX;
			// uv.y /= scaleY;

			// uv.x = maskFracPivotX + (Math.cos(newRotation / 180 * Math.PI) * h / scaleX);
			// uv.y = maskFracPivotY + (Math.sin(newRotation / 180 * Math.PI) * h / scaleY);

			// uv.x -= Math.cos(absoluteRotation / 180 * Math.PI) * offsetX * fracMaskUV.width;
			// uv.x -= Math.sin(absoluteRotation / 180 * Math.PI) * offsetY * fracMaskUV.height;

			// uv.y -= Math.cos(absoluteRotation / 180 * Math.PI) * offsetY * fracMaskUV.height;
			// uv.y += Math.sin(absoluteRotation / 180 * Math.PI) * offsetX * fracMaskUV.width;
		}
	}

	/*function removeRotation(p:Point)
		{
			var r:Float = Core.WINDOW_WIDTH / Core.WINDOW_HEIGHT;

			vertexToPixelSpace(p);

			p.x -= mask.absoluteX;
			p.y -= mask.absoluteY;

			var h:Float = Math.sqrt(Math.pow(p.x, 2) + Math.pow(p.y, 2));
			var currentRot:Float = Math.atan2(p.y, p.x) * 180 / Math.PI;
			var absoluteRotation = mask.absoluteRotation();
			var newRotation:Float = currentRot - absoluteRotation;

			p.x = Math.cos(newRotation / 180 * Math.PI) * h;
			p.y = Math.sin(newRotation / 180 * Math.PI) * h;

			p.x += mask.absoluteX;
			p.y += mask.absoluteY;

			pixelToVertexSpace(p);
		}

		function vertexToPixelSpace(p:Point)
		{
			p.x = vertexToPixelSpaceX(p.x);
			p.y = vertexToPixelSpaceY(p.y);
		}

		inline function vertexToPixelSpaceX(v:Float)
		{
			return ((v + 1) * 0.5) * Core.WINDOW_WIDTH;
		}

		inline function vertexToPixelSpaceY(v:Float)
		{
			return ((v - 1) * -0.5) * Core.WINDOW_HEIGHT;
		}


		function pixelToVertexSpace(p:Point)
		{
			p.x = pixelToVertexSpaceX(p.x);
			p.y = pixelToVertexSpaceY(p.y);
		}

		inline function pixelToVertexSpaceX(v:Float)
		{
			return (v / Core.WINDOW_WIDTH / 0.5) - 1;
		}

		inline function pixelToVertexSpaceY(v:Float)
		{
			return (v / Core.WINDOW_HEIGHT / -0.5) + 1;
	}*/
	function get_alpha():Float {
		return mask.alpha;
	}
}

class TempBounds {
	public var bottomLeft = new Point();
	public var topLeft = new Point();
	public var topRight = new Point();
	public var bottomRight = new Point();

	public function new() {}
}
