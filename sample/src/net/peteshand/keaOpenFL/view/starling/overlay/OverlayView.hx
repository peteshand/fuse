package net.peteshand.keaOpenFL.view.starling.overlay;
import com.imagination.core.managers.layout2.LayoutManager;
import com.imagination.core.managers.layout2.items.ITransformObject;
import com.imagination.core.managers.resize.Resize;
import com.imagination.core.managers.state.StateManager;
import com.imagination.core.managers.transition.Transition;
import com.imagination.core.view.starling.ISceneView;
import com.imagination.util.font.StarlingFont;
import com.imagination.kea.definitions.state.State;
import net.peteshand.keaOpenFL.view.starling.overlay.close.CloseButtonView;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextDisplay;
import starling.text.model.format.InputFormat;

/**
 * ...
 * @author P.J.Shand
 */

class OverlayView extends Sprite implements ISceneView 
{
	var background:Quad;
	var transformObject:ITransformObject;
	public var transition =  new Transition();
	public var state:StateManager = State.OVERLAY_STATE;

	public function new()
	{
		super();
	}
	
	public function initialize():Void
	{
		background = new Quad(stage.stageWidth, stage.stageHeight, 0xFF000000);
		addChild(background);
		background.alpha = 0;
		
		var panelContainer = new Sprite();
		addChild(panelContainer);
		panelContainer.alpha = 0;
		
		var panel = new Sprite();
		panelContainer.addChild(panel);
		
		var panelBg:Quad = new Quad(640, 360, 0xFFEEEEEE);
		panel.addChild(panelBg);
		
		var textDisplay:TextDisplay = new TextDisplay(400, 200);
		textDisplay.setFormat(new InputFormat(StarlingFont.make("telstraAkkuratRg", "TelstraAkkuratRg", 100), 25, 0xFF222222));
		textDisplay.htmlText = "This is an example overlay panel";
		panel.addChild(textDisplay);
		textDisplay.x = 50;
		textDisplay.y = 50;
		
		var closeButtonView = new CloseButtonView();
		panel.addChild(closeButtonView);
		closeButtonView.x = panel.width - closeButtonView.width - 10;
		closeButtonView.y = 10;
		
		transformObject = LayoutManager.add(panel)
			.bounds( { x:0, y:0, width:640, height:360} )
			.align(0.5, 0.5)
			.anchor(0.5, 0.5);
		
		transition.add(background, { alpha:[0, 0.9] } );
		transition.add(panelContainer, { alpha:[0, 1], y:[ -200, 0] } );
		
		Resize.onResize.add(OnResize);
	}
	
	function OnResize()
	{
		background.width = stage.stageWidth;
		background.height = stage.stageHeight;
		
		transformObject.resize();
	}
	
	override public function dispose():Void
	{
		super.dispose();
	}
}