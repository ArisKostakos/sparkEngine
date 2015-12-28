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
	private var _keysPressed:Array<Key>;
	private var _keysReleased:Array<Key>;
	
	private var _keysDown:Map<Key,Bool>;
	
	private var _keysJustPressed:Map<Key,Bool>;
	private var _keysJustReleased:Map<Key,Bool>;
	
	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		_keysPressed = new Array<Key>();
		_keysReleased = new Array<Key>();
		
		_keysDown = new Map<Key,Bool>();
		
		_keysJustPressed = new Map<Key,Bool>();
		_keysJustReleased = new Map<Key,Bool>();
		
		System.keyboard.down.connect(_onKeyDown);
		System.keyboard.up.connect(_onKeyUp);
	}
	
	private function _onKeyDown(p_keyboardEvent:KeyboardEvent):Void
	{
		_keysPressed.push(p_keyboardEvent.key);
		
		_keysDown.set(p_keyboardEvent.key, true);
	}
	
	private function _onKeyUp(p_keyboardEvent:KeyboardEvent):Void
	{
		_keysReleased.push(p_keyboardEvent.key);
		
		_keysDown.remove(p_keyboardEvent.key);
	}
	
	public function update():Void
	{
		_keysJustPressed = new Map<Key,Bool>();
		_keysJustReleased = new Map<Key,Bool>();
		
		while (_keysPressed.length>0)
		{
			var w_keyDown:Key = _keysPressed.pop();
			_keysJustPressed[w_keyDown] = true;
			Sliced.event.raiseEvent(EEventType.KEY_PRESSED, w_keyDown);
		}
		
		while (_keysReleased.length>0)
		{
			var w_keyUp:Key = _keysReleased.pop();
			_keysJustReleased[w_keyUp] = true;
			Sliced.event.raiseEvent(EEventType.KEY_RELEASED, w_keyUp);
		}
		
		for (keyDown in _keysDown.keys())
		{
			Sliced.event.raiseEvent(EEventType.KEY_DOWN, keyDown);
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