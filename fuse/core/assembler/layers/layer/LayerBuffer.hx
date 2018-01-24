package fuse.core.assembler.layers.layer;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.display.CoreImage;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class LayerBuffer
{
	/*Defines the layer index*/
	public var index:Int;
	
	/*Holds all images contained in this layer*/
	public var renderables = new GcoArray<ICoreRenderable>([]);
	public var lastRenderables = new GcoArray<ICoreRenderable>([]);
	
	/*Defines if the images contained in this layer are static or moving*/
	public var isStatic:Int;
	
	/*Defines where to render layer content*/
	public var renderTarget:Int = -1;
	
	/*Defines the number of images contained in this layer*/
	public var numRenderables(get, null):Int;
	
	/*Defines if the layer is static and is active.
	Because there are a limited number of layer buffers, only the layers with the most images will be active*/
	public var isCacheLayer:Bool;
	
	/*Defines if the images have been baked into the layer*/
	public var baked(get, null):Bool;
	
	/*renderImages will equal true if isStatic or baked are false*/  
	public var renderImages(get, null):Bool;
	
	// true if the order of renderables or which renderables are included in the layer have changed
	//public var _hasChanged:Bool = false;
	//public var hasChanged(get, null):Bool;
	
	public function new() 
	{
		
	}
	
	public function init(isStatic:Int, index:Int) 
	{
		isCacheLayer = false;
		renderTarget = -1;
		this.isStatic = isStatic;	
		this.index = index;
		renderables.clear();
	}
	
	public function add(image:CoreImage) 
	{
		renderables.push(image);
	}
	
	public function clone():LayerBuffer
	{
		var c:LayerBuffer = Pool.layerBufferes.request();
		c.init(isStatic, index);
		//for (i in 0...renderables.length) 
		//{
			//c.renderables.push(renderables[i]);
		//}
		c.isCacheLayer = isCacheLayer;
		return c;
	}
	
	inline function get_numRenderables():Int 
	{
		return renderables.length;
	}
	
	inline function get_baked():Bool 
	{
		return false;
	}
	
	inline function get_renderImages():Bool 
	{
		if (!isCacheLayer) return true;
		if (!baked) return true;
		return false;
	}
	
	public function objectIds():String
	{
		var s:String = "[ ";
		for (i in 0...renderables.length) 
		{
			s += renderables[i].objectId;
			if (i < renderables.length - 1) s += ",";
		}
		s += " ]";
		return s;
	}
	
	//function get_hasChanged():Bool 
	//{
		//_hasChanged = false;
		//if (lastRenderables.length != renderables.length) {
			//_hasChanged = true;
		//}
		//else {
			//for (i in 0...renderables.length) 
			//{
				//if (renderables[i] != lastRenderables[i]) {
					//_hasChanged = true;
					//break;
				//}
			//}
		//}
		//lastRenderables.clear();
		//for (i in 0...renderables.length) 
		//{
			//lastRenderables.push(renderables[i]);
		//}
		//return _hasChanged;
	//}
}