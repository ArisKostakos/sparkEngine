/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.core;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameAction;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameClassParser;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameFactory;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameForm;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameState;
import co.gamep.sliced.services.std.logic.gde.interfaces.EGameType;

/**
 * ...
 * @author Aris Kostakos
 */
class GameFactory implements IGameFactory
{
	private var _gameClassParser:IGameClassParser;
	
	public function new() 
	{
		Console.log("Creating Game Factory");
		
		_init();
	}
	
	private function _init():Void
	{
		_gameClassParser = new GameClassParser();
	}
	
	public function createGameEntity(?p_gameClassName:String, ?p_gameClassNode:Xml):IGameEntity
	{
		//Get the class from the embedded assets folder(preloaded)
		var l_gameNode:Xml = _gameClassParser.getGameNode(EGameType.ENTITY, p_gameClassName, p_gameClassNode);
		
		if (l_gameNode!=null)
		{
			if (_gameClassParser.parseGameNode(l_gameNode))
			{
				//Instantiate Parsed Node
				var l_gameEntity:IGameEntity = _gameClassParser.instantiateEntity(l_gameNode);
				
				if (l_gameEntity != null)
				{
					return l_gameEntity;
				}
				else
				{
					Console.error('Game Entity could not be instantiated');
					return null;	
				}
			}
			else
			{
				Console.error('Game Entity could not be parsed');
				//Console.debug(l_gameNode);
				return null;
			}
		}
		else
		{
			Console.error('Game Entity Class is not well-formed or not found!');
			return null;
		}
	}
}