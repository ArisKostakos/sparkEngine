/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.ENodeType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EGameType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EStateType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameAction;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameClassInstantiator;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameForm;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameState;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventType;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import co.gamep.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class GameClassInstantiator implements IGameClassInstantiator
{
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _xmlConcurrencyNameToType:Map<String,EConcurrencyType>;
	private var _xmlStateNameToType:Map<String,EStateType>;
	private var _xmlEventNameToPrefab:Map<String,EEventPrefab>;
	
	public function new(p_xmlNodeTypeToNodeName:Map<ENodeType,String>, p_xmlConcurrencyNameToType:Map<String,EConcurrencyType>, p_xmlStateNameToType:Map<String,EStateType>, p_xmlEventNameToPrefab:Map<String,EEventPrefab>) 
	{
		Console.log("Creating Game Class Instantiator");
		_xmlNodeTypeToNodeName = p_xmlNodeTypeToNodeName;
		_xmlConcurrencyNameToType = p_xmlConcurrencyNameToType;
		_xmlStateNameToType = p_xmlStateNameToType;
		_xmlEventNameToPrefab = p_xmlEventNameToPrefab;
		_init();
	}
	
	private function _init():Void
	{
		
	}
		
	
	
	public function instantiateEntity(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameEntity
	{
		var l_gameEntity:IGameEntity = new GameEntity();
		
		//Parent Entity
		l_gameEntity.parentEntity = p_parentEntity;
		
		//Create the Entity's Form
		l_gameEntity.gameForm = instantiateForm(p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.FORM]).next(),l_gameEntity);
		
		//Create the Entity's States
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).hasNext())
		{
			var states:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).next();
			for ( state in  states.elements()) 
			{
				l_gameEntity.addState(instantiateState(state,l_gameEntity));
			}
		}
		
		//Create the Entity's Actions
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ACTIONS]).hasNext())
		{
			var actions:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ACTIONS]).next();
			for ( action in actions.elements()) 
			{
				var f_gameAction:IGameAction = instantiateAction(action, l_gameEntity);
				
				l_gameEntity.addAction(f_gameAction);
			}
		}
		
		//Create the Entity's Triggers
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.TRIGGERS]).hasNext())
		{
			var triggers:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.TRIGGERS]).next();
			for ( trigger in triggers.elements()) 
			{
				var f_gameTrigger:IGameTrigger = instantiateTrigger(trigger,l_gameEntity);
				
				Sliced.event.addTrigger(f_gameTrigger);
			}
		}
		
		Sliced.event.raiseEvent(EEventType.CREATED,l_gameEntity);
		return l_gameEntity;
	}
	
	public function instantiateForm(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameForm
	{
		var l_gameForm:IGameForm = new GameForm();
		
		//Parent Entity
		l_gameForm.parentEntity = p_parentEntity;
		
		//Create the Form's States
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).hasNext())
		{
			var states:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).next();
			for ( state in  states.elements()) 
			{
				l_gameForm.addState(instantiateState(state,p_parentEntity));
			}
		}
		
		//Create the Form's Space
		l_gameForm.gameSpace = instantiateSpace(p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.SPACE]).next(),p_parentEntity);
		
		return l_gameForm;
	}
	
	public function instantiateSpace(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameSpace
	{
		var l_gameSpace:IGameSpace = new GameSpace();
		
		//Parent Entity
		l_gameSpace.parentEntity = p_parentEntity;
		
		//Create the Space's Entities
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ENTITIES]).hasNext())
		{
			var entities:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ENTITIES]).next();
			for ( entity in  entities.elements()) 
			{
				l_gameSpace.gameEntitySet.push(instantiateEntity(entity,p_parentEntity));
			}
		}
		
		return l_gameSpace;
	}
	
	public function instantiateState(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameState
	{
		var l_gameState:IGameState = new GameState();
		
		//Parent Entity
		l_gameState.parentEntity = p_parentEntity;
		
		//Create the State's Id
		l_gameState.id = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ID]).next().firstChild().nodeValue;
		
		//Create the State's Type
		l_gameState.type = _xmlStateNameToType[p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.TYPE]).next().firstChild().nodeValue];
		
		//Create the State's Value
		var l_valueInString:String = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.VALUE]).next().firstChild().nodeValue;
		//Typecast it
		switch(l_gameState.type)
		{
			case EStateType.BOOLEAN:
				l_gameState.value = (l_valueInString == "true" || l_valueInString == "True" || l_valueInString == "t" || l_valueInString == "T");
			case EStateType.DECIMAL:
				l_gameState.value = Std.parseFloat(l_valueInString);
			case EStateType.INTEGER:
				l_gameState.value = Std.parseInt(l_valueInString);
			case EStateType.TEXT:
				l_gameState.value = l_valueInString;
			case EStateType.DYNAMIC:
				l_gameState.value = null;
		}
		
		
		return l_gameState;
	}
	
	public function instantiateAction(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameAction
	{
		var l_gameAction:IGameAction = new GameAction();
		
		//Parent Entity
		l_gameAction.parentEntity = p_parentEntity;
		
		//Create the Action's Id
		l_gameAction.id = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ID]).next().firstChild().nodeValue;
		
		//Create the Actions's Concurrency
		l_gameAction.concurrency = _xmlConcurrencyNameToType[p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.CONCURRENCY]).next().firstChild().nodeValue];
		
		//Create the Action's Scripts
		var scripts:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS]).next();
		for ( script in scripts.elements()) 
		{
			if (script.nodeName == _xmlNodeTypeToNodeName[ENodeType.SCRIPT])
			{
				l_gameAction.scriptSet.push(Sliced.logic.scriptInterpreter.hash(script.firstChild().nodeValue));
			}
			else
			{
				l_gameAction.scriptSet.push(Sliced.logic.gmlInterpreter.hash(script.firstChild().nodeValue));
			}
		}
		
		//Create the Action's States
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).hasNext())
		{
			var states:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.STATES]).next();
			for ( state in states.elements()) 
			{
				l_gameAction.addState(instantiateState(state,p_parentEntity));
			}
		}		
		
		return l_gameAction;
	}
	
	public function instantiateTrigger(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameTrigger
	{
		var l_gameTrigger:IGameTrigger = new GameTrigger();
		
		//Parent Entity
		l_gameTrigger.parentEntity = p_parentEntity;
		
		//Create the Trigger's Event Type
		l_gameTrigger.eventPrefab = _xmlEventNameToPrefab[p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.EVENT]).next().firstChild().nodeValue];
		
		//Create the Trigger's Scripts
		var scripts:Xml = p_gameNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.SCRIPTS]).next();
		for ( script in scripts.elements()) 
		{
			if (script.nodeName == _xmlNodeTypeToNodeName[ENodeType.SCRIPT])
			{
				l_gameTrigger.scriptSet.push(Sliced.logic.scriptInterpreter.hash(script.firstChild().nodeValue));
			}
			else
			{
				l_gameTrigger.scriptSet.push(Sliced.logic.gmlInterpreter.hash(script.firstChild().nodeValue));
			}
		}
		
		return l_gameTrigger;
	}
}