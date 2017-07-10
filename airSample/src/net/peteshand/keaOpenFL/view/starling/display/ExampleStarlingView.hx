package net.peteshand.keaOpenFL.view.starling.display;

import com.imagination.core.managers.state.StateManager;
import com.imagination.core.managers.transition.Transition;
import com.imagination.core.managers.layout2.LayoutManager;
import com.imagination.core.managers.layout2.settings.LayoutScale;
import com.imagination.core.view.starling.ISceneView;
import com.imagination.util.font.StarlingFont;
import com.imagination.kea.definitions.colorPalette.ColorPalette;
import com.imagination.kea.definitions.state.State;

import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * ...
 * @author P.J.Shand
 */

class ExampleStarlingView extends Sprite implements ISceneView
{
	public var transition =  new Transition();
	public var state:StateManager = State.STATE_2;
	
	public function new():Void
	{
		super();
	}
	
	public function initialize():Void
	{
		var quad:Quad = new Quad(300, 300, ColorPalette.COLOUR3);
		addChild(quad);
		
		var text:TextField = new TextField(200, 100, "Starling View", StarlingFont.make("telstraAkkuratRg", "TelstraAkkuratRg", 100), 24);
		text.hAlign = HAlign.LEFT;
		text.vAlign = VAlign.TOP;
		addChild(text);
		text.x = 20;
		text.y = 17;
		
		LayoutManager.add(this)
			.scale(LayoutScale.VERTICAL)
			.align(0.5, 0.5)
			.anchor(0.5, 0.5);
		
		transition.add(this, { alpha:[0, 1] } );
	}
}
