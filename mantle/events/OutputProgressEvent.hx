package mantle.events;

#if !flash
import openfl.events.Event;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class OutputProgressEvent extends Event {
	public static inline var OUTPUT_PROGRESS = "outputProgress";

	public var bytesPending:Float;
	public var bytesTotal:Float;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesPending:Float = 0, bytesTotal:Float = 0) {
		super(type, bubbles, cancelable);

		this.bytesPending = bytesPending;
		this.bytesTotal = bytesTotal;
	}

	public override function clone():Event {
		var event = new OutputProgressEvent(type, bubbles, cancelable, bytesPending, bytesTotal);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String {
		return __formatToString("OutputProgressEvent", ["type", "bubbles", "cancelable", "bytesPending", "bytesTotal"]);
	}
}
#else
typedef OutputProgressEvent = flash.events.OutputProgressEvent;
#end
