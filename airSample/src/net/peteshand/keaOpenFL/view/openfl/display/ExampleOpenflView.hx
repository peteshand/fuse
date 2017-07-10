package net.peteshand.keaOpenFL.view.openfl.display;

import com.imagination.core.managers.layout2.LayoutManager;
import com.imagination.core.managers.layout2.settings.LayoutScale;
import com.imagination.core.managers.state.StateManager;
import com.imagination.core.managers.transition.Transition;
import com.imagination.core.view.starling.ISceneView;
import com.imagination.kea.definitions.colorPalette.ColorPalette;
import com.imagination.kea.definitions.state.State;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;


/**
 * ...
 * @author P.J.Shand
 */

class ExampleOpenflView extends Sprite implements ISceneView 
{
	public var transition =  new Transition();
	public var state:StateManager = State.STATE_3;
	
	public function new():Void 
	{
		super();
	}
	
	public function initialize():Void 
	{
		var quad:Shape = new Shape();
		quad.graphics.beginFill(ColorPalette.COLOUR4);
		quad.graphics.drawRect(0, 0, 150, 150);
		addChild(quad);
		
		var text:TextField = new TextField();
		text.width = 150;
		text.height = 150;
		text.x = 15;
		text.y = 15;
		
		text.text = "OpenFl View";
		text.setTextFormat(new TextFormat("_sans", 12, 0xffffff));
		addChild(text);
		
		LayoutManager.add(this)
			.scale(LayoutScale.VERTICAL)
			.align(0.5, 0.5)
			.anchor(0.5, 0.5);
		
		transition.add(this, { alpha:[0, 1] } );
	}
}
