/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.input.devices.core;
import flambe.input.MouseButton;
import flambe.input.MouseEvent;
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
@:keep class MouseDevice implements IInputDevice
{
	//private var _registeredTriggers:Map< EEventType, Map < IGameEntity, IGameEntity > >; //PointerEvent, Filter, SameFilterAgain
	
	public var scroll( get_scroll, null ):Float;
	
	//This is cause in haxeScript I can't call setter/getter functions:(
	public function getScroll():Float
	{
		return scroll;
	}
	
	private var _oldScroll:Float;
	private var _scrollTriggered:Bool;
	private var _mouseLeftDown:Bool;
	private var _mouseRightDown:Bool;
	
	public var lastMouseButton:MouseButton;
	
	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		System.mouse.scroll.connect(_onScroll);
		System.mouse.down.connect(_onMouseButtonDown);
		_oldScroll = 0;
		_scrollTriggered = false;
		_mouseLeftDown = false;
		_mouseRightDown = false;
	}
	
	public function update():Void
	{
		if (_scrollTriggered)
		{
			Sliced.event.raiseEvent(EEventType.MOUSE_SCROLL);
			_scrollTriggered = false;
		}
		else
		{
			_oldScroll = 0;
		}
		
		if (_mouseLeftDown)
		{
			Sliced.event.raiseEvent(EEventType.MOUSE_LEFT_DOWN);
			_mouseLeftDown = false;
		}
		
		if (_mouseRightDown)
		{
			Sliced.event.raiseEvent(EEventType.MOUSE_RIGHT_DOWN);
			_mouseRightDown = false;
		}
	}
	
	private function get_scroll():Float
	{
		return _oldScroll;
	}
	
	private function _onScroll(p_scrollValue:Float):Void
	{
		_scrollTriggered = true;
		_oldScroll = p_scrollValue;
	}
	
	private function _onMouseButtonDown(p_mouseEvent:MouseEvent):Void
	{
		if (p_mouseEvent.button == MouseButton.Left)
			_mouseLeftDown = true;
		else if (p_mouseEvent.button == MouseButton.Right)
			_mouseRightDown = true;
		//else if Middle..
		
		lastMouseButton = p_mouseEvent.button;
	}
	
	public function registerTrigger(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		
	}
	
	public function isDown(p_button :MouseButton) :Bool
	{
		return System.mouse.isDown(p_button);
	}
}