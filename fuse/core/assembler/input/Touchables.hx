package fuse.core.assembler.input;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.core.communication.messageData.TouchableMsg;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class Touchables
{
	public static var touchables = new Array<CoreDisplayObject>();
	public static var flattened = new Array<CoreDisplayObject>();
	public static var touchablesMap = new Map<Int, CoreDisplayObject>();
	public static var stage:CoreDisplayObject;
	public static var requireRebuild:Bool = false;

	public function new() { }
	
	static public function setTouchable(payload:TouchableMsg) 
	{
		var coreDisplay:CoreDisplayObject = Core.displayList.getDisplay(payload.objectId, payload.displayType);
		coreDisplay.touchable = payload.touchable;
		
		if (coreDisplay.displayType == DisplayType.STAGE) {
			if (payload.touchable == true) stage = coreDisplay;
			else stage = null;
			return;
		}

		requireRebuild = true;

		if (payload.touchable == true) {
			if (!touchablesMap.exists(payload.objectId)) {
				touchablesMap.set(payload.objectId, coreDisplay);
				touchables.push(coreDisplay);		
			}
		}
		else {
			if (touchablesMap.exists(payload.objectId)) {
				touchablesMap.remove(payload.objectId);
				var i:Int = touchables.length - 1;
				while (i >= 0) 
				{
					if (touchables[i].objectId == payload.objectId) {
						touchables.splice(i, 1);
					}
					i--;
				}
			}
		}
	}
}