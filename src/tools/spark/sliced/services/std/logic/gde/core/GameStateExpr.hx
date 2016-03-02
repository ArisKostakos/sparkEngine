/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.EStateType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class GameStateExpr extends AGameBase implements IGameState
{
	//Properties
	public var id( default, default ):String;
	public var type( default, default ):EStateType;
	public var value( get, set ):Dynamic;
	public var actualValue( get, set ):Int;
	
	private var _value:Int; //Hash Id
	
	//Constructor
	
	public function new() 
	{
		super();
		//Console.info ("Game State Created");
		
		//_init();
	}
	
	//Getters
	private function get_value():Dynamic 
	{
		return Sliced.logic.scriptInterpreter.runExpr(_value, parentEntity, parentEntity.parentEntity, this);
	}
	
	private function set_value(p_value:String):Int
	{
		return _value = Sliced.logic.scriptInterpreter.hashExpr(p_value);
	}
	
	private function get_actualValue():Int 
	{
		return _value;
	}
	
	private function set_actualValue(p_value:Int):Int
	{
		return _value = p_value;
	}
	
	//Methods
	
	private function _init():Void
	{

	}
	
	public function clone(?p_parentEntity:IGameEntity):IGameState
	{
		var l_clonedState:GameStateExpr =  new GameStateExpr();
		
		//Parent
		l_clonedState.parentEntity = p_parentEntity;
		
		//Clone the State's Id
		l_clonedState.id = id;
		
		//Clone the State's Type
		l_clonedState.type = type;
		
		//Clone the State's Value
		l_clonedState.actualValue = actualValue; //Copying the hash id..
		
		return l_clonedState;
	}
}