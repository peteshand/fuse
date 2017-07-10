package net.peteshand.keaOpenFL.view.away3d.display;

import com.imagination.core.managers.state.StateManager;
import com.imagination.core.managers.transition.Transition;
import com.imagination.core.view.starling.ISceneView;
import com.imagination.util.font.AwayFont;
import com.imagination.kea.definitions.colorPalette.ColorPalette;
import com.imagination.kea.definitions.state.State;

import away3d.containers.ObjectContainer3D;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.textfield.TextField;
import away3d.textfield.HAlign;
import away3d.textfield.VAlign;

/**
 * ...
 * @author P.J.Shand
 */
class ExampleAwayView extends ObjectContainer3D implements ISceneView 
{
	public var transition =  new Transition();
	public var state:StateManager = State.STATE_1;
	
	public function new() 
	{
		super();
	}
	
	public function initialize():Void 
	{
		var material = new ColorMaterial(ColorPalette.COLOUR2);
		material.alphaPremultiplied = false;
		material.alphaBlending = true;
		
		var quad:Mesh = new Mesh(new PlaneGeometry(1000,1000,1,1,false), material);
		addChild(quad);
		
		var text:TextField = new TextField(1000, 1000, "Away3D View", AwayFont.make("telstraAkkuratRg", "TelstraAkkuratRg", 100), 42);
		text.rotationX = 90;
		text.x = -500 + 22;
		text.y =  500 - 15;
		text.z = -1;
		text.hAlign = HAlign.LEFT;
		text.vAlign = VAlign.TOP;
		addChild(text);
		
		transition.add(quad.material, { alpha:[0, 1] } );
		transition.add(text, { alpha:[0, 1] } ).autoVisObject(this);
	}
}
