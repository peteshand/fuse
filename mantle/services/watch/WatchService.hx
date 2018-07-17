package mantle.services.watch;

import mantle.services.watch.watcher.DirWatcher;
import mantle.services.watch.watcher.IWatcher;
import flash.filesystem.File;

/**
 * ...
 * @author P.J.Shand
 */
class WatchService 
{
	private static var watchers = new Map<String, IWatcher>();
	
	public function new()
	{
		
	}
	
	public static function watch(file:File, extensions:Array<String>=null):IWatcher
	{
		if (file.isDirectory) {
			var dirWatcher:DirWatcher = new DirWatcher(file, extensions);
			watchers.set(file.nativePath, dirWatcher);
			return dirWatcher;
		}
		else {
			
		}
		return null;
	}
}