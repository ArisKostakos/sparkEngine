/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameBase;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameAction;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import tools.spark.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

/**
 * ...
 * @author Aris Kostakos
 */
class GameEntity extends AGameBase implements IGameEntity
{
	//Properties
	
	public var gameStateSet( default, null ):Map<String,IGameState>;
	public var gameForm( default, default ):IGameForm;
	public var triggerSet( default, default ):Array<IGameTrigger>; //Trigger references, currently used only for cloning..
	public var possibleActionSet( default, null ):Map<String,IGameAction>;
	public var currentActionSet( default, null ):Map < String, Array<IGameAction> > ;
	public var children ( get, never ):Array<IGameEntity>; 
	public var uid ( default, null ):Int;
	//Constructor
	
	public function new() 
	{
		super();
		
		uid = Sliced.logic.gameFactory.issueUID();
		//Console.log ("Game Entity Created: " + uid);
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameStateSet = new Map<String,IGameState>();
		triggerSet = new Array<IGameTrigger>();
		possibleActionSet = new Map<String,IGameAction>();
		currentActionSet = new Map<String,Array<IGameAction>>();
	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameEntity
	{
		var l_clonedEntity:IGameEntity =  new GameEntity();
		
		//Parent
		l_clonedEntity.parentEntity = p_parentEntity;
		
		//Clone Form
		l_clonedEntity.gameForm = gameForm.clone(l_clonedEntity);
		
		//Clone States
		for (state in gameStateSet)
			l_clonedEntity.addState(state.clone(l_clonedEntity));
		
		//Clone Possible Actions
		for (action in possibleActionSet)
			l_clonedEntity.addAction(action.clone(l_clonedEntity));
			
		//Clone Triggers
		for (trigger in triggerSet)
			l_clonedEntity.addTrigger(trigger.clone(l_clonedEntity));
			
		//Register
		Sliced.logic.registerEntityByName(l_clonedEntity);
		
		//Trigger Event
		Sliced.event.raiseEvent(EEventType.CREATED, l_clonedEntity);
		
		return l_clonedEntity;
	}
	
	public function doActions():Void
	{
		//foreach Action A in my currentActions: A.doPass();
		for ( actions in currentActionSet)
			for (action in actions)
				action.doPass();
			
		//foreach Entity E in my LogicalSpace: E.doActions
		for ( entity in gameForm.gameSpace.gameEntitySet)
			entity.doActions();
	}
	
	public function addState(gameState:IGameState):Void
	{
		if (gameStateSet[gameState.id] != null)
			Console.warn('A State with id ' + gameState.id + ' already exists in this Entity.');
		
		gameStateSet[gameState.id] = gameState;
	}
	
	public function addAction(gameAction:IGameAction):Void
	{
		if (possibleActionSet[gameAction.id] != null)
			Console.warn('An Action with id ' + gameAction.id + ' already exists in this Entity.');
		else
			currentActionSet[gameAction.id] = new Array<IGameAction>();
		
		possibleActionSet[gameAction.id] = gameAction;
	}
	
	public function addTrigger(gameTrigger:IGameTrigger):Void
	{
		triggerSet.push(gameTrigger);
		Sliced.event.addTrigger(gameTrigger); //This might need to be removed to when this entity actually becomes part of the ACTIVE SPACE
	}
	
	public function getAction(p_actionId:String):IGameAction
	{
		return possibleActionSet.get(p_actionId);
	}
	
	//Beta feature, not sure. Runs an action, once, immediately.
	public function forceAction(p_actionId:String):Void
	{
		possibleActionSet.get(p_actionId).doPass();
	}
	
	public function startAction(actionId:String):Bool
	{
		//Get Action Object
		var gameAction:IGameAction = possibleActionSet[actionId];
		
		if (gameAction != null)
		{
			switch (gameAction.concurrency)
			{
				case EConcurrencyType.PARALLEL:
					currentActionSet[gameAction.id].push(gameAction);
				case EConcurrencyType.PERSISTENT:
					if (currentActionSet[gameAction.id].length == 0)
						currentActionSet[gameAction.id].push(gameAction);
				case EConcurrencyType.TRANSIENT:
					while (currentActionSet[gameAction.id].length > 0) currentActionSet[gameAction.id].pop();
					currentActionSet[gameAction.id].push(gameAction);
			}
			
			return true;
		}
		else
		{
			Console.warn("Action with id '" + actionId + "' could not be started.");
			return false;
		}
	}
	
	public function stopAction(actionId:String):Bool
	{
		if (currentActionSet.exists(actionId))
		{
			while (currentActionSet[actionId].length > 0) currentActionSet[actionId].pop();
			return true;
		}
		else
		{
			Console.warn("Action with id '" + actionId + "' could not be stopped.");
			return false;
		}
	}
	
	// Set/Get State Value
	public function getState(p_stateId:String):Dynamic
	{
		if (gameStateSet.get(p_stateId) == null) return null;
		else return gameStateSet.get(p_stateId).value;
	}
	
	//Shortcut.. I would call getState, but performance... i would inline the one above, but too much reprocations, bigger file js size. sooo..
	@:keep public function s(p_stateId:String):Dynamic
	{
		if (gameStateSet.get(p_stateId) == null) return null;
		else return gameStateSet.get(p_stateId).value;
	}
	
	public function getStateType(p_stateId:String):String
	{
		if (gameStateSet.get(p_stateId) == null) return null;
		else return gameStateSet.get(p_stateId).type.getName();
	}
	
	public function setState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		try //Remove this try for optimization reasons at some point...
		{
			gameStateSet.get(p_stateId).value = p_value;
			
			//Following line is the weak connection between Logic and Display
			Sliced.display.updateDisplayObjectState(this,p_stateId);	
			
			return gameStateSet.get(p_stateId).value;
		}
		catch (e:Dynamic) 
		{ 
			Console.error("Could not Set State " + p_stateId + " to: " + p_value + ", for entity: " + getState("name")); 
			return null;
		}
	}
	
