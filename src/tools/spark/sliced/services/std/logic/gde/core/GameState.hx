/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.EStateType;

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
		//Console.log ("Game State Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{

	}
}