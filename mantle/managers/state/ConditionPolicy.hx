package mantle.managers.state;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract ConditionPolicy(Int) from Int to Int from UInt to UInt {
	
	public var AND = 0;
	public var OR = 1;
	public var SCENE = 2;
}