	public function addToState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value += p_value;
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.updateDisplayObjectState(this,p_stateId);	
		
		return gameStateSet.get(p_stateId).value;
	}
	
	public function subtractFromState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value -= p_value;
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.updateDisplayObjectState(this,p_stateId);	
		
		return gameStateSet.get(p_stateId).value;
	}
	
	public function addChild(p_gameEntity:IGameEntity):Void
	{
		//Add to children
		children.push(p_gameEntity);
		
		//Set Parent to Child
		p_gameEntity.parentEntity = this;
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.addDisplayObjectChild(this,p_gameEntity);
	}
	
	public function setZorder(p_location:String):Void
	{
		var l_index:Int = parentEntity.children.indexOf(this);
		parentEntity.children.remove(this);
		Console.error("MY INDEX IS: " + l_index);
		
		switch(p_location)
		{
			case "top":
				parentEntity.children.push(this);
			case "oneUp":
				parentEntity.children.insert(l_index + 1, this);
			case "oneDown":
				parentEntity.children.insert(Std.int(Math.max(0,l_index - 1)), this);
			case "bottom":
				parentEntity.children.insert(0,this);
			default:
		}
		
		//Following line is the weak connection between Logic and Display
		setState('command_zOrder', parentEntity.children.indexOf(this));
	}
	
	public function get_zIndex():Int
	{
		return parentEntity.children.indexOf(this);
	}
	
	public function insertChild(p_gameEntity:IGameEntity, p_pos:Int):Void
	{
		//Insert to children
		children.insert(p_pos, p_gameEntity);
		
		//Set Parent to Child
		p_gameEntity.parentEntity = this;
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.insertDisplayObjectChild(this,p_gameEntity,p_pos); //For group layout stuff to work, you need to do a new insert child here, to make an insert on the group objects
	}
	
	public function removeChild(p_gameEntity:IGameEntity):Void
	{
		//Remove from children
		children.remove(p_gameEntity);
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.removeDisplayObjectChild(this,p_gameEntity);
	}
	
	public function remove():Void
	{
		//Remove me
		parent.removeChild(this);
	}
	
	//Removes all children
	public function removeChildren(p_ignoreFirst:Bool=false):Void
	{
		//html bug
		var l_children = [];
		for (f_child in children)
			l_children.push(f_child);
		
		if (p_ignoreFirst)
			l_children.shift();
			
		for (f_child in l_children)
		{
			removeChild(f_child);
		}
	}
	
	public function getChildren():Array<IGameEntity>
	{
		return children;
	}
	
	private function get_children()
	{
		return gameForm.gameSpace.gameEntitySet;
	}
}