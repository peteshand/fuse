package kea.core.render;

import kea.display.IDisplay;
import kha.graphics2.Graphics;
import kea.core.render.layers.LayerDef.LayerDefinition;
import kea.core.render.layers.DirectRenderer;
import kea.core.render.layers.CacheRenderer;
import kea.core.render.layers.BaseRenderer;
import kha.graphics2.ImageScaleQuality;

class Renderer
{	
	private var directRenderers:Array<DirectRenderer> = [];
	private var cacheRenderers:Array<CacheRenderer> = [];
	private var renderers:Array<BaseRenderer> = [];
	private static var maxLayers:Int = 5;
	
	var layerDefinitions:Array<LayerDefinition>;
	var directCount:Int = 0;
	var cacheCount:Int = 0;
	static var layerStateChangeAvailable:Bool = true;
	
	public function new() {
		for (i in 0...maxLayers){
			directRenderers.push(new DirectRenderer());
			cacheRenderers.push(new CacheRenderer());
		}
	}
	
	public function render(graphics:Graphics):Void
	{
		//trace("render");
		layerDefinitions = Kea.current.layerDef.calc();
		
		directCount = 0;
		cacheCount = 0;
		
		renderers = [];
		
		for (i in 0...layerDefinitions.length){
			/*trace(
				"startIndex  = " + layerDefinitions[i].startIndex  
				+ " endIndex = " + layerDefinitions[i].endIndex
				+ " displays.length  = " + (layerDefinitions[i].displays.length)  
				+ " isStatic = " + layerDefinitions[i].isStatic);*/
			
			if (layerDefinitions[i].isStatic == true){
				var cacheRenderer:CacheRenderer = cacheRenderers[cacheCount];
				cacheRenderer.layerDefinition = layerDefinitions[i];
				renderers.push(cacheRenderer);
				cacheCount++;
			}
			else {
				var directRenderer:DirectRenderer = directRenderers[directCount];
				directRenderer.layerDefinition = layerDefinitions[i];
				renderers.push(directRenderer);
				directCount++;
			}
		}
		
		//trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> renderers.length = " + renderers.length);
		for (i in 0...renderers.length){
			renderers[i].cache(graphics);
		}
		//trace("---------------------");
		graphics.begin(true, 0xFFFF0000);	
		//graphics.imageScaleQuality = ImageScaleQuality.Low;	
		for (i in 0...renderers.length){
			
			renderers[i].render(graphics);
		}
		graphics.end();
		
		
	}
}
