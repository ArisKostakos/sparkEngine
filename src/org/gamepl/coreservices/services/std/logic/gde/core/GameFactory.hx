/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.std.logic.gde.core;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameAction;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameClassParser;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameEntity;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameFactory;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameForm;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameSpace;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameState;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.EGameType;

/**
 * ...
 * @author Aris Kostakos
 */
class GameFactory implements IGameFactory
{
	private var _gameclassPackage:String;
	private var _gameClassParser:IGameClassParser;
	
	public function new(p_gameclassPackage:String) 
	{
		Console.log("Creating Game Factory");
		_gameclassPackage = p_gameclassPackage;

		_init();
	}
	
	private function _init():Void
	{
		_gameClassParser = new GameClassParser(_gameclassPackage);
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
				Console.debug(l_gameNode);
				return null;
			}
		}
		else
		{
			Console.error('Game Entity Class is not well-formed or not found!');
			return null;
		}
	}
	
	/*
	public function createGameSpace(p_gameClassName:String):IGameSpace
	{
		//Get the class from the embedded assets folder(preloaded)
		
		//@todo: _the function below may throw an exception. in this case, throw one here too, and a trace saying the class file is not well-formed. Also, return null.
		var l_gameClass:Xml = _parseEmbeddedStringAsset(_getClassUrl(_gameclassPackage, p_gameClassName, _FILEEXTENSION_GAMESPACE));
		
		if (l_gameClass!=null)
		{
			if (_gameClassValidator.validateGameSpaceClass(l_gameClass))
			{
				return _gameClassParser.parseGameSpaceClass(l_gameClass, this);
			}
			else
			{
				Console.error('Game Space Class $p_gameClassName is not valid!');
				return null;
			}
		}
		else
		{
			Console.error('Game Space Class $p_gameClassName is not well-formed!');
			return null;
		}
	}
	
	public function createGameState(p_gameClassName:String):IGameState
	{
		//Get the class from the embedded assets folder(preloaded)
		
		//@todo: _the function below may throw an exception. in this case, throw one here too, and a trace saying the class file is not well-formed. Also, return null.
		var l_gameClass:Xml = _parseEmbeddedStringAsset(_getClassUrl(_gameclassPackage, p_gameClassName, _FILEEXTENSION_GAMESTATE));
		
		if (l_gameClass!=null)
		{
			if (_gameClassValidator.validateGameStateClass(l_gameClass))
			{
				return _gameClassParser.parseGameStateClass(l_gameClass, this);
			}
			else
			{
				Console.error('Game State Class $p_gameClassName is not valid!');
				return null;
			}
		}
		else
		{
			Console.error('Game State Class $p_gameClassName is not well-formed!');
			return null;
		}
	}
	
	public function createGameForm(p_gameClassName:String):IGameForm
	{
		//Get the class from the embedded assets folder(preloaded)
		
		//@todo: _the function below may throw an exception. in this case, throw one here too, and a trace saying the class file is not well-formed. Also, return null.
		var l_gameClass:Xml = _parseEmbeddedStringAsset(_getClassUrl(_gameclassPackage, p_gameClassName, _FILEEXTENSION_GAMEFORM));
		
		if (l_gameClass!=null)
		{
			if (_gameClassValidator.validateGameFormClass(l_gameClass))
			{
				return _gameClassParser.parseGameFormClass(l_gameClass, this);
			}
			else
			{
				Console.error('Game Form Class $p_gameClassName is not valid!');
				return null;
			}
		}
		else
		{
			Console.error('Game Form Class $p_gameClassName is not well-formed!');
			return null;
		}
	}
	
	public function createGameAction(p_gameClassName:String):IGameAction
	{
		//Get the class from the embedded assets folder(preloaded)
		
		//@todo: _the function below may throw an exception. in this case, throw one here too, and a trace saying the class file is not well-formed. Also, return null.
		var l_gameClass:Xml = _parseEmbeddedStringAsset(_getClassUrl(_gameclassPackage, p_gameClassName, _FILEEXTENSION_GAMEACTION));
		
		if (l_gameClass!=null)
		{
			if (_gameClassValidator.validateGameActionClass(l_gameClass))
			{
				return _gameClassParser.parseGameActionClass(l_gameClass, this);
			}
			else
			{
				Console.error('Game Action Class $p_gameClassName is not valid!');
				return null;
			}
		}
		else
		{
			Console.error('Game Action Class $p_gameClassName is not well-formed!');
			return null;
		}
	}
	*/
}