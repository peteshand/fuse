package fuse.core.backend.display;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.utils.Pool;
import fuse.display.geometry.Bounds;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse.texture)
class CoreImage extends CoreDisplayObject implements ICoreRenderable
{
	@:isVar public var textureId(get, set):Int = -1;
	
	public var vertexData	:IVertexData;
	public var coreTexture	:CoreTexture;
	//public var textureChanged:Bool = false;
	
	@:isVar public var textureIndex(get, set):Int;
	@:isVar public var mask(default, set):CoreImage;
	public var maskChanged:Bool = false;
	
	public var isMask:Bool = false;
	public var maskOf:Array<CoreImage> = [];
	
	public var renderLayer	:Int = 0;
	
	public var drawIndex	:Int = -1;
	//var updateUVs			:Bool = false;
	var renderTarget		:Int = -1;
	public var sourceTextureId(get, null):Int;
	
	var count:Int = 0;
	
	public function new() 
	{
		super();
		vertexData = new VertexData();
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
		alpha = Graphics.parent.alpha * displayData.alpha;
		visible = (Graphics.parent.visible && (displayData.visible == 1));
		
		//trace("updateAny = " + updateAny);
		if (updateAny) {
			Fuse.current.conductorData.backIsStatic = 0;
		}
		
		//trace([isRotating, isMoving, isStatic]);
		
		if (updateTexture || updateVisible) textureId = displayData.textureId;
		
		if (updatePosition || updateVisible || this.isMask) {
			
			renderLayer = displayData.renderLayer;
			
			WorkerTransformHelper.update(this);
		}
	}
	
	//override function popTransform() 
	//{
		//
	//}
	
	override public function buildTransformActions()
	{
		if (this.visible || this.isMask){
			HierarchyAssembler.transformActions.push(calculateTransform);
			//HierarchyAssembler.transformActions.push(popTransform);
		}
	}
	
	inline function get_textureId():Int { return textureId; }
	
	function set_textureId(value:Int):Int {
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				coreTexture.onTextureChange.remove(OnTextureChange);
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
				if (coreTexture != null) coreTexture.onTextureChange.add(OnTextureChange);
			}
			
			setUpdates(true);
			//textureChanged = true;
			//updateUVs = true;
		}
		return value;
	}
	
	function OnTextureChange() 
	{
		updateAny = updateTexture = true;
	}
	
	//override function beginSetChildrenIsStatic(value:Bool) 
	//{
		//
	//}
	
	//override public function buildHierarchy() 
	//{
		//HierarchyAssembler.transformActions.push(pushTransform);
	//}
	
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
	
	////////////////////////////////////////////////////////////////
	// New Assembler ///////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	
	override public function buildHierarchy()
	{
		if (displayData.visible == 1 || this.isMask){
			HierarchyAssembler.hierarchy.push(this);
		}
	}
	
	public function getBounds():Bounds
	{
		bounds.left = Math.POSITIVE_INFINITY;
		bounds.right = Math.NEGATIVE_INFINITY;
		bounds.top = Math.NEGATIVE_INFINITY;
		bounds.bottom = Math.POSITIVE_INFINITY;
		
		//for (i in 0...quadData.length) 
		//{
			//if (i % 2 == 0){
				//if (bounds.left > quadData[i]) bounds.left = quadData[i];
				//if (bounds.right < quadData[i]) bounds.right = quadData[i];
			//}
			//else {
				//if (bounds.top < quadData[i]) bounds.top = quadData[i];
				//if (bounds.bottom > quadData[i]) bounds.bottom = quadData[i];
			//}
		//}
		
		return bounds;
	}
	
	function get_sourceTextureId():Int 
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