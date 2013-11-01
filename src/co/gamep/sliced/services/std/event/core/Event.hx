/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package co.gamep.sliced.services.std.event.core;

import awe6.interfaces.EKey;
import flambe.input.Key;
import haxe.ds.ObjectMap;
import co.gamep.sliced.interfaces.IEvent;
import co.gamep.sliced.core.AService;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameTrigger;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class Event extends AService implements IEvent
{
	private var _eventTypeFilterFlags:Map < EEventType, ObjectMap < Dynamic, Bool >> ;
	private var _eventTypeFilterTriggers:Map < EEventType, ObjectMap < Dynamic, Array<IGameTrigger> >> ;
	
	//@note: There are dumb objects that will serve as keys to the filter arrays above. I just needed something to give a unique pointer
		//Btw, a String would not work since in JavaScript a string is apparently a primitive, not an object. So Empty arrays should do the trick
	private var _NO_FILTER:Array<Dynamic>;
	private var _FILTER_VARIABLE_USER_ENTITY:Array<Dynamic>;
	
	private var _prefabConvertToType:Map<EEventPrefab,EEventType>;
	private var _prefabConvertToFilter:Map<EEventPrefab,Dynamic>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Event std Service...");
		
		_NO_FILTER = new Array<Dynamic>();
		_FILTER_VARIABLE_USER_ENTITY = new Array<Dynamic>();
		
		_eventTypeFilterFlags = new Map < EEventType, ObjectMap < Dynamic, Bool >> ();
		_eventTypeFilterTriggers = new Map < EEventType, ObjectMap < Dynamic, Array<IGameTrigger> >> ();
		
		_initPrefabConvertToTypeMap();
		_initPrefabConvertToFilterMap();
	}
	
	
	public function addTrigger(p_gameTrigger:IGameTrigger):Void
	{
		var l_eventType:EEventType = _prefabConvertToType[p_gameTrigger.eventPrefab];
		var l_eventFilter:Dynamic = _prefabConvertToFilter[p_gameTrigger.eventPrefab];
		
		//Replace Filter with an appropriate variable if needed
		if (l_eventFilter == _FILTER_VARIABLE_USER_ENTITY)
		{
			l_eventFilter = p_gameTrigger.userEntity;
		}
		
		//Add additional filter variable changes here
		//...
		
		//Create a slot for the eventType included in the trigger's prefab
		if (_eventTypeFilterTriggers.exists(l_eventType) == false)
			_eventTypeFilterTriggers.set(l_eventType, new ObjectMap < Dynamic, Array<IGameTrigger> > () );
		
		//Create a slot for the eventFilter included in the trigger's prefab
		if (_eventTypeFilterTriggers[l_eventType].exists(l_eventFilter) == false)
			_eventTypeFilterTriggers[l_eventType].set(l_eventFilter, new Array<IGameTrigger>() );
		
		//Push the trigger to the correct slot
		_eventTypeFilterTriggers.get(l_eventType).get(l_eventFilter).push(p_gameTrigger);
	}
	
	public function raiseEvent(p_eventType:EEventType, ?p_eventFilter:Dynamic):Void
	{
		if (p_eventFilter == null)
			p_eventFilter = _NO_FILTER;
			
		//Create a slot for the raised eventType
		if (_eventTypeFilterFlags.exists(p_eventType) == false)
			_eventTypeFilterFlags[p_eventType] = new ObjectMap < Dynamic, Bool > ();
			
		_eventTypeFilterFlags[p_eventType].set(p_eventFilter, true);
		
		if (p_eventFilter != _NO_FILTER)
			_eventTypeFilterFlags[p_eventType].set(_NO_FILTER, true);
	}
	
	inline private function _doTriggers(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		//Console.info("Activating triggers for: " + p_eventType);
		
		if (_eventTypeFilterTriggers.exists(p_eventType))
		{
			if (_eventTypeFilterTriggers[p_eventType].exists(p_eventFilter))
			{
				//Console.warn("Triggers exist");
				for (gameTrigger in _eventTypeFilterTriggers[p_eventType].get(p_eventFilter))
				{
					gameTrigger.doPass();
				}
			}
			else
			{
				//Console.warn("Triggers map don't exist in this event's filter");
			}
		}
		else
		{
			//Console.warn("Triggers map don't exist in this event");
		}
	}
	
	public function update():Void
	{
		for (flag in _eventTypeFilterFlags.keys())
		{
			if (_eventTypeFilterFlags[flag].get(_NO_FILTER) == true)
			{
				for (filterFlag in _eventTypeFilterFlags[flag].keys())
				{
					if (_eventTypeFilterFlags[flag].get(filterFlag) == true)
					{
						_eventTypeFilterFlags[flag].set(filterFlag, false);
						_doTriggers(flag, filterFlag);
					}
				}
			}
		}
	}
	
	///////////////////////////
	
	private function _initPrefabConvertToTypeMap():Void
	{
		_prefabConvertToType = new Map<EEventPrefab,EEventType>();
		
		_prefabConvertToType[EEventPrefab.CREATED] = EEventType.CREATED;
		_prefabConvertToType[EEventPrefab.UPDATE] = EEventType.UPDATE;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICK] = EEventType.MOUSE_LEFT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICK] = EEventType.MOUSE_RIGHT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICKED] = EEventType.MOUSE_LEFT_CLICKED;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICKED] = EEventType.MOUSE_RIGHT_CLICKED;
		_prefabConvertToType[EEventPrefab.MOUSE_OVER] = EEventType.MOUSE_OVER;
		_prefabConvertToType[EEventPrefab.MOUSE_OUT] = EEventType.MOUSE_OUT;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUM_LOCK] = EEventType.KEY_PRESSED; 
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_CLEAR] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_HELP] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ALT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKSPACE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_CAPS_LOCK] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_CONTROL] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_DELETE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_DOWN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_END] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ENTER] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ESCAPE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F10] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F11] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F12] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F13] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F14] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F15] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_HOME] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_INSERT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_LEFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_0] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_ADD] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_ENTER] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PAGE_DOWN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PAGE_UP] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_RIGHT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SHIFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SPACE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_TAB] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_UP] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_A] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_B] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_C] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_D] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_E] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_G] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_H] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_I] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_J] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_K] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_L] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_M] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_N] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_O] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_P] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Q] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_R] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_S] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_T] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_U] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_V] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_W] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_X] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Y] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Z] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_0] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_COLON] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_EQUALS] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_HYPHEN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_TILDE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SQUARELEFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SQUARERIGHT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKSLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_APOSTROPHE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_TOPLEFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUM_LOCK] = EEventType.KEY_RELEASED; 
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_CLEAR] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_HELP] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ALT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKSPACE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_CAPS_LOCK] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_CONTROL] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_DELETE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_DOWN] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_END] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ENTER] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ESCAPE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F10] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F11] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F12] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F13] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F14] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F15] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_HOME] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_INSERT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_LEFT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_0] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_ADD] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_ENTER] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PAGE_DOWN] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PAGE_UP] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_RIGHT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SHIFT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SPACE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_TAB] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_UP] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_A] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_B] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_C] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_D] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_E] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_G] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_H] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_I] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_J] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_K] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_L] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_M] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_N] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_O] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_P] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Q] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_R] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_S] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_T] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_U] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_V] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_W] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_X] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Y] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Z] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_0] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_COLON] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_EQUALS] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_HYPHEN] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_TILDE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SQUARELEFT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SQUARERIGHT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKSLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_APOSTROPHE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_TOPLEFT] = EEventType.KEY_RELEASED;
	}

	private function _initPrefabConvertToFilterMap():Void
	{
		_prefabConvertToFilter = new Map<EEventPrefab,Dynamic>();
		
		_prefabConvertToFilter.set(EEventPrefab.CREATED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.UPDATE , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_OVER , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_OUT , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUM_LOCK, EKey.NUM_LOCK);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CLEAR, EKey.CLEAR);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_HELP, EKey.HELP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ALT, EKey.ALT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSPACE, EKey.BACKSPACE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CAPS_LOCK, EKey.CAPS_LOCK);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CONTROL, EKey.CONTROL);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DELETE, EKey.DELETE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DOWN, EKey.DOWN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_END, EKey.END);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ENTER, EKey.ENTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ESCAPE, EKey.ESCAPE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F1, EKey.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F10, EKey.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F11, EKey.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F12, EKey.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F13, EKey.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F14, EKey.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F15, EKey.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F2, EKey.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F3, EKey.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F4, EKey.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F5, EKey.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F6, EKey.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F7, EKey.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F8, EKey.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F9, EKey.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_HOME, EKey.HOME);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_INSERT, EKey.INSERT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LEFT, EKey.LEFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_0, EKey.NUMPAD_0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_1, EKey.NUMPAD_1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_2, EKey.NUMPAD_2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_3, EKey.NUMPAD_3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_4, EKey.NUMPAD_4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_5, EKey.NUMPAD_5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_6, EKey.NUMPAD_6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_7, EKey.NUMPAD_7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_8, EKey.NUMPAD_8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_9, EKey.NUMPAD_9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ADD, EKey.NUMPAD_ADD);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL, EKey.NUMPAD_DECIMAL);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE, EKey.NUMPAD_DIVIDE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ENTER, EKey.NUMPAD_ENTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY, EKey.NUMPAD_MULTIPLY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT, EKey.NUMPAD_SUBTRACT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_DOWN, EKey.PAGE_DOWN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_UP, EKey.PAGE_UP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_RIGHT, EKey.RIGHT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SHIFT, EKey.SHIFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SPACE, EKey.SPACE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_TAB, EKey.TAB);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_UP, EKey.UP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_A, EKey.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_B, EKey.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_C, EKey.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_D, EKey.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_E, EKey.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F, EKey.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_G, EKey.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_H, EKey.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_I, EKey.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_J, EKey.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_K, EKey.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_L, EKey.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_M, EKey.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_N, EKey.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_O, EKey.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_P, EKey.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Q, EKey.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_R, EKey.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_S, EKey.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_T, EKey.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_U, EKey.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_V, EKey.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_W, EKey.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_X, EKey.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Y, EKey.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Z, EKey.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_0, EKey.NUMBER_0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_1, EKey.NUMBER_1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_2, EKey.NUMBER_2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_3, EKey.NUMBER_3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_4, EKey.NUMBER_4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_5, EKey.NUMBER_5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_6, EKey.NUMBER_6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_7, EKey.NUMBER_7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_8, EKey.NUMBER_8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_9, EKey.NUMBER_9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_COLON, EKey.COLON);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_EQUALS, EKey.EQUALS);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_HYPHEN, EKey.HYPHEN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SLASH, EKey.SLASH);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_TILDE, EKey.TILDE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SQUARELEFT, EKey.SQUARELEFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SQUARERIGHT, EKey.SQUARERIGHT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSLASH, EKey.BACKSLASH);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_APOSTROPHE, EKey.APOSTROPHE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_TOPLEFT, EKey.TOPLEFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUM_LOCK, EKey.NUM_LOCK); 
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CLEAR, EKey.CLEAR);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_HELP, EKey.HELP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ALT, EKey.ALT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSPACE, EKey.BACKSPACE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CAPS_LOCK, EKey.CAPS_LOCK);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CONTROL, EKey.CONTROL);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DELETE, EKey.DELETE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DOWN, EKey.DOWN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_END, EKey.END);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ENTER, EKey.ENTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ESCAPE, EKey.ESCAPE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F1, EKey.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F10, EKey.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F11, EKey.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F12, EKey.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F13, EKey.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F14, EKey.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F15, EKey.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F2, EKey.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F3, EKey.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F4, EKey.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F5, EKey.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F6, EKey.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F7, EKey.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F8, EKey.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F9, EKey.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_HOME, EKey.HOME);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_INSERT, EKey.INSERT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LEFT, EKey.LEFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_0, EKey.NUMPAD_0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_1, EKey.NUMPAD_1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_2, EKey.NUMPAD_2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_3, EKey.NUMPAD_3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_4, EKey.NUMPAD_4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_5, EKey.NUMPAD_5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_6, EKey.NUMPAD_6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_7, EKey.NUMPAD_7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_8, EKey.NUMPAD_8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_9, EKey.NUMPAD_9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ADD, EKey.NUMPAD_ADD);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL, EKey.NUMPAD_DECIMAL);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE, EKey.NUMPAD_DIVIDE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ENTER, EKey.NUMPAD_ENTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY, EKey.NUMPAD_MULTIPLY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT, EKey.NUMPAD_SUBTRACT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_DOWN, EKey.PAGE_DOWN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_UP, EKey.PAGE_UP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_RIGHT, EKey.RIGHT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SHIFT, EKey.SHIFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SPACE, EKey.SPACE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_TAB, EKey.TAB);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_UP, EKey.UP);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_A, EKey.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_B, EKey.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_C, EKey.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_D, EKey.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_E, EKey.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F, EKey.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_G, EKey.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_H, EKey.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_I, EKey.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_J, EKey.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_K, EKey.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_L, EKey.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_M, EKey.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_N, EKey.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_O, EKey.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_P, EKey.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Q, EKey.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_R, EKey.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_S, EKey.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_T, EKey.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_U, EKey.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_V, EKey.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_W, EKey.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_X, EKey.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Y, EKey.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Z, EKey.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_0, EKey.NUMBER_0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_1, EKey.NUMBER_1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_2, EKey.NUMBER_2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_3, EKey.NUMBER_3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_4, EKey.NUMBER_4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_5, EKey.NUMBER_5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_6, EKey.NUMBER_6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_7, EKey.NUMBER_7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_8, EKey.NUMBER_8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_9, EKey.NUMBER_9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_COLON, EKey.COLON);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_EQUALS, EKey.EQUALS);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_HYPHEN, EKey.HYPHEN);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SLASH, EKey.SLASH);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_TILDE, EKey.TILDE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SQUARELEFT, EKey.SQUARELEFT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SQUARERIGHT, EKey.SQUARERIGHT);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSLASH, EKey.BACKSLASH);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_APOSTROPHE, EKey.APOSTROPHE);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_TOPLEFT, EKey.TOPLEFT);
	}
}