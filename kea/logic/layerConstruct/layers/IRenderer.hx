package kea.logic.layerConstruct.layers;

import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kha.graphics2.Graphics;

/**
 * @author P.J.Shand
 */
interface IRenderer 
{
	var layerDefinition:LayerDefinition;
	function cache(graphics:Graphics):Void;
	function render(graphics:Graphics):Void;
}