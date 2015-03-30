/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.input.devices.core;
import tools.spark.sliced.services.std.input.devices.interfaces.IInputDevice;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.System;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class KeyboardDevice implements IInputDevice
{
	private var _keysDown:Array<Key>;
	private var _keysUp:Array<Key>;
	
	private var _keysJustPressed:Map<Key,Bool>;
	private var _keysJustReleased:Map<Key,Bool>;
	
	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		_keysDown = new Array<Key>();
		_keysUp = new Array<Key>();
		
		_keysJustPressed = new Map<Key,Bool>();
		_keysJustReleased = new Map<Key,Bool>();
		
		System.keyboard.down.connect(_onKeyDown);
		System.keyboard.up.connect(_onKeyUp);
	}
	
	private function _onKeyDown(p_keyboardEvent:KeyboardEvent):Void
	{
		_keysDown.push(p_keyboardEvent.key);
	}
	
	private function _onKeyUp(p_keyboardEvent:KeyboardEvent):Void
	{
		_keysUp.push(p_keyboardEvent.key);
	}
	
	public function update():Void
	{
		_keysJustPressed = new Map<Key,Bool>();
		_keysJustReleased = new Map<Key,Bool>();
		
		while (_keysDown.length>0)
		{
			var w_keyDown:Key = _keysDown.pop();
			_keysJustPressed[w_keyDown] = true;
			Sliced.event.raiseEvent(EEventType.KEY_PRESSED, w_keyDown);
		}
		
		while (_keysUp.length>0)
		{
			var w_keyUp:Key = _keysUp.pop();
			_keysJustReleased[w_keyUp] = true;
			Sliced.event.raiseEvent(EEventType.KEY_RELEASED, w_keyUp);
		}
	}
	
	public function registerTrigger(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		
	}
	
	public function isKeyDown( type:Key ):Bool
	{
		return System.keyboard.isDown(type);
	}
	
	public function isKeyPressed( type:Key ):Bool
	{
		return _keysJustPressed.exists(type);
	}

	public function isKeyReleased( type:Key ):Bool
	{
		return _keysJustReleased.exists(type);
	}
}