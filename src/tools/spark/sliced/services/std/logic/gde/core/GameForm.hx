/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class GameForm extends AGameBase implements IGameForm
{
	//Properties
	
	public var gameStateSet( default, null ):Map<String,IGameState>;
	public var gameSpace( default, default ):IGameSpace;
	
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.info ("Game Form Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameStateSet = new Map<String,IGameState>();
	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameForm
	{
		var l_clonedForm:IGameForm =  new GameForm();
		
		//Parent
		l_clonedForm.parentEntity = p_parentEntity;
		
		//Clone States
		for (state in gameStateSet)
			l_clonedForm.addState(state.clone(p_parentEntity));
			
		//Clone Space
		l_clonedForm.gameSpace = gameSpace.clone(p_parentEntity);
		
		return l_clonedForm;
	}
	
	public function addState(gameState:IGameState):Void
	{
		if (gameStateSet[gameState.id] != null)
			Console.warn('A State with id ' + gameState.id + ' already exists in this Form.');
			
		gameStateSet[gameState.id] = gameState;
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
	
	//Shortcut.. I would call getState, but performance... i would inline the one above, but too much reprocations, bigger file js size. sooo..
	@:keep public function get(p_stateId:String):Dynamic
	{
		if (gameStateSet.get(p_stateId) == null) return null;
		else return gameStateSet.get(p_stateId).value;
	}
	
	public function setState(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value = p_value;
		
		/*  ****************************FORM STATE UPDATE DEPRECATED*************************
		//Following line is the weak connection between Logic and Display
		Sliced.display.updateDisplayObjectFormState(this.parentEntity,p_stateId);	
		*/
		
		return gameStateSet.get(p_stateId).value;
	}
	
	public function set(p_stateId:String, p_value:Dynamic):Dynamic
	{
		gameStateSet.get(p_stateId).value = p_value;
		
		/*  ****************************FORM STATE UPDATE DEPRECATED*************************
		//Following line is the weak connection between Logic and Display
		Sliced.display.updateDisplayObjectFormState(this.parentEntity,p_stateId);	
		*/
		
		return gameStateSet.get(p_stateId).value;
	}
}