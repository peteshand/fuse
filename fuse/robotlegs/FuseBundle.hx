package fuse.robotlegs;

import fuse.robotlegs.config.ConfigExtension;
import fuse.robotlegs.scene.SceneExtension;
import fuse.robotlegs.signalMap.SignalCommandMapExtension;
import fuse.robotlegs.window.AppWindowExtension;
import robotlegs.bender.extensions.display.stage3D.Stage3DStackExtension;
import robotlegs.bender.extensions.display.stage3D.fuse.FuseIntegrationExtension;
import robotlegs.bender.extensions.display.stage3D.fuse.FuseStageSyncExtension;
import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

/**
 * ...
 * @author P.J.Shand
 */
class FuseBundle implements IBundle
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install([
			SignalCommandMapExtension, 
			ManualStageObserverExtension, 
			Stage3DStackExtension,
			
			FuseIntegrationExtension,
			FuseStageSyncExtension,
			ConfigExtension,
			SceneExtension,
			AppWindowExtension
			
		]);
	}
}