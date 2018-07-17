package mantle.util.log.air;
import mantle.util.log.Log;
import mantle.util.log.Log.LogLevel;
import mantle.util.log.ILogHandler;
import mantle.util.log.LogFormatImpl;
import mantle.util.log.LogFormatter;
import mantle.time.GlobalTime;
//import remove.worker.WorkerSwitchboard;
import flash.Lib;
import flash.filesystem.File;
import haxe.Timer;

/**
 * ...
 * @author Thomas Byrne
 */
class HtmlFileLogger implements ILogHandler
{
	private static var MAX_LOG_SIZE:Int = 2 * 1024 * 1024; // 2 mb
	private static var WRITE_EVERY:Int = 5000; // ms
	
	private static var DIR_SIZE_LIMIT:Float = 100; // Size limit for log directory
	private static var REDUCE_DIR_EVERY:Int = 5000; // Every n logs, recheck that directory is under size limit
	
	private var targetFileDate:Int;
	private var targetFile:File;
	private var targetFileCount:Int = 0;
	//private var fileStream:FileStream;
	
	//private var workerSwitch:WorkerSwitchboard;
	
	private var logContent:String = "";
	private var newline:String = "\r\n";
	
	private var dir:String;
	private var fileExt:String;
	
	private var logArray:Array<String> = [];
	
	private var writeTimer:Timer;
	private var isWriting:Bool;
	private var logPending:Bool;
	private var doDelay:Bool;
	//private var nextWriteSync:Bool;
	
	public var formatter:LogFormatter;
	public var logCount:Int = 0;
	
	private var _nowDate:Date;
	
	public function new(dir:String, viaWorker:Bool, formatter:LogFormatter=null, fileExt:String="html"):Void
	{
		this.dir = dir;
		this.fileExt = fileExt;
		this.formatter = (formatter == null ? LogFormatImpl.htmlFormat : formatter);
		this.doDelay = viaWorker;
		
		//if (viaWorker) {
			//workerSwitch = WorkerSwitchboard.getWorker();
		//}else {
			//workerSwitch = WorkerSwitchboard.getInstance();
		//}
		
		var dirFile:File = new File(dir);
		if (!dirFile.exists) {
			dirFile.createDirectory();
		}
		findNextFile();
		
		trace("TODO: fix");
		//workerSwitch.reduceDirToSize(dir, DIR_SIZE_LIMIT);
	}
	
	private function findNextFile():Void 
	{
		var now:Date = GlobalTime.now();
		var lastFile:File = null;
		while (targetFile==null || targetFile.exists) {
			lastFile = targetFile;
			var fileName:String = toDateString(now) + (targetFileCount>0 ? "_"+pad(targetFileCount, 2) : "") + "." + fileExt;
			targetFile = new File(dir + fileName);
			targetFileDate = now.getDate();
			targetFileCount++;
		}
		if (lastFile!=null && lastFile.exists && lastFile.size < MAX_LOG_SIZE) {
			//Logger.warn(this, "Last log file is smaller than 2mb, possibly from crash");
		}
	}
	
	function toDateString(date:Date) : String 
	{
		return date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	}
	
	private function pad(num:Int, padBy:Int):String 
	{
		var str:String = Std.string(num);
		while (str.length < padBy) {
			str = "0" + str;
		}
		return str;
	}
	
	
	public function log(source:Dynamic, level:String, rest:Array<Dynamic>, time:Date):Void 
	{
		logArray.push(formatter(source, level, rest, time));
		
		if (level == LogLevel.UNCAUGHT_ERROR) {
			// always attempt to write uncaught errors immediately.
			if (!isWriting) {
				cancelWriteDelay();
				doWrite();
			}else {
				logPending = true;
				//nextWriteSync = true;
			}
		}else {
			logPending = true;
			if (writeTimer == null && !isWriting) {
				if(doDelay){
					beginWriteDelay();
				}else {
					doWrite();
				}
			}
		}
		
		logCount++;
		if (logCount >= REDUCE_DIR_EVERY){
			trace("TODO: fix");
			//workerSwitch.reduceDirToSize(dir, DIR_SIZE_LIMIT);
			logCount = 0;
		}
	}
	
	private function cancelWriteDelay():Void 
	{
		if (writeTimer == null) return;
		
		writeTimer.stop();
	}
	
	private function beginWriteDelay():Void 
	{
		writeTimer = Timer.delay(delayFinished, WRITE_EVERY);
	}
	
	private function delayFinished():Void 
	{
		writeTimer = null;
		doWrite();
	}
	
	private function doWrite():Void 
	{
		if (logArray.length == 0) return;
		
		if (targetFileDate != GlobalTime.now().getDate()){
			findNextFile();
		}
		
		isWriting = true;
		var toLog:String = logArray.join(newline);
		logArray = [];
		
		logPending = false;
		trace("TODO: fix");
		//workerSwitch.appendTextToFile(targetFile.nativePath, toLog, onWriteSuccess, onWriteFail.bind(_, toLog));
	}
	
	function onWriteFail(err:String, log:String) 
	{
		logArray.unshift(log);
		findNextFile();
		flash.Lib.trace("Failed to write to log: "+err);
		onWriteSuccess(null);
	}
	
	private function onWriteSuccess(res:Null<Dynamic>):Void 
	{
		isWriting = false;
		checkLogFile();
		if (logPending) {
			if (!doDelay) {
				doWrite();	
			}else{
				beginWriteDelay();
			}
		}
	}
	
	private function checkLogFile():Void 
	{
		if (!targetFile.exists || targetFile.size >= MAX_LOG_SIZE) {
			findNextFile();
		}
	}
}