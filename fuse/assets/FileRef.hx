package fuse.assets;

/**
 * ...
 * @author P.J.Shand
 */
class FileRef implements IRef {
	public var isDirectory:Bool = false;
	public var fileName:String;
	public var name:String;
	public var path:String;
	public var value:String;
	public var documentation:String;

	public function new(value:String, fileName:String) {
		this.fileName = fileName.split("-").join("_").split(".").join("_");
		this.value = value;

		// replace forbidden characters to underscores, since variables cannot use these symbols.
		this.name = value.split("-").join("_").split(".").join("__").split("/").join("_");

		// generate documentation
		this.documentation = "Reference to file on disk \"" + value + "\". (auto generated)";
	}
}
