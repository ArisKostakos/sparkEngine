/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, September 2013
 */

package tools.spark.sliced.services.std.event.core;

import flambe.input.Key;
import haxe.ds.StringMap;
import tools.spark.sliced.interfaces.IEvent;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * @author Aris Kostakos
 */
class Event extends AService implements IEvent
{
	//Ok so Event is REALLY IMPROVED.. one thing left... the way I'm doing it now, parameters are not hashed.. To not create so many maps on every raise event..
	//What I could do is define some EventTypes, to have Targets, or not have targets.. and also to have parameters, or not to have parameters..
	//So now for events that have targets, an extra bool array is created, instead of just a bool... if it also has parameters, then it doesn't create a bool array,
	//it creates an objerct.object map and on that end we create a bool array.. you see what I mean.. dynamic.. but I think that's also some overhead
	//so maybe it balances itself out with the way i do it
	//problem with this method is, if I have like 100 triggers about an event each with a different parameter, when this trigger is raised, ALL triggers will be raised,
	//and later check their parameter to see if its valid... so that only maybe 1 will run at the end..
	
	
	//Also, instead of the NO_TRIGGER filter, you just check if i have ANY filters for that event. if true, then raise the NO_FILTER. Small optimization but
	//it could be worth it in the long run. Checking for true/false flags on EVERY FRAME is costly and dangerous.
	private var _eventTypeRaisedFlags:Map < EEventType, StringMap <IGameEntity >> ; //eventType(Map)->eventTarget(Map)->IGameEntity We use the GameEntity to pick the gameEntity that caused the trigger, if any (else null)
	private var _eventTypeRegisteredTriggers:Map < EEventType, StringMap <Array<IGameTrigger> >> ; //eventType(Map)->eventTarget(Map)->Triggers(Array)
	
	private var _isExecutingEvents:Bool;
	private var _eventTypeRaisedFlagsFuture:Map < EEventType, StringMap <IGameEntity >> ;
	//For Optimization, I think we should keep a 2 level hash like we do now and don't hash the event parameter.. If this even is triggered, check for parameters
	//before you actually trigger it.. This way we don't create Maps all the time.. How costly is creating a Map I wonder..
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Event std Service...");
		
