package fuse.core.backend.display;

import fuse.core.backend.layerCache.LayerCache;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.utils.Pool;
import fuse.utils.Color;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse.texture)
class CoreImage extends CoreDisplayObject
{
	@:isVar public var textureId(get, set):Int = -1;
	
	public var vertexData	:IVertexData;
	public var indicesData	:IIndicesData;
	public var coreTexture	:CoreTexture;
	public var mask			:CoreImage;
	public var renderLayer	:Int = 0;
	
	var color				:Color = 0x0;
	var targetWidth			:Float;
	var targetHeight		:Float;
	var drawIndex			:Int = -1;
	var updateUVs			:Int = 0;
	var renderTarget		:Int = -1;
	var textureDef			:TextureDef;
	var layerCache			:LayerCache;
	var transformXMul		:Float = 0;
	var transformYMul		:Float = 0;
	
	public function new() 
	{
		super();
		vertexData = new VertexData();
		indicesData = new IndicesData();
	}
	
	override function pushTransform() 
	{
		super.pushTransform();
		
		if (Core.hierarchyBuildRequired) {
			Core.displayListBuilder.visHierarchy.push(this);
		}
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
			
			updateUVs = 0;
		}
		return value;
	}
	
	override function readDisplayData() 
	{
		super.readDisplayData();
		
		// TODO: add ability to update textureID after Image creation
		/*trace("CHECK THIS ISN'T CAUSING ISSUES");
		if (coreTexture.textureData.placed == 0) {
			coreTexture.textureData.placed = 1;
		}*/
		
		if (isStatic == 0 || parentNonStatic) {
			color = displayData.color;
			renderLayer = displayData.renderLayer;
			textureId = displayData.textureId;
		}
	}
	
	override function updateIsStatic() 
	{
		super.updateIsStatic();
		
		if (isStatic == 1 && coreTexture.textureHasChanged) {
			isStatic = 0; // If texture has change then set isStatic to false
		}
	}
	
	override public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
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
}