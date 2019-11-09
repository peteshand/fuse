package fuse.core.front;

import fuse.core.front.FuseConfig;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.input.Input;
import fuse.display.Sprite;
import fuse.display.DisplayObject;
import fuse.display.Stage;
import fuse.events.FuseEvent;
import fuse.loader.RemoteLoader;
import fuse.core.render.Context3DSetup;
import fuse.core.render.Renderer;
import openfl.display.Stage3D;
import openfl.events.Event;
import openfl.Lib;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class MainThread extends ThreadBase {
	static var count:Int = 0;

	var index:Int;
	var rootClass:Class<Sprite>;
	var fuseConfig:FuseConfig;
	var stage3D:Stage3D;
	var renderMode:Context3DRenderMode;
	var profile:Dynamic;
	var context3DSetup:Context3DSetup;
	var setupComplete:Bool = false;
	var fuse:Fuse;

	var updateAvailable(get, null):Bool;

	public function new(fuse:Fuse, rootClass:Class<Sprite>, fuseConfig:FuseConfig, stage3D:Stage3D = null, renderMode:Context3DRenderMode = AUTO,
			profile:Array<Context3DProfile> = null) {
		super();
		this.fuse = fuse;

		Fuse.current = this;
		index = count++;

		this.rootClass = rootClass;
		if (fuseConfig == null)
			fuseConfig = {};
		this.fuseConfig = fuseConfig;
		this.stage3D = stage3D;
		this.renderMode = renderMode;
		this.profile = profile;

		// this.frameRate = fuseConfig.frameRate;
	}

	public function init():Void {
		// Lib.current.stopAllMovieClips();

		workerSetup = new FrontWorkerSetup();
		workerSetup.onReady.add(OnWorkerReady);
		workerSetup.init();
	}

	function OnWorkerReady() {
		context3DSetup = new Context3DSetup();
		context3DSetup.onComplete.add(OnContextCreated);
		context3DSetup.init(stage3D, renderMode, profile);

		var input:Input = new Input();
	}

	function OnContextCreated() {
		renderer = new Renderer(context3DSetup.context3D, context3DSetup.sharedContext);
		AtlasBuffers.init(Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE);
		LayerCacheBuffers.init(Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE);
		setupComplete = true;

		this.stage = fuse.stage = new Stage();
		root = Type.createInstance(rootClass, []);

		this.stage.configure(fuseConfig);
		if (fuseConfig.color != null)
			stage.color = fuseConfig.color;
		// if (fuseConfig.transparent != null) stage.transparent = fuseConfig.transparent;
		stage.addChild(root);
		renderer.resize();

		dispatchEvent(new Event(FuseEvent.ROOT_CREATED));
	}

	public function start():Void {
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
	}

	public function stop():Void {
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
	}

	private function Update(e:Event):Void {
		if (updateAvailable) {
			renderer.begin(true, stage.color);
		}
		process();
		if (updateAvailable) {
			renderer.end();
		}
	}

	public function process():Void {
		// trace("process start");
		if (!setupComplete)
			return;

		Fuse.current.conductorData.frontStaticCount++;
		workerSetup.sendQue();

		workerSetup.lock();
		workerSetup.update();
		if (Fuse.current.cleanContext) {
			conductorData.backIsStatic = 0;
		}

		// trace("conductorData.frontIsStatic = " + conductorData.frontIsStatic);
		// trace("conductorData.backIsStatic = " + conductorData.backIsStatic);

		if (updateAvailable) {
			if (renderer != null) {
				renderer.update();
			}
		}

		Fuse.current.enterFrame.dispatch();

		workerSetup.unlock();
	}

	function get_updateAvailable():Bool {
		if (Fuse.skipUnchangedFrames) {
			if (Fuse.current.conductorData.changeAvailable == 1) {
				return true;
			}
		} else {
			return true;
		}
		return false;
	}
}
