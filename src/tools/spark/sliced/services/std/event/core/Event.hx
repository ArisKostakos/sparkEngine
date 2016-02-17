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
import flambe.System;

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

	//Forget everything I said.. With our new array, now also include Parameters, so the event is not even triggered, if a trigger with a parameter of this event-entity is not registered
	private var _eventTypeRegisteredTriggers:Map < EEventType, StringMap <Array<IGameTrigger> >> ; //eventType(Map)->eventTarget(Map)->Triggers(Array)
	

	//private var _isExecutingEvents:Bool;
	private var _eventEntries:Array<Dynamic>;
	//private var _eventEntriesFuture:Array<Dynamic>; //trying it out... not sure if nesseccery
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private var _timeBeforePause:Float;
	
	private function _init():Void
	{
		Console.log("Init Event std Service...");
		
		_eventTypeRegisteredTriggers = new Map < EEventType, StringMap < Array<IGameTrigger> >> ();
		
		//_isExecutingEvents = false;
		_eventEntries = new Array<Dynamic>();
		
		//Raise Trigger for Pause/Unpause
		System.hidden.changed.connect(function (hidden,_) {
            if (hidden)
			{
				_timeBeforePause = System.time;
				//Console.error("_timeBeforePause: " + _timeBeforePause);
				raiseEvent(EEventType.PROJECT_PAUSED);
			}
            else
			{
				Sliced.logic.pauseDt = System.time - _timeBeforePause;
				//Console.error("_timeDuringPause: " + Sliced.logic.pauseDt);
				raiseEvent(EEventType.PROJECT_RESUMED);
			}
        });
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
		
		//Convert parameter if nesseccery
		if (p_gameTrigger.parameter != null)
		{
			if (EventType.keyboardStringToKey.exists(p_gameTrigger.parameter))
				p_gameTrigger.parameter = EventType.keyboardStringToKey[p_gameTrigger.parameter];
		}
		
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
		Console.info("Considering raising event for: " + p_eventType + ", eventParameter: " + p_eventParameter);
		if (p_eventTarget!=null) 
			Console.info("Id: " + p_eventTarget.uid + ", name: " + p_eventTarget.getState('name'));
		*/
			
		//ONLY RAISE EVENT, IF WE HAVE A REGISTERED TRIGGER FOR THIS COMBINATION
		if (_eventTypeRegisteredTriggers.exists(p_eventType))
		{
			//Find all the different targets to raise an event for
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
			
			
			
			for (f_eventTarget in l_eventTargets)
			{
				//ONLY RAISE EVENT, IF WE HAVE A REGISTERED TRIGGER FOR THIS COMBINATION
				if (_eventTypeRegisteredTriggers[p_eventType].exists(f_eventTarget))
				{
					/*
					if (_isExecutingEvents)
					{
						if (_eventEntriesFuture == null)
							_eventEntriesFuture = [];
						//For Optimization, the event entry is a weak object
						_eventEntriesFuture.push( { eventType:p_eventType, eventTarget: f_eventTarget, parameter: p_eventParameter, pickedObjects: p_eventTarget } ); //pickedObjects should be an array somehow
					}
					else
					{*/
						//For Optimization, the event entry is a weak object
						_eventEntries.push( { eventType:p_eventType, eventTarget: f_eventTarget, parameter: p_eventParameter, pickedObjects: p_eventTarget } ); //pickedObjects should be an array somehow
					//}
				}
			}
		}
	}

	//inline private function _doTriggers(p_eventType:EEventType, p_eventTargetString:String, p_pickedObject:IGameEntity):Void
	inline private function _doTriggers(p_eventEntry:Dynamic):Void
	{
		for (gameTrigger in _eventTypeRegisteredTriggers[p_eventEntry.eventType].get(p_eventEntry.eventTarget))
		{
			//@note: This is what we need to change if we want ordered events (for ace)
			//instead of a doPass, store them in an array, with a priority id that each trigger will need to have
			//there's no other way
			gameTrigger.pickedObject = p_eventEntry.pickedObjects;
			
			if (gameTrigger.parameter == null || gameTrigger.parameter==p_eventEntry.parameter)
				gameTrigger.doPass();
		}
	}
	
	public function update():Void
	{
		//_isExecutingEvents = true;
		
		while (_eventEntries.length > 0)
			_doTriggers(_eventEntries.pop()); //fuck it.. let's pop..//WARNING!!!!!!!!!!!!! SHIFT MIGHT BE EXPENSIVE ON SOME TARGETS(V8,safari,air???) DO BENCHMARKS!!! maybe reversing the array and popping will be cheaper! IF you want things in order..
		
		
		/*
		for (f_eventEntry in _eventEntries)
			_doTriggers(f_eventEntry);
			
		_isExecutingEvents = false;
		
		//Reset the Flags
		if (_eventEntriesFuture==null)
			_eventEntries = [];
		else
		{
			_eventEntries = _eventEntriesFuture;
			_eventEntriesFuture = null;
		}
		*/
	}
}