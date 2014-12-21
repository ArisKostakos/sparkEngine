/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.input.devices.core;
import flambe.input.PointerEvent;
import haxe.ds.ObjectMap;
import tools.spark.sliced.services.std.input.devices.interfaces.IInputDevice;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import flambe.System;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class PointerDevice implements IInputDevice
{
	private var _registeredTriggers:Map< EEventType, Map < IGameEntity, IGameEntity > >; //PointerEvent, Filter, SameFilterAgain
	
	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		//System.pointer.move.connect(_onMove);
		_registeredTriggers = new Map < EEventType, Map < IGameEntity, IGameEntity > > ();
	}
	
	public function update():Void
	{
		
	}
	
	private function _setTrigger(p_eventType:EEventType, p_eventFilter:IGameEntity):Void
	{
		if (_registeredTriggers[p_eventType] == null) _registeredTriggers[p_eventType] = new Map<IGameEntity, IGameEntity>();
		
		_registeredTriggers[p_eventType][p_eventFilter] = p_eventFilter;
	}
	
	private function _getTrigger(p_eventType: EEventType, p_eventFilter:IGameEntity):IGameEntity
	{
		if (_registeredTriggers[p_eventType] == null) return null;
		
		return _registeredTriggers[p_eventType][p_eventFilter];
	}
	
	public function registerTrigger(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		_setTrigger(p_eventType,p_eventFilter);
	}
	
	public function submitPointerEvent(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		if (_getTrigger(p_eventType, p_eventFilter) != null)
			Sliced.event.raiseEvent(p_eventType, p_eventFilter);
	}
	
	private function _onMove(p:PointerEvent):Void
	{
		//Console.error("PointerMove");
	}
}