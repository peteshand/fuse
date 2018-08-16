//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package fuse.robotlegs.signalMap.impl;

import fuse.robotlegs.signalMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;
import org.swiftsuspenders.utils.DescribedType;

class SignalCommandMap implements DescribedType implements ISignalCommandMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappingProcessors:Array<Dynamic> = [];

	private var _injector:IInjector;

	private var _triggerMap:CommandTriggerMap;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		_injector = context.injector;
		_logger = context.getLogger(this);
		_triggerMap = new CommandTriggerMap(getKey, createTrigger);
		
		//context.injector.map(AppSetupCompleteSignal).asSingleton();
		//var appSetupCompleteSignal:AppSetupCompleteSignal = context.injector.getInstance(AppSetupCompleteSignal);
		//appSetupCompleteSignal.dispatch();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function map(signalClass:Class<Dynamic>):ICommandMapper
	{
		return getTrigger(signalClass).createMapper();
	}

	/**
	 * @inheritDoc
	 */
	public function unmap(signalClass:Class<Dynamic>):ICommandUnmapper
	{
		return getTrigger(signalClass).createMapper();
	}

	public function addMappingProcessor(handler:Dynamic):ISignalCommandMap
	{
		if (_mappingProcessors.indexOf(handler) == -1)
			_mappingProcessors.push(handler);
		return this;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function getTrigger(signalClass:Class<Dynamic>):SignalCommandTrigger
	{
		return cast(_triggerMap.getTrigger([signalClass]), SignalCommandTrigger);
	}

	private function getKey(signalClass:Class<Dynamic>):String
	{
		return "" + signalClass;
	}
	
	private function createTrigger(signalClass:Class<Dynamic>):ICommandTrigger
	{
		return new SignalCommandTrigger(_injector, signalClass, _mappingProcessors);
	}
}
