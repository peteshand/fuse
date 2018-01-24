package fuse.core.assembler.batches.batch;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract BatchType(String) from String to String {
	
	public var ATLAS:String = "atlas";
	public var CACHE_BAKE:String = "cacheBake";
	public var DIRECT:String = "direct";
	//public var CACHE_DRAW:String = "cacheDraw";
}