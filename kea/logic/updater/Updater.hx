package kea.logic.updater;

/**
 * ...
 * @author P.J.Shand
 */
class Updater
{

	public function new() 
	{
		
	}
	
	public function execute() 
	{
		for (i in 0...Kea.current.logic.displayList.renderList.length) 
		{
			Kea.current.logic.displayList.renderList[i].update();
		}
	}
	
}