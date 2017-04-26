package kea.logic;

import kea.logic.profiling.ProfileMonitor;
import kea.logic.renderer.Renderer;
import kea.logic.displaylist.DisplayList;
import kea.logic.layerConstruct.LayerConstruct;
import kea.logic.buffers.atlas.AtlasBuffer;
import kea.logic.updater.Updater;

/**
 * ...
 * @author P.J.Shand
 */
class Logic
{
	public var displayList:DisplayList;
	public var updater:Updater;
	public var layerConstruct:LayerConstruct;
	public var atlasBuffer:AtlasBuffer;
	public var renderer:Renderer;
	public var profileMonitor:ProfileMonitor;
	
	
	public function new() 
	{
		displayList = new DisplayList();
		updater = new Updater();
		layerConstruct = new LayerConstruct();
		atlasBuffer = new AtlasBuffer();
		renderer = new Renderer();
		profileMonitor = new ProfileMonitor();
	}
}