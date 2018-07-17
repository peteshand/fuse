package mantle.services.watch.watcher;

import mantle.util.fs.File;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

/**
 * ...
 * @author P.J.Shand
 */
class DirWatcher implements IWatcher
{
	private var timer:Timer;
	public var onFileChanged = new Signal1<File>();
	public var onFileRemoved = new Signal1<File>();
	public var onFileAdded = new Signal1<File>();
	
	private var fileLookup:FileLookup;
	var file:File;
	var extensions:Array<String>;
	var recursive:Bool;
	
	public function new(file:File, extensions:Array<String>=null, frequency:Int=1000, recursive:Bool=false) 
	{
		this.file = file;
		this.extensions = extensions;
		this.recursive = recursive;
		
		timer = new Timer(frequency, 1);
		timer.addEventListener(TimerEvent.TIMER, OnTick);
		
	}
	
	function onNewFile(file:File) 
	{
		onFileAdded.dispatch(file);
	}
	
	function onFileChange(file:File) 
	{
		onFileChanged.dispatch(file);
	}
	
	function onRemoveFile(file:File) 
	{
		onFileRemoved.dispatch(file);
	}
	
	public function start():Void
	{
		if (fileLookup == null) {
			fileLookup = new FileLookup();
			fileLookup.onNewFile.add(onNewFile);
			fileLookup.onFileChange.add(onFileChange);
			fileLookup.onRemoveFile.add(onRemoveFile);
			fileLookup.init(file, extensions, recursive, onInitComplete);
		}else{
			onInitComplete();
		}
	}
	
	function onInitComplete() 
	{
		timer.start();
		OnTick(null);
	}
	
	public function stop():Void
	{
		timer.stop();
	}
	
	private function OnTick(e:TimerEvent):Void 
	{
		fileLookup.checkForChange();
	}
	
	function onCheckComplete() 
	{
		timer.start();
	}
}