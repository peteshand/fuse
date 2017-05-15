package kea.logic.renderer;

import kea.logic.buffers.atlas.renderer.TextureAtlas;
import kea.logic.layerConstruct.LayerConstruct;
import kea.display.IDisplay;
import kea.logic.layerConstruct.layers.IRenderer;
import kea.logic.buffers.atlas.AtlasBuffer;
import kea.model.buffers.Buffer;
import kha.graphics2.Graphics;
import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.logic.layerConstruct.layers.DirectRenderer;
import kea.logic.layerConstruct.layers.CacheRenderer;
import kha.graphics2.ImageScaleQuality;

class Renderer
{	
	private var directRenderers:Array<DirectRenderer> = [];
	private var cacheRenderers:Array<CacheRenderer> = [];
	private var renderers:Array<IRenderer> = [];
	private static var maxLayers:Int = 2;
	
	public var layers:Array<LayerDefinition>;
	var directCount:Int = 0;
	var cacheCount:Int = 0;
	static var layerStateChangeAvailable:Bool = true;
	
	public function new() {
		for (i in 0...maxLayers){
			directRenderers.push(new DirectRenderer());
			cacheRenderers.push(new CacheRenderer());
		}
	}
	
	@:access(kea.logic.buffers.atlas.AtlasBuffer)
	public function render(graphics:Graphics):Void
	{
		//trace("render");
		
		directCount = 0;
		cacheCount = 0;
		
		renderers = [];
		
		for (i in 0...layers.length){
			//trace(
				//"startIndex  = " + layers[i].startIndex  
				//+ " endIndex = " + layers[i].endIndex
				////+ " displays.length  = " + (layers[i].displays.length)  
				//+ " isStatic = " + layers[i].isStatic);
			
			if (layers[i].isStatic == true){
				var cacheRenderer:CacheRenderer = cacheRenderers[cacheCount];
				cacheRenderer.layerDefinition = layers[i];
				renderers.push(cacheRenderer);
				cacheCount++;
			}
			else {
				var directRenderer:DirectRenderer = directRenderers[directCount];
				directRenderer.layerDefinition = layers[i];
				renderers.push(directRenderer);
				directCount++;
			}
		}
		
		//trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> renderers.length = " + renderers.length);
		for (i in 0...renderers.length){
			renderers[i].cache(graphics);
		}
		//trace("---------------------");
		graphics.begin(true, 0x00FFFFFF);
		
		// Set background color
		/*graphics.color = 0xFFAADD22;
		graphics.fillRect(0, 0, Buffer.bufferWidth, Buffer.bufferHeight);
		graphics.color = 0xFFFFFFFF;*/
		
		//graphics.imageScaleQuality = ImageScaleQuality.Low;	
		if (!Kea.current.model.keaConfig.debugSkipRender){
			for (i in 0...renderers.length){
				
				renderers[i].render(graphics);
			}
		}
		
		if (Kea.current.model.keaConfig.debugTextureAtlas){
			debugTextureAtlases(graphics);
		}
		
		
		graphics.end();
		
		Renderer.layerStateChangeAvailable = false;	
	}
	
	function debugTextureAtlases(graphics:Graphics) 
	{
		for (i in 0...Kea.current.logic.atlasBuffer.atlases.length) 
		{
			var textureAtlas:TextureAtlas = Kea.current.logic.atlasBuffer.atlases[i];
			if (textureAtlas.active) {
				var width:Int = Math.floor(textureAtlas.texture.width / 2);
				var height:Int = Math.floor(textureAtlas.texture.height / 2);
				
				graphics.drawScaledImage(textureAtlas.texture, (width + 20) * i, 0, width, height);
			}
		}
	}
}
