package fuse.robotlegs;

import fuse.robotlegs.signalMap.SignalCommandMapExtension;
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
class FuseBundle implements IBundle {
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	public function new() {}

	/** @inheritDoc **/
	public function extend(context:IContext):Void {
		context.install(SignalCommandMapExtension);
		context.install(ManualStageObserverExtension);
		context.install(Stage3DStackExtension);
		context.install(FuseIntegrationExtension);
		context.install(FuseStageSyncExtension);

		/*context.install(ConfigExtension);*/
		/*context.install(SceneExtension);*/
		/*context.install(AppWindowExtension);*/
	}
}
