package fuse.core.backend.display;

import fuse.texture.TextureId;
import fuse.utils.ObjectId;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.utils.Calc;
import fuse.core.utils.Pool;
import fuse.display.geometry.Bounds;
import fuse.core.assembler.batches.batch.BatchType;
/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse.texture)
class CoreImage extends CoreDisplayObject implements ICoreRenderable
{
	@:isVar public var textureId(get, set):ObjectId = -1;
	
	public var vertexData	:IVertexData;
	public var coreTexture	:CoreTexture;
	
	@:isVar public var textureIndex(get, set):Int;
	@:isVar public var mask(default, set):CoreImage;
	public var maskChanged:Bool = false;
	
	public var isMask:Bool = false;
	public var maskOf:Array<CoreImage> = [];
	
	public var blendMode	:Int = 0;
	public var shaderId		:Int = 0;
	public var renderLayer	:Int = 0;
	
	public var drawIndex	:Int = -1;
	public var batchType	:BatchType = null;
	//var updateUVs			:Bool = false;
	var renderTarget		:Int = -1;
	public var sourceTextureId(get, null):TextureId;
	
	var count:Int = 0;
	
	public function new() 
	{
		super();
		vertexData = new VertexData();
		this.displayType = DisplayType.IMAGE;
	}
	
	override public function setUpdates(value:Bool) 
	{
		super.setUpdates(value);
		this.updateTexture = value;
	}
	
	override public function init(objectId:Int) 
	{
		super.init(objectId);
		textureId = displayData.textureId;
	}
	
	
	override function calculateTransform() 
	{
		checkUpdates();
		updateTransform();
	}
	
	override function updateTransform() 
	{
		alpha = parent.alpha * displayData.alpha;
		visible = (parent.visible && (displayData.visible == 1));
		
		//trace("updateAny = " + updateAny);
		if (updateAny) {
			Fuse.current.conductorData.backIsStatic = 0;
		}

		shaderId = displayData.shaderId;
		
		//trace([isRotating, isMoving, isStatic]);
		if (updateColour) {
			blendMode = displayData.blendMode;
		}
		if (updateTexture || updateVisible) {
			textureId = displayData.textureId;
			coreTexture.update();
			coreTexture.uvsHaveChanged = true;
		}
		
		if (updatePosition || updateVisible || this.isMask) {
			
			renderLayer = displayData.renderLayer;
			
			WorkerTransformHelper.update(this);
		}
	}
	
	override public function buildTransformActions()
	{
		visible = (parent.visible && (displayData.visible == 1));

		if (this.visible || this.isMask) {
			hierarchyIndex = HierarchyAssembler.transformActions.length;
			HierarchyAssembler.transformActions.push(calculateTransform);
		}
	}
	
	inline function get_textureId():ObjectId { return textureId; }
	
	function set_textureId(value:ObjectId):ObjectId {
		if (textureId != value){
			textureId = value;
			if (coreTexture != null && textureId == -1) {
				coreTexture.removeChangeListener(this);
				Core.textures.deregister(coreTexture.textureData.baseData.objectId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.baseData.objectId != textureId) {
				coreTexture = Core.textures.register(textureId);
				if (coreTexture != null) coreTexture.addChangeListener(this);
			}
			
			setUpdates(true);
		}
		return value;
	}
	
	public function OnTextureChange() 
	{
		updateAny = updateTexture = true;
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = Pool.images.request();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		return _clone;
	}
	
	override public function recursiveReleaseToPool()
	{
		Pool.images.release(this);
	}
	
	override public function buildHierarchy()
	{
		if (displayData.visible == 1 || this.isMask) {
			HierarchyAssembler.hierarchy.push(this);
		}
	}
	
	public function getBounds():Bounds
	{
		bounds.left = Math.POSITIVE_INFINITY;
		bounds.right = Math.NEGATIVE_INFINITY;
		bounds.top = Math.NEGATIVE_INFINITY;
		bounds.bottom = Math.POSITIVE_INFINITY;
		return bounds;
	}
	
	override public function insideBounds(x:Float, y:Float) 
	{
		var distance:Float = Math.sqrt(
			Math.pow(quadData.middleX - Calc.pixelToScreenX(x), 2) + 
			Math.pow(quadData.middleY - Calc.pixelToScreenY(y), 2)
		);
		
		if (distance < diagonal * 0.5) return true;
		return false;
	}
	
	function get_sourceTextureId():TextureId 
	{
		return coreTexture.textureId;
	}
	
	function get_mask():CoreImage 
	{
		return mask;
	}
	
	function set_mask(value:CoreImage):CoreImage 
	{
		if (mask != value){
			mask = value;
			value.addMaskOf(this);
			maskChanged = true;
		}
		return mask;
	}
	
	function addMaskOf(coreImage:CoreImage) 
	{
		maskOf.push(coreImage);
		isMask = true;
	}
	
	function removeMaskOf(coreImage:CoreImage) 
	{
		var i:Int = maskOf.length - 1;
		while (i >= 0) 
		{
			if (maskOf[i] == coreImage) {
				maskOf.splice(i, 1);
			}
			i--;
		}
		if (maskOf.length == 0) isMask = false;
	}
	
	override function set_updateAny(value:Bool):Bool 
	{
		updateAny = value;
		for (i in 0...maskOf.length) 
		{
			maskOf[i].updateAny = true;
			maskOf[i].maskChanged = true;
		}
		return updateAny;
	}
	
	function get_textureIndex():Int 
	{
		return textureIndex;
	}
	
	function set_textureIndex(value:Int):Int 
	{
		if (textureIndex != value) {
			updateTexture = true;
		}
		return textureIndex = value;
	}
}