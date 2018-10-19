package fuse.core.render;

import fuse.utils.PlayerVersion;
import msignal.Signal.Signal0;
import openfl.Lib;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class Context3DSetup
{
	public var sharedContext:Bool = false;
	public var context3D:Context3D;
	public var onComplete:Signal0 = new Signal0();
	public var activeProfile:Context3DProfile;
	
	var stage3D:Stage3D;
	var profiles:Array<Context3DProfile> = [];
	var renderMode:Context3DRenderMode;
	var targetProfile:Context3DProfile = Context3DProfile.BASELINE;
	var targetProfiles:Array<Context3DProfile>;
	
	public function new() 
	{
		#if air
			//if (PlayerVersion.majorMinor >= 25.0) profiles.push(Context3DProfile.ENHANCED);
			//if (PlayerVersion.majorMinor >= 17.0) profiles.push(Context3DProfile.STANDARD_EXTENDED);
			if (PlayerVersion.majorMinor >= 16.0) profiles.push(Context3DProfile.STANDARD);
			if (PlayerVersion.majorMinor >= 14.0) profiles.push(Context3DProfile.STANDARD_CONSTRAINED);
			if (PlayerVersion.majorMinor >= 11.8) profiles.push(Context3DProfile.BASELINE_EXTENDED);
			if (PlayerVersion.majorMinor >= 11.4) profiles.push(Context3DProfile.BASELINE);
			if (PlayerVersion.majorMinor >= 11.4) profiles.push(Context3DProfile.BASELINE_CONSTRAINED);
		#else
			profiles.push(Context3DProfile.BASELINE_EXTENDED);
			profiles.push(Context3DProfile.BASELINE);
			profiles.push(Context3DProfile.BASELINE_CONSTRAINED);
		#end
		
	}
	
	public function init(stage3D:Stage3D, renderMode:Context3DRenderMode, targetProfiles:Array<Context3DProfile>) 
	{
		this.stage3D = stage3D;
		this.renderMode = renderMode;
		
		if (targetProfiles == null) this.targetProfiles = profiles;
		else this.targetProfiles = targetProfiles;
		
		checkStage3D();
		setTargetProfile();
		createContext();
	}
	
	function checkStage3D() 
	{
		if (stage3D == null) {
			stage3D = Lib.current.stage.stage3Ds[0];
		}
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, OnContentCreated);
	}
	
	function setTargetProfile() 
	{
		if (targetProfiles != null) {
			if (targetProfiles.length == 0) {
				trace("No more available profiles");
			}
			else {
				targetProfile = targetProfiles.shift();
			}
		}
	}
	
	function createContext() 
	{
		if (stage3D.context3D == null) {
			try {
				stage3D.requestContext3D(renderMode, targetProfile);
			}
			catch (e:Error) {
				trace("Error: " + e + " " + targetProfile);
				moveToNextProfile();
			}
		}
		else {
			#if air
				sharedContext = true;
			#end
			context3D = stage3D.context3D;
			//trace("context already created, driverInfo = " + context3D.driverInfo);
			#if debug
				context3D.enableErrorChecking = true;
			#else
				context3D.enableErrorChecking = false;
			#end
			//trace("driverInfo = " + context3D.driverInfo);
			activeProfile = targetProfile;
			onComplete.dispatch();
			
		}

		
	}
	
	private function OnContentCreated(e:Event):Void 
	{
		context3D = stage3D.context3D;
		#if debug
			context3D.enableErrorChecking = false; // true;
		#else
			context3D.enableErrorChecking = false;
		#end
		//trace("context3D.enableErrorChecking = " + context3D.enableErrorChecking);

		if (renderMode == Context3DRenderMode.AUTO && context3D.driverInfo != null && context3D.driverInfo.indexOf("Software") != -1) {
			moveToNextProfile();
		}
		else {
			trace("driverInfo = " + context3D.driverInfo);
			activeProfile = targetProfile;
			onComplete.dispatch();
		}
	}
	
	function moveToNextProfile() 
	{
		setTargetProfile();
		createContext();
	}
}