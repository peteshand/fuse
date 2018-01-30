package fuse.robotlegs.config.logic.flags.compile;
import fuse.robotlegs.config.model.FlagsModel;

/**
 * ...
 * @author Thomas Byrne
 */
@:rtti
@:build(fuse.robotlegs.config.logic.flags.CompileDefineMacro.build())
class CompileDefineFlagsLogic
{
	@inject public var flagsModel:FlagsModel;
	
	// Build macro will populate
	private var defineKeys = new Array<String>();

	public function new() 
	{
		
	}
	
	public function init():Void
	{
		for (i in 0...defineKeys.length) 
		{
			var split:Array<String> = defineKeys[i].split(",");
			var key:String = split[0];
			var value:String = split[1];
			flagsModel.add(key, value);
		}
	}
}