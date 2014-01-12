/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameAction;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameState;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.EConcurrencyType;
import co.gamep.sliced.core.Sliced;

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
		Console.log ("Game Action Created");
		
		_init();
	}
	
	
	//Methods
	private function _init():Void
	{
		scriptSet = new Array<Int>();
		gameStateSet = new Map<String,IGameState>();
	}
	
	public function addState(gameState:IGameState):Void
	{
		if (gameStateSet[gameState.id] != null)
			Console.warn('A State with id ' + gameState.id + ' already exists in this Action.');
		
		gameStateSet[gameState.id] = gameState;
	}
	
	public function doPass():Void
	{
		for (hashId in scriptSet)
		{
			//if (Sliced.logic.interpreter.run(hashId) == false)
			//	Console.warn('Action $id:HashId $hashId returned false');
			if (hashId == -1)
			{
				Sliced.logic.gmlInterpreter.run(hashId, [ "me"=>parentEntity, "parent"=>parentEntity.parentEntity ]);
			}
			else
			{
				Sliced.logic.scriptInterpreter.run(hashId, [ "me"=>parentEntity, "parent"=>parentEntity.parentEntity ]);
			}
		}
	}
}