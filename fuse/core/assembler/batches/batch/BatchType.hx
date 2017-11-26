package fuse.core.assembler.batches.batch;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract BatchType(String) from String to String {
	
	public var ATLAS:String = "atlas";
	public var LAYER_CACHE:String = "layerCache";
	public var DIRECT:String = "direct";
}