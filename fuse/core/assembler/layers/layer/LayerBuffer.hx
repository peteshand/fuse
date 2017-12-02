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
	
	/*Defines if the images contained in this layer are static or moving*/
	public var isStatic:Int;
	
	/*Defines where to render layer content*/
	public var renderTarget:Int = -1;
	
	/*Defines the number of images contained in this layer*/
	public var numRenderables(get, null):Int;
	
	/*Defines if the layer is static and is active.
	Because there are a limited number of layer buffers, only the layers with the most images will be active*/
	public var active:Bool;
	
	/*Defines if the images have been baked into the layer*/
	public var baked(get, null):Bool;
	
	/*renderImages will equal true if isStatic or baked are false*/  
	public var renderImages(get, null):Bool;
	
	public function new() 
	{
		
	}
	
	public function init(isStatic:Int, index:Int) 
	{
		active = false;
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
		c.active = active;
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
		if (!active) return true;
		if (!baked) return true;
		return false;
	}
}