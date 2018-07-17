package mantle.util.ds;
import mantle.util.ds.ArraySortAsync.SortPart;
import remove.util.time.EnterFrame;

/**
 * ...
 * @author Thomas Byrne
 */
class ArraySortAsync<ArrayType>
{
	private static var rangePool:Array<SortPart>;
	
	
	public var array:Array<ArrayType>;
	public var sortFunc:ArrayType->ArrayType->Int;
	public var onComplete:Void->Void;
	
	public var speed:Float = 1;
	
	@:isVar public var isStarted(get, null):Bool;
	private function get_isStarted():Bool {
		return isStarted;
	}
	
	@:isVar public var isDone(get, null):Bool;
	private function get_isDone():Bool {
		return isDone;
	}
	
	@:isVar public var result(get, null):Array<ArrayType>;
	private function get_result():Array<ArrayType> {
		return result;
	}
	
	private var frameAlloc:Float;
	
	private var ranges:Array<SortPart>;
	
	private var currRange:SortPart;
	private var currPivotInd:Int;
	private var currPivot:ArrayType;
	private var currInd:Int;
	private var currSkipL:Int;
	private var currSkipR:Int;
	private var currSkipped:Bool;
	private var checkMap:Map<String, Bool>;

	public function new(?array:Array<ArrayType>, ?sortFunc:ArrayType->ArrayType->Int, ?onComplete:Void->Void, autoStart:Bool=true) 
	{
		if (rangePool == null) rangePool = [];
		this.array = array;
		this.sortFunc = sortFunc;
		this.onComplete = onComplete;
		
		if (array != null && sortFunc != null && onComplete != null && autoStart) {
			start();
		}
	}
	
	public function start() 
	{
		isDone = false;
		EnterFrame.add(onFrame);
		frameAlloc = (1000 / EnterFrame.getFPS()) * speed;
	}
	
	function onFrame() 
	{
		var endTime:Float = EnterFrame.getTimer() + frameAlloc;
		do {
			
			process();
			
		}while (!isDone && EnterFrame.getTimer() < endTime);
		
		if (isDone) {
			EnterFrame.remove(onFrame);
		}
	}
	
	public function process() 
	{
		if (!isStarted) {
			checkMap = new Map();
			isStarted = true;
			result = array.concat([]);
			if (array.length < 2) {
				isDone = true;
			}else{
				ranges = [ createRange(0, array.length - 1) ];
				isDone = false;
			}
			return;
		}
		
		if(currRange==null){
			currRange = ranges.shift();
			currInd = currRange.startInd;
			currSkipL = 0;
			currSkipR = 0;
			currSkipped = false;
			currPivotInd = Math.floor(currRange.startInd + (currRange.endInd - currRange.startInd) / 2);
			currPivot = result[currPivotInd];
		}
		
		var isLeft:Bool = (currInd < currPivotInd);
		var comp:ArrayType = result[currInd];
		var shouldBeLeft:Bool = (sortFunc(comp, currPivot) == -1);
		var shouldIterate:Bool = true;
		if (isLeft != shouldBeLeft) {
			if (isLeft) {
				result.splice(currInd, 1);
				result.insert(currPivotInd, comp);
				--currPivotInd;
				currSkipR++;
				shouldIterate = false;
			}else {
				result.splice(currInd, 1);
				result.insert(currPivotInd-1, comp);
				++currPivotInd;
				currSkipL++;
			}
		}
		if (currPivotInd < currRange.startInd) {
			currPivotInd;
		}else if (currPivotInd > currRange.endInd) {
			currPivotInd;
		}
		
		if (currInd >= currRange.endInd) {
			if (currPivotInd - currRange.startInd > 2) {
				ranges.push( createRange(currRange.startInd, currPivotInd - 1) );
			}
			if (currRange.endInd - currPivotInd > 2) {
				ranges.push( createRange(currPivotInd + 1, currRange.endInd ) );
			}
			poolRange(currRange);
			currRange = null;
			
			if (ranges.length==0) {
				isDone = true;
				if (onComplete != null) onComplete();
			}
			
		}else if (!currSkipped && currInd >= currPivotInd - 1 - currSkipL) {
			currSkipped = true;
			currInd += 2 + currSkipR;
		}else {
			currInd++;
		}
		
	}
	
	function createRange(start:Int, end:Int):SortPart
	{
		if (checkMap.exists(start + "-" + end)) {
			checkMap;
		}
		checkMap.set(start + "-" + end, true);
		if (rangePool.length > 0) {
			var ret:SortPart = rangePool.pop();
			ret.startInd = start;
			ret.endInd = end;
			return ret;
		}else {
			return { startInd:start, endInd:end };
		}
	}
	
	function poolRange(range:SortPart) 
	{
		rangePool.push(range);
	}
	
}

typedef SortPart = {
	startInd:Int,
	endInd:Int
}