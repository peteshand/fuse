package mantle.util.log.air;
import mantle.util.fs.FileTools;
import mantle.util.fs.Files;
import flash.filesystem.File;
import haxe.crypto.Md5;
import mantle.util.log.ILogHandler;
import mantle.util.log.LogFormatImpl;
//import remove.worker.WorkerSwitchboard;

using Logger;

/**
 * ...
 * @author Thomas Byrne
 */
class SimpleJsonLogger implements ILogHandler
{
	//private var workerSwitch:WorkerSwitchboard;
	
	private var dir:String;
	private var fileExt:String;
	private var writing:Map<String, Array<PendingWrite>> = new Map();
	
	//private var lastFileInd:Int = 0;
	
	public function new(dir:String, viaWorker:Bool, fileExt:String="json"):Void
	{
		this.dir = dir;
		this.fileExt = fileExt;
		
		//if (viaWorker) {
			//workerSwitch = WorkerSwitchboard.getWorker();
		//}else {
			//workerSwitch = WorkerSwitchboard.getInstance();
		//}
		
		var dirFile:File = new File(dir);
		if (dirFile.exists && !dirFile.isDirectory){
			dirFile.deleteFile();
		}else if (!dirFile.exists) {
			dirFile.createDirectory();
		}else{
			var list:Array<File> = dirFile.getDirectoryListing();
			for (file in list){
				var path = file.nativePath;
				var nameInd = path.lastIndexOf(Files.slash());
				var name = path.substr(nameInd + 1);
				var dotInd:Int = path.lastIndexOf(".");
				name = name.substr(0, dotInd);
				var ind:Int = Std.parseInt(name);
				/*if (lastFileInd < ind){
					lastFileInd = ind;
				}*/
			}
		}
	}
	
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void 
	{
		var timezoneOffset:Float = 0;
		#if (flash || js)
			timezoneOffset = untyped time.getTimezoneOffset();
		#end
		
		var msg = rest.join("\n\n");
		var hash = Md5.encode(msg);
		msg = jsonEscape(msg);
		var ts = time.getTime();
		msg = '{\n\t"source":"' + LogFormatImpl.getType(source) + '",\n\t"level":"' + level + '",\n\t"msg":"' + msg +  '",\n\t"timezoneOffset":' + timezoneOffset + '\n}';
		
		var writeList = writing.get(hash);
		if (writeList != null){
			writeList.push({msg:msg, time:ts});
		}else{
			writing.set(hash, []);
			attemptWrite(msg, hash, [ts]);
		}
	}
	
	function attemptWrite(msg:String, hash:String, times:Array<Float>) 
	{
		var path = dir + "/" + hash + "." + fileExt;
		var timesStr:String = "";
		for (time in times){
			timesStr += "<" + time + ">";
		}
		
		trace("TODO: fix");
		//if (FileTools.exists(path)){
			//workerSwitch.appendTextToFile(path, timesStr, onComplete.bind(_, hash), onError.bind(_, msg, hash, times));
		//}else{
			//var write = msg + timesStr;
			//workerSwitch.writeTextToFile(path, write, onComplete.bind(_, hash), onError.bind(_, msg, hash, times));
		//}
	}
	
	function onError(err:String, msg:String, hash:String, times:Array<Float>) 
	{
		attemptWrite(msg, hash, times);
	}
	
	function onComplete(success:Dynamic, hash:String) 
	{
		var writeList = writing.get(hash);
		if (writeList == null) return;
		
		writing.remove(hash);
		if (writeList.length > 0){
			var path = dir + "/" + hash + "." + fileExt;
			var times:Array<Float> = [];
			var msg = writeList[0].msg;
			for (pending in writeList){
				times.push(pending.time);
			}
			attemptWrite(msg, hash, times);
		}
	}
	
	function jsonEscape(str  :String) : String  {
		str = str.split("\\").join("\\\\");
		str = str.split("\n").join("\\n");
		str = str.split("\r").join("\\r");
		str = str.split("\t").join("\\t");
		str = str.split('"').join('\\"');
		return str;
	}
}

typedef PendingWrite =
{
	msg:String, time:Float
}