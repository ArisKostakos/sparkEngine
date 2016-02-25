/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.EStateType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class GameState extends AGameBase implements IGameState
{
	//Properties
	public var id( default, default ):String;
	public var type( default, default ):EStateType;
	public var value( default, default ):Dynamic;
	
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.info ("Game State Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{

	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameState
	{
		var l_clonedState:IGameState =  new GameState();
		
		//Parent
		l_clonedState.parentEntity = p_parentEntity;
		
		//Clone the State's Id
		l_clonedState.id = id;
		
		//Clone the State's Type
		l_clonedState.type = type;
		
		//Clone the State's Value
		l_clonedState.value = value; //Good for freshly created states, not good for Dynamic Object States, that will be copied by reference(which we don't want)
		
		return l_clonedState;
	}
}