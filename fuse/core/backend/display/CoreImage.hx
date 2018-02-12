package fuse.core.backend.display;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
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
	public var textureIndex	:Int;
	public var mask			:CoreImage;
	public var renderLayer	:Int = 0;
	
	var drawIndex			:Int = -1;
	//var updateUVs			:Bool = false;
	var renderTarget		:Int = -1;
	public var sourceTextureId(get, null):Int;
	
	public function new() 
	{
		super();
		vertexData = new VertexData();
	}
	
	override public function init(objectId:Int) 
	{
		super.init(objectId);
		this.textureId = displayData.textureId;
	}
	
	override function calculateTransform() 
	{
		setIsStatic();
		updateTransform();
	}
	
	override function updateTransform() 
	{
		combinedAlpha = Graphics.alpha * displayData.alpha;
		
		if (isStatic == 0) {
			textureId = displayData.textureId;
			renderLayer = displayData.renderLayer;
			WorkerTransformHelper.update(this);
		}
	}
	
	override function popTransform() 
	{
		
	}
	
	inline function get_textureId():Int { return textureId; }
	
	function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
			
			//updateUVs = true;
		}
		return value;
	}
	
	//override function beginSetChildrenIsStatic(value:Bool) 
	//{
		//
	//}
	
	override public function buildHierarchy() 
	{
		HierarchyAssembler.transformActions.push(pushTransform);
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
	
	////////////////////////////////////////////////////////////////
	// New Assembler ///////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	
	override public function buildHierarchy2()
	{
		// TODO: check if visible and parent is visible
		HierarchyAssembler.hierarchy.push(this);
	}
	
	public function getBounds():Bounds
	{
		bounds.left = Math.POSITIVE_INFINITY;
		bounds.right = Math.NEGATIVE_INFINITY;
		bounds.top = Math.NEGATIVE_INFINITY;
		bounds.bottom = Math.POSITIVE_INFINITY;
		
		for (i in 0...quadData.length) 
		{
			if (i % 2 == 0){
				if (bounds.left > quadData[i]) bounds.left = quadData[i];
				if (bounds.right < quadData[i]) bounds.right = quadData[i];
			}
			else {
				if (bounds.top < quadData[i]) bounds.top = quadData[i];
				if (bounds.bottom > quadData[i]) bounds.bottom = quadData[i];
			}
		}
		
		return bounds;
	}
	
	function get_sourceTextureId():Int 
	{
		return coreTexture.textureId;
	}
	
	
}