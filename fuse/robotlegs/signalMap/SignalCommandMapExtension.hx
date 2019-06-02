//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package fuse.robotlegs.signalMap;

import fuse.robotlegs.signalMap.api.ISignalCommandMap;
import fuse.robotlegs.signalMap.impl.SignalCommandMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.UID;

@:keepSub
class SignalCommandMapExtension implements IExtension {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	// private var _uid:String;
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	public function new() {}

	public function extend(context:IContext):Void {
		// _uid = UID.create(SignalCommandMapExtension);
		context.injector.map(ISignalCommandMap).toSingleton(SignalCommandMap);
	}

	// public function toString():String
	// {
	// return _uid;
	// }
}
