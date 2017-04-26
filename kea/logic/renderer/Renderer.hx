package kea.logic.renderer;

import kea.logic.layerConstruct.LayerConstruct;
import kea.display.IDisplay;
import kea.logic.layerConstruct.layers.IRenderer;
import kea.logic.buffers.atlas.AtlasBuffer;
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
	private static var maxLayers:Int = 5;
	
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
			/*trace(
				"startIndex  = " + layers[i].startIndex  
				+ " endIndex = " + layers[i].endIndex
				+ " displays.length  = " + (layers[i].displays.length)  
				+ " isStatic = " + layers[i].isStatic);*/
			
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
		graphics.begin(true, 0x00444499);	
		//graphics.imageScaleQuality = ImageScaleQuality.Low;	
		for (i in 0...renderers.length){
			
			renderers[i].render(graphics);
		}
		//graphics.drawImage(Kea.current.atlasBuffer.textureAtlas.texture, 0, 0);
		
		graphics.end();
		
		Renderer.layerStateChangeAvailable = false;	
	}
}
