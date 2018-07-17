package robotlegs.extensions.impl.commands.replay;

#if (air && !mobile)
import mantle.managers.replay.FrameActions;
import mantle.managers.replay.InstantReplay;
import mantle.managers.replay.InstantReplayObject;
import mantle.managers.replay.MouseEventData;
import mantle.time.EnterFrame;
import mantle.util.app.App;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import openfl.ui.Keyboard;
import robotlegs.bender.bundles.mvcs.Command;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.services.keyboard.IKeyboardMap;

/**
 * ...
 * @author P.J.Shand
 */
class ReplayCommand extends Command 
{
	@inject public var contextView:ContextView;
	@inject public var keyboardMap:IKeyboardMap;
	
	public function new() { }
	
	override public function execute():Void
	{
		#if debug
			keyboardMap.map(Record, Keyboard.R, { shift:true } );
			keyboardMap.map(Stop, Keyboard.S, { shift:true } );
			keyboardMap.map(Play, Keyboard.P, { shift:true } );
		#end
		
		untyped __global__["flash.net.registerClassAlias"]("com.imagination.core.mmantle.core.managers.replay.InstantReplayObject);
		untyped __global__["flash.net.registerClassAlias"]("com.imaginationmantle.core.managers.replay.FrameActions);
		untyped __global__["flash.net.registerClassAlias"]("com.imagination.cmantle.core.managers.replay.MouseEventData);
		
		InstantReplay.register(contextView.view.stage);
		var file:File = File.documentsDirectory.resolvePath("imagination/" + App.getAppId() + "/replay/data.rpy");
		if (file.exists) {
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			InstantReplay.data = fileStream.readObject();
			fileStream.close();
		}
	}
	
	private function Record():Void
	{
		InstantReplay.currentFrame = 0;
		InstantReplay.record = true;
	}
	
	private function Stop():Void
	{
		InstantReplay.record = false;
		InstantReplay.stop();
		var file:File = File.documentsDirectory.resolvePath("imagination/" + App.getAppId() + "/replay/data.rpy");
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeObject(InstantReplay.data);
		fileStream.close();
	}
	
	private function Play():Void
	{
		InstantReplay.record = false;
		InstantReplay.currentFrame = 0;
		InstantReplay.play();
	}
}
#end