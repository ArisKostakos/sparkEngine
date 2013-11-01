/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package co.gamep.sliced.services.std.input.core;

import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.System;
import co.gamep.sliced.core.Sliced;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventType;
import co.gamep.sliced.interfaces.IInput;
import co.gamep.sliced.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Input extends AService implements IInput
{
	private var _keysDown:Array<Key>;
	private var _keysUp:Array<Key>;
	
	private var _keysJustPressed:Map<Key,Bool>;
	private var _keysJustReleased:Map<Key,Bool>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Input std Service...");
		
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