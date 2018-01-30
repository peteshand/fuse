//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package fuse.robotlegs.signalMap.impl;

import fuse.signal.BaseSignal;
import fuse.signal.Signal0;
import fuse.signal.Signal1;
import fuse.signal.Signal2;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
@:keepSub
class SignalCommandTrigger implements ICommandTrigger
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _signalClass:Class<Dynamic>;

	private var _signal:BaseSignal<Dynamic>;

	private var _injector:IInjector;

	private var _mappings:CommandMappingList;

	private var _executor:ICommandExecutor;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(injector:IInjector, signalClass:Class<Dynamic>, processors:Array<Dynamic> = null, logger:ILogger = null)
	{
		_injector = injector;

		_signalClass = signalClass;
		_mappings = new CommandMappingList(this, processors, logger);
		_executor = new CommandExecutor(injector, _mappings.removeMapping);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function createMapper():CommandMapper
	{
		return new CommandMapper(_mappings);
	}

	/**
	 * @inheritDoc
	 */
	public function activate():Void
	{
		if (!_injector.hasMapping(_signalClass))
			_injector.map(_signalClass).asSingleton();
		_signal = _injector.getInstance(_signalClass);
		if (Std.is(_signal, Signal0)) {
			_signal.add(function() {
				routePayloadToCommands([]);
			});
		}
		else if (Std.is(_signal, Signal1)) {
			var signal1:Signal1<Dynamic> = cast _signal;
			signal1.add(function(arg1:Dynamic) {
				Reflect.makeVarArgs(routePayloadToCommands)(arg1);
			});
		}
		else if (Std.is(_signal, Signal2)) {
			var signal2:Signal2<Dynamic, Dynamic> = cast _signal;
			signal2.add(function(arg1:Dynamic, arg2:Dynamic):Void {
				Reflect.makeVarArgs(routePayloadToCommands)(arg1, arg2);
			});
		}
	}

	/**
	 * @inheritDoc
	 */
	public function deactivate():Void
	{
		// FIX
		//if (_signal != null)
		//	_signal.remove(routePayloadToCommands);
	}

	public function toString():String
	{
		return Type.getClassName(_signalClass);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function routePayloadToCommands(valueObjects:Array<Dynamic>):Void
	{
		//var payload:CommandPayload = new CommandPayload(valueObjects, _signal.valueClasses);
		var payload:CommandPayload = new CommandPayload(valueObjects);
		_executor.executeCommands(_mappings.getList(), payload);
	}
}