		_eventTypeRaisedFlags = new Map < EEventType, StringMap <IGameEntity >> ();
		_eventTypeRegisteredTriggers = new Map < EEventType, StringMap < Array<IGameTrigger> >> ();
		_isExecutingEvents = false;
	}
	
	public function addTrigger(p_gameTrigger:IGameTrigger):Void
	{
		var l_eventType:EEventType = p_gameTrigger.eventType;
		var l_eventTarget:String = p_gameTrigger.target;
		
		//Console.error("l_eventType: " + l_eventType);
		//Console.error("l_eventTarget: " + l_eventTarget);
		//Replace Filter with an appropriate variable if needed
		if (l_eventTarget == EventType.TARGET_VAR_ME)
		{
			l_eventTarget = Std.string(p_gameTrigger.parentEntity.uid);
		}
		
		//Add additional filter variable changes here
		//...
		
		//Create a slot for the eventType
		if (_eventTypeRegisteredTriggers.exists(l_eventType) == false)
			_eventTypeRegisteredTriggers.set(l_eventType, new StringMap <Array<IGameTrigger> > () );
		
		//Create a slot for the eventTarget
		if (_eventTypeRegisteredTriggers[l_eventType].exists(l_eventTarget) == false)
			_eventTypeRegisteredTriggers[l_eventType].set(l_eventTarget, new Array<IGameTrigger>() );
		
		//Push the trigger to the correct slot
		_eventTypeRegisteredTriggers.get(l_eventType).get(l_eventTarget).push(p_gameTrigger);
		
		/*
		//Register Triggers to appropriate Services (where needed)
		if (	l_eventType == MOUSE_LEFT_CLICK ||
				l_eventType == MOUSE_RIGHT_CLICK ||
				l_eventType == MOUSE_ENTERED ||
				l_eventType == MOUSE_MOVED ||
				l_eventType == MOUSE_LEFT ||
				l_eventType == MOUSE_DOWN ||
				l_eventType == MOUSE_UP
		   )
		{
			Sliced.input.pointer.registerTrigger(l_eventType,l_eventTarget);
		}
		*/
	}
	
	public function raiseEvent(p_eventType:EEventType, ?p_eventTarget:IGameEntity, ?p_eventParameter:Dynamic):Void
	{
		/*
		Console.info("Considering raising event for: " + p_eventType);
		if (p_eventTarget!=null) 
			Console.info("Id: " + p_eventTarget.uid + ", name: " + p_eventTarget.getState('name'));
		*/
			
		//ONLY RAISE EVENT, IF WE HAVE A REGISTERED TRIGGER FOR THIS COMBINATION
		if (_eventTypeRegisteredTriggers.exists(p_eventType))
		{
			//Find all the different targets to raise en event for
			var l_eventTargets:Array<String> = new Array<String>();
		
			if (p_eventTarget == null)
				l_eventTargets.push(EventType.TARGET_NONE);
			else
			{
				//This is for a generic call that 'an' entity did something.. any entity.. meh..
				//l_eventTargets.push(EventType.TARGET_NONE);
				
				//Raise the uid
				l_eventTargets.push(Std.string(p_eventTarget.uid));
				
				//Raise the name
				l_eventTargets.push(Std.string(p_eventTarget.getState('name')));
				
				//Raise the groups
				//..
			}
			
			if (_isExecutingEvents)
			{
				if (_eventTypeRaisedFlagsFuture==null)
					_eventTypeRaisedFlagsFuture = new Map < EEventType, StringMap < IGameEntity >> ();
					
				_raiseFlags(l_eventTargets, p_eventType, p_eventTarget, _eventTypeRaisedFlagsFuture);
			}
			else
				_raiseFlags(l_eventTargets, p_eventType, p_eventTarget, _eventTypeRaisedFlags);
		}
	}
	
	inline private function _raiseFlags(p_eventTargets:Array<String>, p_eventType:EEventType, p_eventTarget:IGameEntity, p_flagsArray:Map < EEventType, StringMap <IGameEntity >>):Void
	{
		for (f_eventTarget in p_eventTargets)
		{
			if (_eventTypeRegisteredTriggers[p_eventType].exists(f_eventTarget))
			{
				//Create a slot for the raised eventType
				if (p_flagsArray.exists(p_eventType) == false)
					p_flagsArray[p_eventType] = new StringMap <IGameEntity > ();
					
				p_flagsArray[p_eventType].set(f_eventTarget, p_eventTarget); //p_eventTarget is stored so we can pick the object triggering stuff, if there is one
				//Console.info("Event Raised: " + p_eventType + ", f_eventTarget: " + f_eventTarget + ", for next frame: " + _isExecutingEvents);
			}
		}
	}
	
	
	inline private function _doTriggers(p_eventType:EEventType, p_eventTargetString:String, p_pickedObject:IGameEntity):Void
	{
		//Console.info("Activating triggers for: " + p_eventType);
		
		for (gameTrigger in _eventTypeRegisteredTriggers[p_eventType].get(p_eventTargetString))
		{
			//@note: This is what we need to change if we want ordered events (for ace)
			//instead of a doPass, store them in an array, with a priority id that each trigger will need to have
			//there's no other way
			gameTrigger.pickedObject = p_pickedObject;
			
			gameTrigger.doPass();
		}
	}
	
	public function update():Void
	{
		_isExecutingEvents = true;
		
		for (flag in _eventTypeRaisedFlags.keys())
		{
			//Console.warn("TRAVERSED an EVENTTYPE: " + flag);
			//if (_eventTypeFilterFlags[flag].get(_NO_FILTER) == true)
			//{
				for (targetFlag in _eventTypeRaisedFlags[flag].keys())
				{
					//Console.warn("DOING TRIGGERS FOR EVENTTYPE->TARGET: " + targetFlag);
					//if (_eventTypeFilterFlags[flag].get(filterFlag) == true)
					//{
						//_eventTypeFilterFlags[flag].set(targetFlag, false);
						_doTriggers(flag, targetFlag, _eventTypeRaisedFlags[flag].get(targetFlag));
					//}
				}
			//}
		}
		_isExecutingEvents = false;

		//Reset the Flags
		if (_eventTypeRaisedFlagsFuture==null)
			_eventTypeRaisedFlags = new Map < EEventType, StringMap < IGameEntity >> ();
		else
		{
			_eventTypeRaisedFlags = _eventTypeRaisedFlagsFuture;
			_eventTypeRaisedFlagsFuture = null;
		}
	}
	
	///////////////////////////
	/*
	private function _initPrefabConvertToTypeMap():Void
	{
		_prefabConvertToType = new Map<EEventPrefab,EEventType>();
		
		_prefabConvertToType[EEventPrefab.CREATED] = EEventType.CREATED;
		_prefabConvertToType[EEventPrefab.UPDATE] = EEventType.UPDATE;
		_prefabConvertToType[EEventPrefab.CHANGED] = EEventType.CHANGED;
		_prefabConvertToType[EEventPrefab.NETWORK_CONNECTED] = EEventType.NETWORK_CONNECTED;
		_prefabConvertToType[EEventPrefab.NETWORK_REQUEST] = EEventType.NETWORK_REQUEST;
		_prefabConvertToType[EEventPrefab.NETWORK_SERVER_EVENT] = EEventType.NETWORK_SERVER_EVENT;
		_prefabConvertToType[EEventPrefab.FILETRANSFER_CONNECTED] = EEventType.FILETRANSFER_CONNECTED;
		_prefabConvertToType[EEventPrefab.FILETRANSFER_SENDREQUEST] = EEventType.FILETRANSFER_SENDREQUEST;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICK] = EEventType.MOUSE_LEFT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICK] = EEventType.MOUSE_RIGHT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_DOWN] = EEventType.MOUSE_LEFT_DOWN;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_DOWN] = EEventType.MOUSE_RIGHT_DOWN;
		_prefabConvertToType[EEventPrefab.MOUSE_SCROLL] = EEventType.MOUSE_SCROLL;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICKED] = EEventType.MOUSE_LEFT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICKED] = EEventType.MOUSE_RIGHT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_ENTERED] = EEventType.MOUSE_ENTERED;
		_prefabConvertToType[EEventPrefab.MOUSE_MOVED] = EEventType.MOUSE_MOVED;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT] = EEventType.MOUSE_LEFT;
		_prefabConvertToType[EEventPrefab.MOUSE_DOWN] = EEventType.MOUSE_DOWN;
		_prefabConvertToType[EEventPrefab.MOUSE_UP] = EEventType.MOUSE_UP;
		_prefabConvertToType[EEventPrefab.ON_DRAG_START] = EEventType.ON_DRAG_START;
		_prefabConvertToType[EEventPrefab.ON_DRAG] = EEventType.ON_DRAG;
		_prefabConvertToType[EEventPrefab.ON_DRAG_END] = EEventType.ON_DRAG_END;
		_prefabConvertToType[EEventPrefab.ON_DRAG_ENTER] = EEventType.ON_DRAG_ENTER;
		_prefabConvertToType[EEventPrefab.ON_DRAG_OVER] = EEventType.ON_DRAG_OVER;
		_prefabConvertToType[EEventPrefab.ON_DRAG_LEAVE] = EEventType.ON_DRAG_LEAVE;
		_prefabConvertToType[EEventPrefab.ON_DROP] = EEventType.ON_DROP;
		_prefabConvertToType[EEventPrefab.PHYSICS_COLLISION_START] = EEventType.PHYSICS_COLLISION_START;
		_prefabConvertToType[EEventPrefab.PHYSICS_COLLISION_END] = EEventType.PHYSICS_COLLISION_END;
		_prefabConvertToType[EEventPrefab.PHYSICS_SENSOR_START] = EEventType.PHYSICS_SENSOR_START;
		_prefabConvertToType[EEventPrefab.PHYSICS_SENSOR_START_BIPED_FEET] = EEventType.PHYSICS_SENSOR_START_BIPED_FEET;
		_prefabConvertToType[EEventPrefab.PHYSICS_SENSOR_END] = EEventType.PHYSICS_SENSOR_END;
		_prefabConvertToType[EEventPrefab.PHYSICS_SENSOR_END_BIPED_FEET] = EEventType.PHYSICS_SENSOR_END_BIPED_FEET;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_LOCAL] = EEventType.KEY_PRESSED_LOCAL;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_LOCAL] = EEventType.KEY_RELEASED_LOCAL;
		_prefabConvertToType[EEventPrefab.KEY_DOWN_LOCAL] = EEventType.KEY_DOWN_LOCAL;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED] = EEventType.KEY_RELEASED;
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
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_EQUALS] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKSLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_LEFTBRACKET] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_RIGHTBRACKET] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKQUOTE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_COMMA] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_COMMAND] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_MINUS] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PERIOD] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_QUOTE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SEMICOLON] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ANDROIDMENU] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ANDROIDSEARCH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_UNKNOWN] = EEventType.KEY_PRESSED;
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
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_EQUALS] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKSLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_LEFTBRACKET] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_RIGHTBRACKET] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKQUOTE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_COMMA] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_COMMAND] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_MINUS] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PERIOD] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_QUOTE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SEMICOLON] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ANDROIDMENU] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ANDROIDSEARCH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_UNKNOWN] = EEventType.KEY_RELEASED;
	}

	private function _initPrefabConvertToFilterMap():Void
	{
		_prefabConvertToFilter = new Map<EEventPrefab,Dynamic>();
		
		_prefabConvertToFilter.set(EEventPrefab.CREATED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.UPDATE , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.CHANGED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.NETWORK_CONNECTED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.NETWORK_REQUEST , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.NETWORK_SERVER_EVENT , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.FILETRANSFER_CONNECTED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.FILETRANSFER_SENDREQUEST , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_DOWN , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_DOWN , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_SCROLL , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_ENTERED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_MOVED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_DOWN , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_UP , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG_START , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG_END , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG_ENTER , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG_OVER , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DRAG_LEAVE , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.ON_DROP , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_COLLISION_START , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_COLLISION_END , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_SENSOR_START , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_SENSOR_START_BIPED_FEET , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_SENSOR_END , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.PHYSICS_SENSOR_END_BIPED_FEET , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LOCAL , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LOCAL , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_DOWN_LOCAL , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ALT, Key.Alt);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSPACE, Key.Backspace);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CAPS_LOCK, Key.CapsLock);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CONTROL, Key.Control);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DELETE, Key.Delete);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DOWN, Key.Down);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_END, Key.End);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ENTER, Key.Enter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ESCAPE, Key.Escape);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F1, Key.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F10, Key.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F11, Key.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F12, Key.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F13, Key.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F14, Key.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F15, Key.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F2, Key.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F3, Key.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F4, Key.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F5, Key.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F6, Key.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F7, Key.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F8, Key.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F9, Key.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_HOME, Key.Home);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_INSERT, Key.Insert);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LEFT, Key.Left);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_0, Key.Numpad0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_1, Key.Numpad1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_2, Key.Numpad2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_3, Key.Numpad3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_4, Key.Numpad4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_5, Key.Numpad5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_6, Key.Numpad6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_7, Key.Numpad7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_8, Key.Numpad8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_9, Key.Numpad9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ADD, Key.NumpadAdd);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL, Key.NumpadDecimal);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE, Key.NumpadDivide);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ENTER, Key.NumpadEnter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY, Key.NumpadMultiply);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT, Key.NumpadSubtract);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_DOWN, Key.PageDown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_UP, Key.PageUp);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_RIGHT, Key.Right);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SHIFT, Key.Shift);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SPACE, Key.Space);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_TAB, Key.Tab);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_UP, Key.Up);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_A, Key.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_B, Key.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_C, Key.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_D, Key.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_E, Key.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F, Key.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_G, Key.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_H, Key.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_I, Key.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_J, Key.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_K, Key.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_L, Key.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_M, Key.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_N, Key.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_O, Key.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_P, Key.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Q, Key.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_R, Key.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_S, Key.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_T, Key.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_U, Key.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_V, Key.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_W, Key.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_X, Key.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Y, Key.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Z, Key.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_0, Key.Number0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_1, Key.Number1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_2, Key.Number2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_3, Key.Number3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_4, Key.Number4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_5, Key.Number5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_6, Key.Number6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_7, Key.Number7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_8, Key.Number8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_9, Key.Number9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_EQUALS, Key.Equals);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SLASH, Key.Slash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSLASH, Key.Backslash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LEFTBRACKET, Key.LeftBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_RIGHTBRACKET, Key.RightBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKQUOTE, Key.Backquote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_COMMA, Key.Comma);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_COMMAND, Key.Command);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_MINUS, Key.Minus);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PERIOD, Key.Period);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_QUOTE, Key.Quote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SEMICOLON, Key.Semicolon);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ANDROIDMENU, Key.Menu);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ANDROIDSEARCH, Key.Search);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_UNKNOWN, Key.Unknown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ALT, Key.Alt);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSPACE, Key.Backspace);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CAPS_LOCK, Key.CapsLock);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CONTROL, Key.Control);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DELETE, Key.Delete);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DOWN, Key.Down);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_END, Key.End);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ENTER, Key.Enter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ESCAPE, Key.Escape);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F1, Key.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F10, Key.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F11, Key.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F12, Key.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F13, Key.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F14, Key.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F15, Key.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F2, Key.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F3, Key.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F4, Key.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F5, Key.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F6, Key.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F7, Key.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F8, Key.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F9, Key.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_HOME, Key.Home);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_INSERT, Key.Insert);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LEFT, Key.Left);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_0, Key.Numpad0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_1, Key.Numpad1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_2, Key.Numpad2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_3, Key.Numpad3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_4, Key.Numpad4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_5, Key.Numpad5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_6, Key.Numpad6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_7, Key.Numpad7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_8, Key.Numpad8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_9, Key.Numpad9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ADD, Key.NumpadAdd);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL, Key.NumpadDecimal);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE, Key.NumpadDivide);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ENTER, Key.NumpadEnter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY, Key.NumpadMultiply);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT, Key.NumpadSubtract);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_DOWN, Key.PageDown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_UP, Key.PageUp);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_RIGHT, Key.Right);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SHIFT, Key.Shift);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SPACE, Key.Space);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_TAB, Key.Tab);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_UP, Key.Up);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_A, Key.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_B, Key.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_C, Key.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_D, Key.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_E, Key.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F, Key.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_G, Key.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_H, Key.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_I, Key.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_J, Key.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_K, Key.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_L, Key.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_M, Key.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_N, Key.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_O, Key.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_P, Key.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Q, Key.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_R, Key.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_S, Key.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_T, Key.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_U, Key.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_V, Key.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_W, Key.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_X, Key.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Y, Key.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Z, Key.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_0, Key.Number0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_1, Key.Number1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_2, Key.Number2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_3, Key.Number3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_4, Key.Number4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_5, Key.Number5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_6, Key.Number6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_7, Key.Number7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_8, Key.Number8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_9, Key.Number9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_EQUALS, Key.Equals);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SLASH, Key.Slash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSLASH, Key.Backslash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LEFTBRACKET, Key.LeftBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_RIGHTBRACKET, Key.RightBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKQUOTE, Key.Backquote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_COMMA, Key.Comma);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_COMMAND, Key.Command);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_MINUS, Key.Minus);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PERIOD, Key.Period);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_QUOTE, Key.Quote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SEMICOLON, Key.Semicolon);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ANDROIDMENU, Key.Menu);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ANDROIDSEARCH, Key.Search);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_UNKNOWN, Key.Unknown);
	}*/
}