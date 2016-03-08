/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameAction;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class GameAction extends AGameBase implements IGameAction
{
	//Properties
	public var id( default, default ):String;
	public var gameStateSet( default, null ):Map<String,IGameState>;
	public var concurrency( default, default ):EConcurrencyType;
	public var scriptSet( default, null ):Array<Int>;
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.info ("Game Action Created");
		
		_init();
	}
	
	
	//Methods
	private function _init():Void
	{
		scriptSet = new Array<Int>();
		gameStateSet = new Map<String,IGameState>();
	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameAction
	{
		var l_clonedAction:IGameAction =  new GameAction();
		
		//Parent
		l_clonedAction.parentEntity = p_parentEntity;
		
		//Clone the Action's Id
		l_clonedAction.id = id;
		
		//Clone the Actions's Concurrency
		l_clonedAction.concurrency = concurrency;
		
		//Clone the Action's Scripts
		for (scriptId in scriptSet)
			l_clonedAction.scriptSet.push(scriptId);
		
		//Clone the Action's States
		for (state in gameStateSet)
			l_clonedAction.addState(state.clone(p_parentEntity));
		
		return l_clonedAction;
	}
	
	public function addState(gameState:IGameState):Void
	{
		if (gameStateSet[gameState.id] != null)
			Console.warn('A State with id ' + gameState.id + ' already exists in this Action.');
		
		gameStateSet[gameState.id] = gameState;
	}
	
	public function doPass():Void
	{
		//This would only work if we return what execute returns.. no it returns false if it failed to run..
		//if (Sliced.logic.interpreter.run(hashId) == false)
			//Console.warn('Action $id:HashId $hashId returned false');
			
		for (hashId in scriptSet)
		{
			if (hashId == -1)
			{
				Sliced.logic.gmlInterpreter.run(hashId, ["it" => this, "me"=>parentEntity, "parent"=>parentEntity.parentEntity ]);
			}
			else
			{
				if (Sliced.logic.scriptInterpreter.run(hashId, ["it" => this, "me" => parentEntity, "parent" => parentEntity.parentEntity ]) == false)
				{
					Console.error('Error: Failed to run Action [$id].');
					parentEntity.stopAction(id);
				}
			}
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
	
	public function setState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value = p_value;
		
		return gameStateSet.get(p_stateId).value;
	}
	
	@:keep public function addToState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value += p_value;
		
		return gameStateSet.get(p_stateId).value;
	}
	
	@:keep public function subtractFromState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value -= p_value;
		
		return gameStateSet.get(p_stateId).value;
	}
	
	@:keep public function stop():Void
	{
		parentEntity.stopAction(id);
	}
}