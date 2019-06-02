package fuse.utils;

import fuse.texture.data.DataType;

/**
 * ...
 * @author P.J.Shand
 */
class FileType {
	public function new() {}

	static public function fileType(url:String) {
		var split:Array<String> = url.split(".");
		return split[split.length - 1];
	}

	static public function dataType(url:String) {
		var fileType:String = FileType.fileType(url);
		if (fileType == "jpg" || fileType == "jpeg" || fileType == "jpeg" || fileType == "jpeg")
			return DataType.IMAGE;
		else if (fileType == "mp4")
			return DataType.VIDEO;
		else if (fileType == "atf")
			return DataType.ATF;
		return null;
	}
}
