package fuse.utils;

#if electron
import electron.renderer.Remote;
#end
/**
 * ...
 * @author P.J.Shand
 */
class Exit
{
	public static function execute(exitCode:Int = 0){
		#if electron
		Remote.getCurrentWindow().close();
		#else
		throw "Error: need to implement";
		#end
	}
}