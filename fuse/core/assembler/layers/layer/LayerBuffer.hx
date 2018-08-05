package fuse.core.assembler.layers.layer;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.display.CoreImage;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class LayerBuffer
{
	/*Defines the layer index*/
	public var index:Int;
	
	var renderablesData = new RenderablesData();
	public var renderables(get, null):GcoArray<ICoreRenderable>;
	/*Holds all images contained in this layer*/
	//public var renderables(get, null):GcoArray<ICoreRenderable>;
	//var lastRenderables(get, null):GcoArray<ICoreRenderable>;
	//var renderablesIndex(default, set):Int = 0;
	//var activeIndex:Int = 0;
	//var inactiveIndex:Int = 0;
	//var renderables1 = new GcoArray<ICoreRenderable>([]);
	//var renderables2 = new GcoArray<ICoreRenderable>([]);
	//var renderablesArray:Array<GcoArray<ICoreRenderable>>;
	
	/*Defines if the images contained in this layer are static or moving*/
	public var updateAll:Bool;
	public var isStatic(get, null):Int;
	public var hasChanged(get, null):Bool;
	/*Defines where to render layer content*/
	public var renderTarget:Int = -1;
	
	/*Defines the number of images contained in this layer*/
	public var numRenderables(get, null):Int;
	
	/*Defines if the layer is static and is active.
	Because there are a limited number of layer buffers, only the layers with the most images will be active*/
	public var isCacheLayer:Bool;
	
	/*Defines if the images have been baked into the layer*/
	public var baked(get, null):Bool;
	
	/*renderImages will equal true if update is true or baked is false*/  
	public var renderImages(get, null):Bool;
	
	// true if the order of renderables or which renderables are included in the layer have changed
	//public var _hasChanged:Bool = false;
	//public var hasChanged(get, null):Bool;
	
	public function new() 
	{
		
	}
	
	public function init(updateAll:Bool, index:Int) 
	{
		isCacheLayer = false;
		renderTarget = -1;
		this.updateAll = updateAll;	
		this.index = index;
		renderablesData.nextFrame();
	}
	
	public function add(image:CoreImage) 
	{
		renderablesData.renderables.push(image);
	}
	
	public function clone():LayerBuffer
	{
		var c:LayerBuffer = Pool.layerBufferes.request();
		c.init(updateAll, index);
		c.isCacheLayer = isCacheLayer;
		return c;
	}
	
	inline function get_numRenderables():Int 
	{
		return renderablesData.renderables.length;
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
	
	//public function objectIds():String
	//{
		//var s:String = "[ ";
		//for (i in 0...renderablesData.renderables.length) 
		//{
			//s += renderablesData.renderables[i].objectId;
			//if (i < renderablesData.renderables.length - 1) s += ",";
		//}
		//s += " ]";
		//return s;
	//}
	
	function get_isStatic():Int 
	{
		if (updateAll) return 0;
		else return 1;
	}
	
	function get_hasChanged():Bool 
	{
		return hasChanged;
	}
	
	function get_renderables():GcoArray<ICoreRenderable> 
	{
		return renderablesData.renderables;
	}
}

class RenderablesData
{
	public var renderables(get, null):GcoArray<ICoreRenderable>;
	public var lastRenderables(get, null):GcoArray<ICoreRenderable>;
	var renderablesIndex(default, set):Int = 0;
	var activeIndex:Int = 0;
	var inactiveIndex:Int = 1;
	var renderablesArray:Array<GcoArray<ICoreRenderable>>;
	
	public var hasChanged(get, null):Bool;
	
	public function new() 
	{
		renderablesArray = [
			new GcoArray<ICoreRenderable>([]),  
			new GcoArray<ICoreRenderable>([])
		];
	}
	
	public function nextFrame() 
	{
		this.renderablesIndex++;
		renderables.clear();
	}
	
	inline function get_renderables():GcoArray<ICoreRenderable> 
	{
		return renderablesArray[activeIndex];
	}
	
	inline function get_lastRenderables():GcoArray<ICoreRenderable> 
	{
		return renderablesArray[inactiveIndex];
	}
	
	function set_renderablesIndex(value:Int):Int 
	{
		renderablesIndex = value;
		activeIndex = renderablesIndex % 2;
		inactiveIndex = (renderablesIndex + 1) % 2;
		return renderablesIndex;
	}
	
	function get_hasChanged():Bool 
	{
		if (lastRenderables.length != renderables.length) {
			return true;
		}
		else {
			for (i in 0...renderables.length) 
			{
				if (renderables[i] != lastRenderables[i]) {
					return true;
				}
			}
		}
		return false;
	}
}