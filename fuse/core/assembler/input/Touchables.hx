package fuse.core.assembler.input;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class Touchables
{
	public static var touchables = new Array<CoreImage>();
	public static var touchablesMap = new Map<Int, CoreImage>();
	
	public function new() { }
	
	static public function setTouchable(objectId:Int, touchable:Bool) 
	{
		var coreDisplay:CoreImage = untyped Core.displayList.map.get(objectId);
		if (touchable) {
			if (!touchablesMap.exists(objectId)) {
				touchablesMap.set(objectId, coreDisplay);
				touchables.push(coreDisplay);
			}
		}
		else {
			if (touchablesMap.exists(objectId)) {
				touchablesMap.remove(objectId);
				var i:Int = touchables.length - 1;
				while (i >= 0) 
				{
					if (touchables[i].objectId == objectId) {
						touchables.splice(i, 1);
					}
					i--;
				}
				touchables.push(coreDisplay);
			}
		}
	}
}