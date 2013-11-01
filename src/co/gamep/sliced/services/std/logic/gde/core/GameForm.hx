/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameForm;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameState;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;

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
		Console.log ("Game Form Created");
		
		_init();
	}
	
	
	//Methods
	
	private function _init():Void
	{
		gameStateSet = new Map<String,IGameState>();
	}
	
	public function addState(gameState:IGameState):Void
	{
		if (gameStateSet[gameState.id] != null)
			Console.warn('A State with id ' + gameState.id + ' already exists in this Form.');
			
		gameStateSet[gameState.id] = gameState;
	}
}