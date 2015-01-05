/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameAction;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;
import tools.spark.sliced.services.std.logic.gde.interfaces.EConcurrencyType;

/**
 * ...
 * @author Aris Kostakos
 */
class GameEntity extends AGameBase implements IGameEntity
{
	//Properties
	
	public var gameStateSet( default, null ):Map<String,IGameState>;
	public var gameForm( default, default ):IGameForm;
	public var possibleActionSet( default, null ):Map<String,IGameAction>;
	public var currentActionSet( default, null ):Map < String, Array<IGameAction> > ;
	public var children ( get, never ):Array<IGameEntity>; 
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.log ("Game Entity Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameStateSet = new Map<String,IGameState>();
		possibleActionSet = new Map<String,IGameAction>();
		currentActionSet = new Map<String,Array<IGameAction>>();
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
	
	public function setState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value = p_value;
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.updateDisplayObjectState(this,p_stateId);	
		
		return gameStateSet.get(p_stateId).value;
	}
	
	public function addChild(p_gameEntity:IGameEntity):Void
	{
		children.push(p_gameEntity);
		
		//Following line is the weak connection between Logic and Display
		Sliced.display.addDisplayObjectChild(this,p_gameEntity);
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