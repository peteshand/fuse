package mantle.util.log;
import mantle.util.app.App;
import robotlegs.bender.framework.api.LogLevel;

/**
 * ...
 * @author Thomas Byrne
 */
class MassErrorQuitLogger implements ILogHandler
{
	var maxCount:Int;
	var inTimeframe:Int;
	
	var timesHit:Array<Float> = [];
	var restartRequested:Bool;

	public function new(maxCount:Int = 120, inTimeframe:Int = 60000) 
	{
		this.maxCount = maxCount;
		this.inTimeframe = inTimeframe;
	}
	
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void 
	{
		if (restartRequested) return;
		
		var ts = time.getTime();
		var cutoff = ts - inTimeframe;
		while (timesHit[0] < cutoff){
			timesHit.shift();
		}
		
		timesHit.push(ts);
		
		if (timesHit.length >= maxCount){
			App.exit(1);
			restartRequested = true;
		}
		
	}
	
}