package mantle.services.messaging;

/**
 * ...
 * @author Pete Shand
 */
class CrossContext<T>
{
	private static var messengerObjects = new Map<String, CrossContextGroup<T>>();
	public var messenger:CrossContextGroup<T>;
	
	public function new(groupID:String) 
	{
		messenger = getMessengerObject(groupID);
	}
	
	private function getMessengerObject(groupID:String):CrossContextGroup<T>
	{
		if (messengerObjects.exists(groupID) == false) {
			var crossContextGroup = new CrossContextGroup<T>(groupID);
			messengerObjects.set(groupID, crossContextGroup);
		}
		return messengerObjects.get(groupID);
	}
}