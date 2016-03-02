/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.core;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameAction;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameClassParser;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameState;
import tools.spark.sliced.services.std.logic.gde.interfaces.EGameType;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class GameFactory implements IGameFactory
{
	private var _gameClassParser:IGameClassParser;
	
	public var instancesCreated:Int = 0; //delete me
	private var _cache:Map<String,IGameEntity>; //external cache
	//later, cache not only factory created entities, but from inside the parser stuff as well
	
	
	private var _numObjects:Int;
	
	public function issueUID():Int
	{
		return _numObjects++;
	}
	
	public function new() 
	{
		Console.log("Creating Game Factory");
		
		_init();
	}
	
	private function _init():Void
	{
		_gameClassParser = new GameClassParser();
		_cache = new Map<String,IGameEntity>();
		_numObjects = 0;
	}
	
	public function createGameEntityExtended(p_gameClassName:String, p_extendGameClassName:String):IGameEntity
	{
		var l_extendGameNode:Xml = _gameClassParser.getGameNode(EGameType.ENTITY, p_extendGameClassName);
		
		l_extendGameNode.set(GameClassParser._XMLATTRIBUTE_EXTENDS,p_gameClassName);
		
		return createGameEntity(l_extendGameNode);
	}
	
	public function createGameEntityByXml(p_gameClassNode:Xml):IGameEntity
	{
		return createGameEntity(null, p_gameClassNode);
	}
	
	public function createGameEntity(?p_gameClassName:String, ?p_gameClassNode:Xml):IGameEntity
	{
		instancesCreated += 1;
		
		if (p_gameClassName != null)
		{
			if (_cache.exists(p_gameClassName))
			{
				if (_cache.get(p_gameClassName) != null)
				{
					//Console.warn("Game Entity exists and not null. CLONING FROM CACHE!!!!");
					return _cache.get(p_gameClassName).clone();
				}
			}
		}
			
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
					//Console.debug(l_gameNode.toString());
					if (p_gameClassName != null)
					{
						//Console.log("Created Game Entity: " + instancesCreated + ", name: " + p_gameClassName);
						if (_cache.exists(p_gameClassName))
						{
							if (_cache.get(p_gameClassName) == null)
							{
								//Console.log("Game Entity exists and is null. Cloning for cache...");
								_cache.set(p_gameClassName, l_gameEntity.clone());
							}
							else
							{
								Console.warn("Game Entity exists and is not null. WE SHOULDN'T BE HERE! SOMETHING IS WRONG!!!!!!!!!!!!!!!!!!!");
							}
						}
						else
						{
							//Console.log("Game Entity does not exist, so doing nothing(this is normal)");
							_cache.set(p_gameClassName, null);
						}
					}
					/*
					else
					{
						Console.log("Created Game Entity: " + instancesCreated + ", By Xml");
					}*/
					
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
				Console.warn(l_gameNode.toString());
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